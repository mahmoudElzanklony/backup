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

    }

    private function backupDatabase($database, $username, $password, $host, $port)
    {
        $timestamp = now()->format('Y_m_d_His');
        $filename = "{$database}_backup_{$timestamp}.sql";
        Log::info("file name is : $filename");
        $localPath = storage_path("app/{$filename}");
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



    protected function manageRetention($database)
    {
        $disk = Storage::disk('wasabi');
        $folder = 'algo/'; // Folder where backups are stored

        // List all files in the Wasabi folder
        $files = $disk->files($folder);

        // Filter files for the specific database
        $databaseFiles = array_filter($files, function ($file) use ($database) {
            return strpos($file, "algo/{$database}_backup_") === 0;
        });

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

    protected function uploadToWasabi($filePath, $database)
    {
        $timestamp = now()->format('Y_m_d_His');

        $fileName = 'algo/' . $database . '_backup_' . basename($filePath);

        // Using Laravel's Storage facade to upload the file
        Storage::disk('wasabi')
            ->put($fileName, file_get_contents($filePath));

        // Optionally, delete the local file after uploading
        unlink($filePath);

        // Manage backups retention
        $this->manageRetention($database);
    }


}
