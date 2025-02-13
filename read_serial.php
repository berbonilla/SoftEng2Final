<?php
header("Content-Type: text/event-stream");
header("Cache-Control: no-cache");
header("Connection: keep-alive");

set_time_limit(0);

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

$error_message = "";
$success_message = "";

// Open the Python script
$handle = popen('python misc/middle.py', 'r');
if ($handle) {
    while (!feof($handle)) {
        $line = fgets($handle);
        if ($line) {
            $workerRFID = trim($line);
            $wRFID = $workerRFID;

            if ($workerRFID != "" && strlen($workerRFID) === 8){
                $sql = $conn->prepare("SELECT * FROM worker WHERE RFID = ?");
                $sql->bind_param("s", $wRFID);
                $sql->execute();
                $result = $sql->get_result();
            
                if ($result->num_rows > 0) {
                    echo  "Access Verified!";
                } else {
                    echo  "Account Not Found! ";
                }
            }    

            ob_flush();
            flush();
        }
    }
    pclose($handle);
}

$conn->close();
?>
