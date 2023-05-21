<?php
// Step 2: Establish database connection

$host = 'localhost';
$db = 'barterit';
$user = 'root';
$password = '';

$conn = new mysqli($host, $user, $password, $db);

if ($conn->connect_error) {
    die('Connection failed: ' . $conn->connect_error);
}

// Step 3: Retrieve login data

$username = $_POST['username'];
$password = $_POST['password'];

// Step 4: Validate login data

// Perform your validation checks here
// For example, check if fields are empty, validate email format, etc.

// Step 5: Verify login credentials
$stmt = $conn->prepare('SELECT username, password FROM users WHERE username = ?');
$stmt->bind_param('s', $username);

$stmt->execute();
$stmt->store_result();

if ($stmt->num_rows > 0) {
    $stmt->bind_result($resultUsername, $hashedPassword);
    $stmt->fetch();

    // Verify the password
    if (password_verify($password, $hashedPassword)) {
        // Login successful
        echo json_encode(['success' => true, 'username' => $resultUsername]);
    } else {
        // Invalid password
        echo json_encode(['success' => false, 'error' => 'Invalid password']);
    }
} else {
    // User not found
    echo json_encode(['success' => false, 'error' => 'User not found']);
}

// Step 6: Close the database connection

$stmt->close();
$conn->close();
?>
