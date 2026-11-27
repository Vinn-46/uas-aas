<?php
declare(strict_types=1);

require_once __DIR__ . '/../vendor/autoload.php';

$dotenv = Dotenv\Dotenv::createImmutable(__DIR__ . '/../');
$dotenv->load();
$dotenv->required(['DB_HOST', 'DB_DATABASE', 'DB_USERNAME', 'APP_KEY'])->notEmpty();

$isDebug = filter_var($_ENV['APP_DEBUG'] ?? false, FILTER_VALIDATE_BOOLEAN);
ini_set('display_errors', $isDebug ? '1' : '0');
ini_set('log_errors', '1');
ini_set('error_log', __DIR__ . '/../storage/logs/app_error.log');
error_reporting(E_ALL);

require_once __DIR__ . '/../app/config/session.php';
require_once __DIR__ . '/../app/config/database.php';

$conn = getDBConnection();

if ($conn instanceof mysqli && $conn->connect_errno === 0) {
    echo "Setup berhasil! Terhubung ke database: " . htmlspecialchars($_ENV['DB_DATABASE'], ENT_QUOTES, 'UTF-8');
}