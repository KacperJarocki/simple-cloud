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
    $stmt = $pdo ->query('
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL
);
');
    $stmt = $pdo->query('SELECT * FROM users');
    $users = $stmt->fetchAll();

} catch (PDOException $e) {
    die("Błąd połączenia: " . $e->getMessage());
}
?>
<!DOCTYPE html>
<html lang="pl">
<head>
    <meta charset="UTF-8">
    <title>Użytkownicy Strony</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>
<div class="container">
    <h1>Dodaj użytkownika tej skomplikowanej strony</h1>
    <form action="add_user.php" method="post">
        <input type="text" name="name" placeholder="Imię" required>
        <button type="submit">Dodaj</button>
    </form>

    <h2>Lista użytkowników</h2>
    <ul>
        <?php foreach ($users as $user): ?>
            <li><?= htmlspecialchars($user['name']) ?></li>
        <?php endforeach; ?>
    </ul>
</div>
</body>
</html>
