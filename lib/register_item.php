<?php
// Assuming you have established a database connection

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
  // Retrieve the item information from the request
  $title = $_POST['title'];
  $description = $_POST['description'];
  $imagePath = $_POST['imagePath'];

  // Prepare the SQL statement
  $sql = "INSERT INTO items (title, description, image_path) VALUES (?, ?, ?)";
  $stmt = $conn->prepare($sql);
  
  // Bind the parameters and execute the statement
  $stmt->bind_param("sss", $title, $description, $imagePath);
  $stmt->execute();

  // Check if the insertion was successful
  if ($stmt->affected_rows > 0) {
    // Item successfully inserted
    echo "Item registered successfully";
  } else {
    // Failed to insert item
    echo "Failed to register item";
  }

  // Close the statement
  $stmt->close();
}

// Close the database connection
$conn->close();
?>
