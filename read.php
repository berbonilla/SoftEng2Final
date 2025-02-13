<?php
// Database connection setup
$servername = "localhost";
$username = "root";
$password = ""; 
$dbname = "autosync"; 

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Execute Python script to get RFID
$command = "python3 script.py";
$output = shell_exec($command);
$rfid = trim($output); // Trim output to remove extra spaces/newlines

if (empty($rfid) || strtolower($rfid) == "none") {
    // If no RFID is detected, reload the page after 1 second
    echo "<script>
            setTimeout(function() {
                window.location.href = 'index.html';
            }, 1000);
          </script>";
    exit();
}

// Prepare SQL query to check if RFID exists
$sql = "SELECT * FROM worker WHERE id = ?";
$stmt = $conn->prepare($sql);
$stmt->bind_param("s", $rfid);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows > 0) {
    // RFID found, redirect to landing page
    header("Location: landing.html");
    exit();
} else {
    // RFID not found, show error message
    echo "<script>
            alert('Invalid RFID! Access Denied.');
            window.location.href='index.html';
          </script>";
}

$stmt->close();
$conn->close();
?>


<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>RFID Login</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            background-color: #f4f4f4;
        }
        .container {
            text-align: center;
            padding: 20px;
            background: white;
            border-radius: 10px;
            box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);
        }
        h2 {
            margin-bottom: 20px;
        }
    </style>
</head>
<body>

<div class="container">
    <h2>Scan Your RFID</h2>
    <p>Place your RFID card near the scanner...</p>

    <form id="rfidForm" action="login.php" method="POST">
        <input type="hidden" name="rfid" value="scan">
    </form>

    <script>
        // Automatically submit form when page loads
        window.onload = function() {
            document.getElementById("rfidForm").submit();
        };
    </script>
</div>

</body>
</html>
