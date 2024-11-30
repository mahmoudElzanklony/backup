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

        $process = new Process([
            'mysqldump',
            '--user=' . $username,
            '--password=' . $password,
            '--host=' . $host,
            '--port=' . $port,
            '--default-character-set=utf8mb4', // Ensures compatible charset
            '--databases', $database,          // Database to dump
            '--add-drop-database',            // Drop database if exists
            '--add-drop-table',               // Drop tables before creating them
            '--add-locks',                    // Add locks for faster inserts
            '--routines',                     // Include stored procedures and functions
            '--events',                       // Include events
            '--triggers',                     // Include triggers
            '--complete-insert',              // Use complete insert syntax
            '--extended-insert',              // Combine multiple rows in one INSERT statement
            '--no-set-names',                 // Prevents adding `SET NAMES` for character set
        ]);

        try {
            $process->run();

            if (!$process->isSuccessful()) {
                throw new ProcessFailedException($process);
            }

            // Capture the output of the mysqldump process
            $output = $process->getOutput();

            // Step 1: Add the necessary SQL modes and transaction settings at the beginning of the SQL dump
            $output = "SET SQL_MODE = \"NO_AUTO_VALUE_ON_ZERO\";\n";
            $output .= "START TRANSACTION;\n";
            $output .= "SET time_zone = \"+00:00\";\n\n";
            $output .= $process->getOutput(); // Append mysqldump output after the custom settings

            // Step 2: Process the dump to move foreign keys to the end of the SQL file
            // Regular expression to find the foreign keys and move them to the end
            $foreignKeyPattern = '/CONSTRAINT.*?FOREIGN KEY.*?REFERENCES.*?;/s';
            $foreignKeys = [];
            $output = preg_replace_callback($foreignKeyPattern, function ($matches) use (&$foreignKeys) {
                // Collect foreign keys in an array to be added later
                $foreignKeys[] = $matches[0];
                return ''; // Remove foreign keys from the main output
            }, $output);

            // Step 3: Append the foreign key constraints at the end of the SQL dump file
            if (!empty($foreignKeys)) {
                $output .= "\n-- Adding foreign keys at the end\n";
                foreach ($foreignKeys as $fk) {
                    $output .= $fk . "\n";
                }
            }

            // Step 4: Save the final SQL output to a file
            file_put_contents($localPath, $output);

        // Create the database dump
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
