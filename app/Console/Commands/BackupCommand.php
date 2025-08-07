<?php

namespace App\Console\Commands;

use App\Jobs\BackupJob;
use Aws\S3\S3Client;
use Illuminate\Console\Command;
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
            $this->folder = 'ilearnalgo/';
        }

        // Cluster backup
        if (env('DB_CLUSTER_USERNAME')) {
            $this->folder = 'ilearnalgo/';
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
                return !in_array($db, ['Database', 'information_schema', 'performance_schema', 'mysql', 'sys']);
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

        Log::info("Start dumping cluster database: $database");

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

        $this->info('Username : ' . $username.' Password: ' . $password . ' Database Name: ' . $database .' Host: ' . $host);

        MySql::create()
            ->setTimeout(300)
            ->setHost($host)
            ->setDbName($database)
            ->setUserName($username)
            ->setPassword($password)
            ->dumpToFile($localPath);
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
            'Key' => env('WAS_MAIN_DB') . $fileName,
            'SourceFile' => $filePath,
            'ACL' => 'public-read',
        ]);

        unlink($filePath);

        // Retention management
        $this->manageRetention($database, $hostType);
    }

    protected function manageRetention(string $database, string $hostType = '')
    {
        $disk = Storage::disk('wasabi');
        $prefix = $this->folder . $database . '_backup' . $hostType . '_';

        $files = array_filter($disk->files($this->folder), function ($file) use ($prefix) {
            return str_starts_with($file, $prefix);
        });

        usort($files, function ($a, $b) use ($disk) {
            return $disk->lastModified($a) <=> $disk->lastModified($b);
        });

        $filesToDelete = array_slice($files, 0, max(0, count($files) - $this->retentionLimit));

        foreach ($filesToDelete as $file) {
            $disk->delete($file);
            $this->info("Deleted old backup: {$file}");
        }
    }
}
