<?php

namespace App\Console\Commands;

use App\Jobs\BackupJob;
use Aws\S3\S3Client;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Storage;
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
        $password = 'My!!ZZ##LLXX2022!';
        $host = config('database.connections.mysql.host');
        $port = config('database.connections.mysql.port');


        $process = new Process([
            'mysql',
            '--user=' . $username,
            '--password=' . $password,
            '--host=' . $host,
            '--port=' . $port,
            '-e', 'SHOW DATABASES;'
        ]);

        $process->run();

        if (!$process->isSuccessful()) {
            throw new ProcessFailedException($process);
        }

        $databases = array_filter(explode("\n", $process->getOutput()), function ($db) {
            // Ignore system databases
            return !in_array($db, ['Database', 'information_schema', 'performance_schema', 'mysql', 'sys']);
        });


        // Step 2: Backup each database
        foreach ($databases as $database) {
            $this->backupDatabase($database, $username, $password, $host, $port);
        }

        // Step 2: Backup each database
        foreach ($databases as $database) {
            $this->backupDatabase($database, $username, $password, $host, $port);
        }


    }

    private function backupDatabase($database, $username, $password, $host, $port)
    {
        $timestamp = now()->format('Y_m_d_His');
        $filename = "{$database}_backup_{$timestamp}.sql";
        Log::info("file name is : $filename");
        $localPath = storage_path("app/{$filename}");
        $wasabiPath = "algo";
        Log::info("Starting backup for database: $database");
        if (empty($database)) {
            Log::error("Skipping backup for empty database name.");
            return;
        }
        // Create the database dump
        $process = new Process([
            'mysqldump',
            '--user=' . $username,
            '--password=' . $password,
            '--host=' . $host,
            '--port=' . $port,
            '--databases', $database,
        ]);

        $this->info("Running mysqldump command: mysqldump --user={$username} --password={$password} --host={$host} --port={$port} --databases {$database}");

        $process->run();

        if (!$process->isSuccessful()) {
            throw new ProcessFailedException($process);
        }

        file_put_contents($localPath, $process->getOutput());
        Log::info("Backup saved locally: $localPath");


        // Upload to Wasabi

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
            'Key'    => 'algo/'.$database.'_backup.sql',
            'SourceFile' => $localPath,
            'ACL'    => 'public-read',
        ]);
        Log::info("Backup uploaded to Wasabi: $wasabiPath");

        // Optional: Delete the local file after upload
        unlink($localPath);

        // Step 3: Manage backups retention
        // $this->manageRetention($database);
    }


}
