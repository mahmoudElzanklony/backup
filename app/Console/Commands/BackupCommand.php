<?php

namespace App\Console\Commands;

use App\Jobs\BackupJob;
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

        Log::info('Databases found: ' . implode(', ', $databases));

        // Step 2: Backup each database
        foreach ($databases as $database) {
            $this->backupDatabase($database, $username, $password, $host, $port);
        }

        Log::info('Databases found: ' . implode(', ', $databases));

        // Step 2: Backup each database
        foreach ($databases as $database) {
            $this->backupDatabase($database, $username, $password, $host, $port);
        }
        dd($databases);
        dispatch(new BackupJob());
        $this->info(env('DB_PASSWORD'));
        $this->info('ending the database backup process...');

    }

    private function backupDatabase($database, $username, $password, $host, $port)
    {
        $timestamp = now()->format('Y_m_d_His');
        $filename = "{$database}_backup_{$timestamp}.sql";
        $localPath = storage_path("app/{$filename}");
        $wasabiPath = "algo";
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

        $this->info("Running mysqldump command: mysqldump --user={$username} --password={$password} --host={$host} --port={$port} --databases {$database}");


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

}
