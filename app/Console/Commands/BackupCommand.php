<?php

namespace App\Console\Commands;

use App\Jobs\BackupJob;
use Illuminate\Console\Command;

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

        dispatch(new BackupJob());
        $this->info(env('DB_PASSWORD'));
        $this->info('ending the database backup process...');

    }
}
