<?php
/**
 * Installation Script for Thesaurus Indonesia
 * PHP 8.4 Thesaurus Application
 */

error_reporting(E_ALL);
ini_set('display_errors', 1);

echo "=== Thesaurus Indonesia Installation Script ===\n\n";

// Check PHP version
if (version_compare(PHP_VERSION, '8.4.0', '<')) {
    echo "❌ Error: PHP 8.4 or higher is required. Current version: " . PHP_VERSION . "\n";
    exit(1);
}
echo "✅ PHP Version: " . PHP_VERSION . " (OK)\n";

// Check required extensions
$required_extensions = ['pdo', 'pdo_mysql', 'json'];
$missing_extensions = [];

foreach ($required_extensions as $ext) {
    if (!extension_loaded($ext)) {
        $missing_extensions[] = $ext;
    }
}

if (!empty($missing_extensions)) {
    echo "❌ Error: Missing required PHP extensions: " . implode(', ', $missing_extensions) . "\n";
    exit(1);
}
echo "✅ Required PHP extensions are available\n";

// Database configuration
echo "\n=== Database Configuration ===\n";
echo "Please enter your database configuration:\n";

$db_host = readline("Database Host [localhost]: ") ?: 'localhost';
$db_name = readline("Database Name [thesaurus_db]: ") ?: 'thesaurus_db';
$db_user = readline("Database User [root]: ") ?: 'root';
$db_pass = readline("Database Password []: ");

echo "\n=== Testing Database Connection ===\n";

try {
    $dsn = "mysql:host={$db_host};charset=utf8mb4";
    $pdo = new PDO($dsn, $db_user, $db_pass, [
        PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION
    ]);
    echo "✅ Database connection successful\n";
} catch (PDOException $e) {
    echo "❌ Database connection failed: " . $e->getMessage() . "\n";
    exit(1);
}

// Create database if not exists
echo "\n=== Creating Database ===\n";
try {
    $pdo->exec("CREATE DATABASE IF NOT EXISTS `{$db_name}` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci");
    echo "✅ Database '{$db_name}' created/verified\n";
} catch (PDOException $e) {
    echo "❌ Failed to create database: " . $e->getMessage() . "\n";
    exit(1);
}

// Import schema
echo "\n=== Importing Database Schema ===\n";
$schema_file = __DIR__ . '/database/schema.sql';

if (!file_exists($schema_file)) {
    echo "❌ Schema file not found: {$schema_file}\n";
    exit(1);
}

try {
    $schema_sql = file_get_contents($schema_file);
    $pdo->exec($schema_sql);
    echo "✅ Database schema imported successfully\n";
} catch (PDOException $e) {
    echo "❌ Failed to import schema: " . $e->getMessage() . "\n";
    exit(1);
}

// Import sample data
echo "\n=== Importing Sample Data ===\n";
$sample_data_file = __DIR__ . '/database/sample_data.sql';

if (file_exists($sample_data_file)) {
    $import_sample = strtolower(readline("Import sample data? [y/N]: "));
    
    if ($import_sample === 'y' || $import_sample === 'yes') {
        try {
            $sample_sql = file_get_contents($sample_data_file);
            $pdo->exec($sample_sql);
            echo "✅ Sample data imported successfully\n";
        } catch (PDOException $e) {
            echo "⚠️  Warning: Failed to import sample data: " . $e->getMessage() . "\n";
        }
    } else {
        echo "⏭️  Skipping sample data import\n";
    }
} else {
    echo "⚠️  Sample data file not found, skipping\n";
}

// Update database configuration
echo "\n=== Updating Configuration ===\n";
$config_content = "<?php

return [
    'host' => '{$db_host}',
    'dbname' => '{$db_name}',
    'username' => '{$db_user}',
    'password' => '{$db_pass}',
    'charset' => 'utf8mb4',
    'options' => [
        PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
        PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
        PDO::ATTR_EMULATE_PREPARES => false,
    ]
];
";

if (file_put_contents(__DIR__ . '/config/database.php', $config_content)) {
    echo "✅ Configuration file updated\n";
} else {
    echo "⚠️  Warning: Could not update configuration file\n";
}

// Test API
echo "\n=== Testing API ===\n";
echo "Starting built-in PHP server for testing...\n";

$test_server = false;
$test_api = strtolower(readline("Test API with built-in server? [y/N]: "));

if ($test_api === 'y' || $test_api === 'yes') {
    $port = 8000;
    $public_dir = __DIR__ . '/public';
    
    echo "Starting server at http://localhost:{$port}\n";
    echo "Document root: {$public_dir}\n";
    echo "Press Ctrl+C to stop the server\n\n";
    
    // Change to public directory and start server
    chdir($public_dir);
    passthru("php -S localhost:{$port}");
}

echo "\n=== Installation Complete ===\n";
echo "✅ Thesaurus Indonesia has been installed successfully!\n\n";

echo "Next steps:\n";
echo "1. Configure your web server to point to the 'public' directory\n";
echo "2. Access the application at your domain/server\n";
echo "3. Use the API endpoints:\n";
echo "   - GET /api/search?word=bahagia\n";
echo "   - GET /api/autocomplete?q=bah\n";
echo "   - GET /api/stats\n\n";

echo "For development, you can use:\n";
echo "   cd public && php -S localhost:8000\n\n";

echo "Documentation: README.md\n";
echo "Happy coding! 🚀\n";
