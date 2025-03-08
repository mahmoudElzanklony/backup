<?php

namespace App\Console\Commands;

use App\Jobs\BackupJob;
use Aws\S3\S3Client;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Storage;
use PHPUnit\Exception;
use Spatie\DbDumper\Databases\MySql;
use Spatie\DbDumper\DbDumper;
use Symfony\Component\Process\Exception\ProcessFailedException;
use Symfony\Component\Process\Process;

class BackupCommand extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'backup';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Command description';

    /**
     * Execute the console command.
     */
    public function handle()
    {
        $this->info('Starting the database backup process...');
        $username = config('database.connections.mysql.username');
        $password = env('DB_PASSWORD');
        $host = config('database.connections.mysql.host');
        $port = config('database.connections.mysql.port');




        if(env('DB_CLUSTER_USERNAME')) {
            $this->process_databases(env('DB_CLUSTER_USERNAME'),
                env('DB_CLUSTER_PASSWORD'),
                env('DB_CLUSTER_HOST'),
                env('DB_CLUSTER_PORT'), '_cluster');
        }

        $this->process_databases($username, $password, $host, $port, '_new_ilearn_droplet');


    }

    public function cluster_dump($username, $password, $host, $port,$database)
    {
        $localPath = storage_path('education_backup_cluster_'.now()->format('Y_m_d_His').'.sql');
        // Command to run mysqldump and write to education.sql
        Log::info("start dump cluster" );
        $command = sprintf(
            'mysqldump --user=%s --password=%s --host=%s --port=%s --single-transaction %s > %s',
            escapeshellarg($username),
            escapeshellarg($password),
            escapeshellarg($host),
            escapeshellarg($port),
            escapeshellarg($database),
            escapeshellarg($localPath)
        );

        // Execute the command
        $output = shell_exec($command);
        $this->uploadToWasabi($localPath, 'education','cluster');
    }

    public function process_databases($username , $password , $host , $port,$host_type = '')
    {
        if($host_type != ''){
            $this->cluster_dump($username , $password , $host , $port,'education');
        }else {
            $this->info('username is ... ' . $username);
            $this->info('host is ...' . $host);
            try{
                $process = new Process([
                    'mysql',
                    '--user=' . $username,
                    '--password=' . $password,
                    '--host=' . $host,
                    '--port=' . $port,
                    '-e', 'SHOW DATABASES;'
                ]);

                $process->setTimeout(120);


                $process->run();
            }catch (ProcessFailedException $exception){
                $this->info($exception->getMessage());
            }


            if (!$process->isSuccessful()) {
                throw new ProcessFailedException($process);
            }

            $databases = array_filter(explode("\n", $process->getOutput()), function ($db) {
                // Ignore system databases
                return !in_array($db, ['Database', 'information_schema', 'performance_schema', 'mysql', 'sys']);
            });


            // Step 2: Backup each database
            foreach ($databases as $database) {
                Log::info("database is ==> $database");
                $this->backupDatabase($database, $username, $password, $host, $port, $host_type);
            }
        }
    }

    private function backupDatabase($database, $username, $password, $host, $port ,$host_type = '')
    {
        $timestamp = now()->format('Y_m_d_His');
        $filename = "{$database}_backup_{$timestamp}.sql";
        if($host_type != ''){
            $filename = "{$database}_backup_{$host_type}_{$timestamp}.sql";
        }
        Log::info("file name is : $filename");
        $localPath = storage_path("app/{$filename}");
        Log::info("Starting backup for database: $database");
        if (empty($database)) {
            Log::error("Skipping backup for empty database name.");
            return;
        }

        // Create a backup file using spatie/db-dumper
        MySql::create()
            ->setTimeout(300)
            ->setHost($host)
            ->setDbName($database)
            ->setUserName($username)
            ->setPassword($password)
            ->dumpToFile($localPath);



        // Now upload the backup file to Wasabi
        $this->uploadToWasabi($localPath,$database , $host_type);

        // Step 3: Manage backups retention
        // $this->manageRetention($database);
    }



    protected function manageRetention($database,$host_type = '')
    {

        $disk = Storage::disk('wasabi');
        $folder = 'algo/'; // Folder where backups are stored

        // List all files in the Wasabi folder
        $files = $disk->files($folder);


        if($host_type != ''){
            // Filter files for cluster database
            $databaseFiles = array_filter($files, function ($file) use ($database,$host_type) {
                return strpos($file, "algo/{$database}_backup_{$host_type}_") === 0;
            });
        }else{
            // Filter files for the specific database
            $databaseFiles = array_filter($files, function ($file) use ($database) {
                return strpos($file, "algo/{$database}_backup_") === 0;
            });
        }

        // Sort files by last modified time (ascending)
        usort($databaseFiles, function ($fileA, $fileB) use ($disk) {
            return $disk->lastModified($fileA) <=> $disk->lastModified($fileB);
        });

        // Retain the last 4 backups and delete the rest
        $filesToDelete = array_slice($databaseFiles, 0, max(0, count($databaseFiles) - 12));

        foreach ($filesToDelete as $file) {
            $disk->delete($file);
            Log::info("Deleted old backup: {$file}");
        }
    }

    protected function uploadToWasabi($filePath, $database , $host_type = '')
    {
        $timestamp = now()->format('Y_m_d_His');

        $fileName = 'algo/new_ilearn_'. basename($filePath);
        Log::info("file name is : $fileName");
        Log::info("file path is : $filePath");
        // Using Laravel's Storage facade to upload the file
        // Set up AWS S3 Client with Wasabi credentials
        $s3Client = new S3Client([
            'version' => 'latest',
            'region'  => env('WAS_DEFAULT_REGION'),
            'endpoint' => env('WAS_ENDPOINT'),
            'credentials' => [
                'key'    => env('WAS_ACCESS_KEY_ID'),
                'secret' => env('WAS_SECRET_ACCESS_KEY'),
            ],
        ]);

        // Upload the compressed video to Wasabi
        $result = $s3Client->putObject([
            'Bucket' => env('WAS_BUCKET'),
            'Key'    => 'algo/'.$fileName,
            'SourceFile' => $filePath,
            'ACL'    => 'public-read',
        ]);
        /*Storage::disk('wasabi')
            ->put($fileName, file_get_contents($filePath));*/

        // Optionally, delete the local file after uploading
        //unlink($filePath);
        if($host_type == ''){
            // Manage backups retention
            $this->manageRetention($database,$host_type);
        }
    }


}
