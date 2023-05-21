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

// Step 3: Retrieve registration data

$username = $_POST['username'];
$email = $_POST['email'];
$password = $_POST['password'];

// Step 4: Validate data

// Perform your validation checks here
// For example, check if fields are empty, validate email format, etc.

// Step 5: Encrypt or hash the password

$hashedPassword = password_hash($password, PASSWORD_DEFAULT);

// Step 6: Insert data into the database

$stmt = $conn->prepare('INSERT INTO users (username, email, password) VALUES (?, ?, ?)');
$stmt->bind_param('sss', $username, $email, $hashedPassword);

if ($stmt->execute()) {
    // Step 7: Return success response
    echo json_encode(['success' => true]);
} else {
    // Step 7: Return error response
    echo json_encode(['success' => false, 'error' => 'Registration failed']);
}

// Step 8: Close the database connection

$stmt->close();
$conn->close();
?>
