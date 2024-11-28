<?php

namespace App\Console\Commands;

use App\Jobs\BackupJob;
use Illuminate\Console\Command;
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
        dd($databases);
        dispatch(new BackupJob());
        $this->info(env('DB_PASSWORD'));
        $this->info('ending the database backup process...');

    }
}
