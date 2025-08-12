<?php

namespace Thesaurus\Database;

use PDO;
use PDOException;

class Connection
{
    private static ?PDO $instance = null;
    private string $host;
    private string $dbname;
    private string $username;
    private string $password;
    private string $charset;

    public function __construct(
        string $host = 'localhost',
        string $dbname = 'thesaurus_db',
        string $username = 'root',
        string $password = '',
        string $charset = 'utf8mb4'
    ) {
        $this->host = $host;
        $this->dbname = $dbname;
        $this->username = $username;
        $this->password = $password;
        $this->charset = $charset;
    }

    public function connect(): PDO
    {
        if (self::$instance === null) {
            try {
                $dsn = "mysql:host={$this->host};dbname={$this->dbname};charset={$this->charset}";
                
                self::$instance = new PDO($dsn, $this->username, $this->password, [
                    PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
                    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
                    PDO::ATTR_EMULATE_PREPARES => false,
                ]);
            } catch (PDOException $e) {
                throw new PDOException("Connection failed: " . $e->getMessage());
            }
        }

        return self::$instance;
    }

    public static function getInstance(): ?PDO
    {
        return self::$instance;
    }

    public function disconnect(): void
    {
        self::$instance = null;
    }
}
