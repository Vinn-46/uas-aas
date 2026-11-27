<?php
function getDBConnection(): mysqli {
    static $conn = null;

    if ($conn === null) {
        mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT);

        $conn = new mysqli(
            $_ENV['DB_HOST'],
            $_ENV['DB_USERNAME'],
            $_ENV['DB_PASSWORD'],
            $_ENV['DB_DATABASE'],
            (int)($_ENV['DB_PORT'] ?? 3306)
        );

        $conn->set_charset('utf8mb4');
    }

    return $conn;
}