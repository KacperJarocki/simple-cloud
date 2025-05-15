<?php
$host = getenv('DB_HOST');
$db   = getenv('DB_NAME');
$user = getenv('DB_USER');
$pass = getenv('DB_PASS');
$port = getenv('DB_PORT');

$dsn = "pgsql:host=$host;port=$port;dbname=$db";

try {
    $pdo = new PDO($dsn, $user, $pass, [
        PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION
    ]);

    if ($_SERVER['REQUEST_METHOD'] === 'POST' && !empty($_POST['name'])) {
        $name = trim($_POST['name']);
        $stmt = $pdo->prepare("INSERT INTO users (name) VALUES (:name)");
        $stmt->execute(['name' => $name]);
    }

    header('Location: index.php');
    exit;

} catch (PDOException $e) {
    die("Błąd: " . $e->getMessage());
}
