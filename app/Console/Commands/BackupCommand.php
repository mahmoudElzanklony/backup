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

        // Create a backup file using spatie/db-dumper

        MySql::create()
            ->setDbName($database)
            ->setUserName($username)
            ->setPassword($password)
            ->dumpToFile($localPath);

        // Now upload the backup file to Wasabi
        $this->uploadToWasabi($localPath,$database);

        // Step 3: Manage backups retention
        // $this->manageRetention($database);
    }

    protected function uploadToWasabi($filePath,$database)
    {
        // Upload the backup file to Wasabi
        $fileName = 'algo/'.$database. '.sql';

        // Using Laravel's Storage facade to upload the file
        Storage::disk('wasabi')
            ->put($fileName, file_get_contents($filePath));

        // Optionally, you can delete the local file after uploading
        unlink($filePath);
    }


}
