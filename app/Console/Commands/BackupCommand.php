<?php

namespace App\Console\Commands;

use App\Jobs\BackupJob;
use Aws\S3\S3Client;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\File;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Storage;
use Spatie\DbDumper\Databases\MySql;
use Symfony\Component\Process\Exception\ProcessFailedException;
use Symfony\Component\Process\Process;

class BackupCommand extends Command
{
    protected $signature = 'backup';
    protected $description = 'Backup MySQL databases and upload to Wasabi';

    private string $folder = 'algo/';
    private int $retentionLimit = 6;

    public function handle()
    {
        $this->info('Starting the database backup process...');

        $username = config('database.connections.mysql.username');
        $password = env('DB_PASSWORD');
        $host = config('database.connections.mysql.host');
        $port = config('database.connections.mysql.port');

        if(env('IS_ILEARN')){
            $this->folder = 'ilearn/';
        }

        // Cluster backup
        if (env('DB_CLUSTER_USERNAME')) {
            $this->folder = 'ilearn/';
            $this->processDatabases(
                env('DB_CLUSTER_USERNAME'),
                env('DB_CLUSTER_PASSWORD'),
                env('DB_CLUSTER_HOST'),
                env('DB_CLUSTER_PORT'),
                '_cluster'
            );
        }

        // Local backup
        $this->processDatabases($username, $password, $host, $port);
    }

    protected function processDatabases(string $username, string $password, string $host, string $port, string $hostType = '')
    {
        if ($hostType !== '') {
            $this->clusterDump($username, $password, $host, $port, 'education', $hostType);
            return;
        }

        try {
            $this->info('Starting initial database process...');
            $process = new Process([
                'mysql',
                "--user=$username",
                "--password=$password",
                "--host=$host",
                "--port=$port",
                '-e', 'SHOW DATABASES;',
            ]);

            $process->setTimeout(120);
            $process->run();

            if (!$process->isSuccessful()) {
                throw new ProcessFailedException($process);
            }

            $this->info('Starting get all databases...');
            $databases = array_filter(explode("\n", $process->getOutput()), function ($db) {
                return !in_array($db, ['Database', 'information_schema', 'performance_schema', 'mysql', 'sys','phpmyadmin']);
            });

            foreach ($databases as $database) {
                $this->backupDatabase($database, $username, $password, $host, $port, $hostType);
            }

        } catch (\Exception $e) {
            $this->error("Failed to fetch databases: " . $e->getMessage());
        }
    }

    protected function clusterDump(string $username, string $password, string $host, string $port, string $database, string $hostType)
    {
        $localPath = storage_path("education_backup_cluster_" . now()->format('Y_m_d_His') . ".sql");


        $command = sprintf(
            'mysqldump --user=%s --password=%s --host=%s --port=%s --single-transaction %s > %s',
            escapeshellarg($username),
            escapeshellarg($password),
            escapeshellarg($host),
            escapeshellarg($port),
            escapeshellarg($database),
            escapeshellarg($localPath)
        );

        shell_exec($command);

        $this->uploadToWasabi($localPath, $database, $hostType);
    }

    protected function backupDatabase(string $database, string $username, string $password, string $host, string $port, string $hostType = '')
    {
        if (empty($database)) {
            Log::error("Skipping backup for empty database name.");
            return;
        }

        $timestamp = now()->format('Y_m_d_His');
        $filename = "{$database}_backup{$hostType}_{$timestamp}.sql";
        $this->info('file name generated: ' . $filename);

        $localPath = storage_path("app/{$filename}");


        $command = [
            'mysqldump',
            "--host={$host}",
            "--port={$port}",
            "--user={$username}",
            "--password={$password}",
            '--protocol=TCP',
            '--single-transaction',
            '--skip-add-drop-table',
            '--skip-set-charset',
            $database,
        ];

        $process = new Process($command);
        $process->setTimeout(300);
        $process->run(function ($type, $buffer) {

        });

        if (!$process->isSuccessful()) {
            throw new ProcessFailedException($process);
        }

        // Save output to file
        file_put_contents($localPath, $process->getOutput());
        $this->updateSqlDumpCollation($localPath);

        /*MySql::create()
            ->setDbName($database)
            ->setUserName($username)
            ->setPassword($password)
            ->setHost($host)
            ->setPort((int)$port)
            ->useSingleTransaction()
            ->addExtraOption('--protocol=TCP')
            ->dumpToFile($localPath);*/
        $this->info('start sending to wasabi');
        $this->uploadToWasabi($localPath, $database, $hostType);
    }

    protected function uploadToWasabi(string $filePath, string $database, string $hostType = '')
    {
        $fileName = $this->folder . '_database_' . basename($filePath);

        $this->info("Uploading $fileName to Wasabi from $filePath");

        $s3Client = new S3Client([
            'version' => 'latest',
            'region' => env('WAS_DEFAULT_REGION'),
            'endpoint' => env('WAS_ENDPOINT'),
            'credentials' => [
                'key' => env('WAS_ACCESS_KEY_ID'),
                'secret' => env('WAS_SECRET_ACCESS_KEY'),
            ],
        ]);

        $s3Client->putObject([
            'Bucket' => env('WAS_BUCKET'),
            'Key' => $fileName,
            'SourceFile' => $filePath,
            'ACL' => 'public-read',
        ]);
        // delete all files backup .sql
        File::cleanDirectory('storage/app');


        // Retention management
        $this->manageRetention($database, $hostType);
    }

    protected function manageRetention(string $database, string $hostType = '')
    {
        $disk = Storage::disk('wasabi');
        $prefix = $this->folder . '_database_' . $database . '_backup';

        $files = array_filter($disk->files($this->folder), function ($file) use ($prefix) {
            return str_starts_with($file, $prefix);
        });
        $this->info('Files inside '.$this->folder . ' = '.sizeof($files));

        usort($files, function ($a, $b) use ($disk) {
            return $disk->lastModified($a) <=> $disk->lastModified($b);
        });

        $filesToDelete = array_slice($files, 0, max(0, count($files) - $this->retentionLimit));
        $this->info('Files should be deleted  '.sizeof($filesToDelete));
        foreach ($filesToDelete as $file) {
            $disk->delete($file);
            $this->info("Deleted old backup: {$file}");
        }
    }

    public function updateSqlDumpCollation(string $dumpFile)
    {
        $command = ['sed', '-i', 's/utf8mb4_0900_ai_ci/utf8mb4_unicode_ci/g', $dumpFile];

        $process = new Process($command);

        try {
            $process->mustRun();
            echo 'Collation updated successfully.';
        } catch (ProcessFailedException $exception) {
            echo 'Collation update failed: ' . $exception->getMessage();
        }
    }
}
