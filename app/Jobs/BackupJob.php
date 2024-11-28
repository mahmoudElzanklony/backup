<?php
namespace App\Jobs;

use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Bus\Dispatchable;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Queue\SerializesModels;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Storage;
use Symfony\Component\Process\Exception\ProcessFailedException;
use Symfony\Component\Process\Process;

class BackupJob implements ShouldQueue
{
    use Dispatchable, InteractsWithQueue, Queueable, SerializesModels;

    /**
     * Create a new job instance.
     */
    public function __construct()
    {
        //
    }

    /**
     * Execute the job.
     */
    public function handle()
    {
        $username = config('database.connections.mysql.username');
        $password = env('DB_PASSWORD','My!!ZZ##LLXX2022!');
        $host = config('database.connections.mysql.host');
        $port = config('database.connections.mysql.port');


        // Step 1: List all databases
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

        Log::info('Databases found: ' . implode(', ', $databases));

        // Step 2: Backup each database
        foreach ($databases as $database) {
            $this->backupDatabase($database, $username, $password, $host, $port);
        }
    }

    private function backupDatabase($database, $username, $password, $host, $port)
    {
        $timestamp = now()->format('Y_m_d_His');
        $filename = "{$database}_backup_{$timestamp}.sql";
        $localPath = storage_path("app/{$filename}");
        $wasabiPath = "backups/{$filename}";
        Log::info("Starting backup for database: $database");
        // Create the database dump
        $process = new Process([
            'mysqldump',
            '--user=' . $username,
            '--password=' . $password,
            '--host=' . $host,
            '--port=' . $port,
            '--databases', $database,
        ]);

        $process->setTimeout(3600);
        $process->run();

        if (!$process->isSuccessful()) {
            throw new ProcessFailedException($process);
        }

        file_put_contents($localPath, $process->getOutput());
        Log::info("Backup saved locally: $localPath");

        // Upload to Wasabi
        Storage::disk('wasabi')->put($wasabiPath, file_get_contents($localPath));
        Log::info("Backup uploaded to Wasabi: $wasabiPath");

        // Optional: Delete the local file after upload
        unlink($localPath);

        // Step 3: Manage backups retention
        // $this->manageRetention($database);
    }

    private function manageRetention($database)
    {
        $wasabiPath = "backups";
        $files = Storage::disk('wasabi')->files($wasabiPath);

        // Sort files by last modified time, newest first
        usort($files, function ($a, $b) {
            return Storage::disk('wasabi')->lastModified($b) <=> Storage::disk('wasabi')->lastModified($a);
        });

        // Retain only the three most recent backups
        foreach (array_slice($files, 3) as $file) {
            Storage::disk('wasabi')->delete($file);
        }
    }

}
