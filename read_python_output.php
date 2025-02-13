<?php
// Database connection credentials
$servername = "localhost";
$username = "root"; // Change if necessary
$password = ""; // Change if necessary
$dbname = "autosync"; // Database name

$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die("Database connection failed: " . $conn->connect_error);
}

// Execute Python script on page load (without capturing output)
shell_exec("python script.py > /dev/null 2>&1 &");

// Fetch machine data from the database
function fetchMachines($conn) {
    $sql = "SELECT 
                MachineID, 
                MachineName, 
                MachineType, 
                Status, 
                Utilization, 
                NumOfProcesses, 
                (SELECT WorkstationName FROM Workstation WHERE Workstation.WorkstationID = Machine.WorkstationID) AS Workstation
            FROM Machine";
    
    $result = $conn->query($sql);
    $machines = [];

    if ($result->num_rows > 0) {
        while ($row = $result->fetch_assoc()) {
            $machines[] = $row;
        }
    }
    return json_encode($machines);
}

// If the request is AJAX, return JSON data
if (isset($_GET['fetch_machines'])) {
    echo fetchMachines($conn);
    exit;
}

$conn->close();
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Machine Status Monitor</title>
    
    <!-- Auto-refresh the page every second -->
    <meta http-equiv="refresh" content="1">

    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f9;
            margin: 0;
            padding: 0;
            text-align: center;
        }

        h1 {
            padding: 20px;
            background-color: #4CAF50;
            color: white;
        }

        #output {
            margin: 20px auto;
            width: 95%;
            max-width: 1200px;
            background-color: white;
            padding: 20px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            border-radius: 8px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        th, td {
            padding: 10px;
            text-align: left;
            border: 1px solid #ddd;
        }

        th {
            background-color: #4CAF50;
            color: white;
            font-weight: bold;
        }

        tr:nth-child(even) {
            background-color: #f9f9f9;
        }

        tr:hover {
            background-color: #f1f1f1;
        }
    </style>
</head>
<body>
    <h1>Machine Status Monitor</h1>
    <div id="output">
        <?php
        // Fetch and display machine data
        $machines = json_decode(fetchMachines(new mysqli($servername, $username, $password, $dbname)), true);

        if ($machines) {
            echo "<table>
                <tr>
                    <th>Machine ID</th>
                    <th>Machine Name</th>
                    <th>Machine Type</th>
                    <th>Status</th>
                    <th>Utilization</th>
                    <th>Processes</th>
                    <th>Workstation</th>
                </tr>";

            foreach ($machines as $machine) {
                echo "<tr>
                    <td>{$machine['MachineID']}</td>
                    <td>{$machine['MachineName']}</td>
                    <td>{$machine['MachineType']}</td>
                    <td>{$machine['Status']}</td>
                    <td>{$machine['Utilization']}%</td>
                    <td>{$machine['NumOfProcesses']}</td>
                    <td>" . ($machine['Workstation'] ?? "N/A") . "</td>
                </tr>";
            }

            echo "</table>";
        } else {
            echo "No machine data found.";
        }
        ?>
    </div>
</body>
</html>
