-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Feb 13, 2025 at 01:03 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `autosync`
--

-- --------------------------------------------------------

--
-- Table structure for table `errorlog`
--

CREATE TABLE `errorlog` (
  `ErrorID` int(11) NOT NULL,
  `MachineID` int(11) DEFAULT NULL,
  `ErrorCode` varchar(20) NOT NULL,
  `ErrorDescription` text NOT NULL,
  `Timestamp` datetime DEFAULT current_timestamp(),
  `Resolved` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `errorlog`
--

INSERT INTO `errorlog` (`ErrorID`, `MachineID`, `ErrorCode`, `ErrorDescription`, `Timestamp`, `Resolved`) VALUES
(4, 71, 'E100', 'Overheating detected', '2025-02-10 00:13:45', 0),
(5, 74, 'E200', 'Sensor malfunction', '2025-02-10 00:13:45', 1),
(6, 72, 'E300', 'Unexpected shutdown', '2025-02-10 00:13:45', 0);

-- --------------------------------------------------------

--
-- Table structure for table `machine`
--

CREATE TABLE `machine` (
  `MachineID` int(11) NOT NULL,
  `MachineName` varchar(100) NOT NULL,
  `MachineType` varchar(100) NOT NULL,
  `Status` enum('Active','Idle','Under Maintenance','Error') NOT NULL,
  `Utilization` decimal(5,2) DEFAULT NULL CHECK (`Utilization` between 0 and 100),
  `NumOfProcesses` int(11) DEFAULT 0,
  `WorkstationID` int(11) DEFAULT NULL,
  `CurrentTime` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `machine`
--

INSERT INTO `machine` (`MachineID`, `MachineName`, `MachineType`, `Status`, `Utilization`, `NumOfProcesses`, `WorkstationID`, `CurrentTime`) VALUES
(71, 'Hydraulic Press_1', 'Hydraulic Press', 'Active', 53.77, 84, 1, '2025-02-10 12:53:25'),
(72, 'Milling Machine_2', 'Milling Machine', 'Active', 58.03, 25, 1, '2025-02-10 12:53:25'),
(73, 'Robotic Welder_3', 'Robotic Welder', 'Error', 61.95, 61, 1, '2025-02-10 12:53:25'),
(74, 'Injection Molder_4', 'Injection Molder', 'Active', 22.42, 7, 1, '2025-02-10 12:53:25'),
(75, 'Laser Cutter_5', 'Laser Cutter', 'Active', 57.07, 80, 1, '2025-02-10 12:53:25');

-- --------------------------------------------------------

--
-- Table structure for table `maintenance`
--

CREATE TABLE `maintenance` (
  `MaintenanceID` int(11) NOT NULL,
  `MachineID` int(11) DEFAULT NULL,
  `WorkerID` int(11) DEFAULT NULL,
  `ScheduledDate` date NOT NULL,
  `CompletionDate` date DEFAULT NULL,
  `MaintenanceType` enum('Preventive','Emergency','Calibration') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `maintenance`
--

INSERT INTO `maintenance` (`MaintenanceID`, `MachineID`, `WorkerID`, `ScheduledDate`, `CompletionDate`, `MaintenanceType`) VALUES
(4, 71, 2, '2025-02-01', '2025-02-02', 'Preventive'),
(5, 74, 1, '2025-02-03', NULL, 'Emergency'),
(6, 75, 3, '2025-02-05', '2025-02-06', 'Calibration');

-- --------------------------------------------------------

--
-- Table structure for table `operation`
--

CREATE TABLE `operation` (
  `OperationID` int(11) NOT NULL,
  `TransactionID` int(11) DEFAULT NULL,
  `MachineID` int(11) DEFAULT NULL,
  `OperationType` enum('Production','Maintenance','Shutdown','Error','Calibration') NOT NULL,
  `Duration` int(11) DEFAULT NULL COMMENT 'Duration in minutes',
  `Output` varchar(255) DEFAULT NULL COMMENT 'Products Created or Efficiency %'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `operation`
--

INSERT INTO `operation` (`OperationID`, `TransactionID`, `MachineID`, `OperationType`, `Duration`, `Output`) VALUES
(1, 1, 75, 'Production', 120, '50 Units Produced'),
(2, 2, 72, 'Shutdown', 30, 'System Off'),
(3, 3, 73, 'Error', 10, 'Overload Warning');

-- --------------------------------------------------------

--
-- Table structure for table `process`
--

CREATE TABLE `process` (
  `ProcessID` int(11) NOT NULL,
  `MachineID` int(11) DEFAULT NULL,
  `ProcessName` varchar(100) NOT NULL,
  `Timestamp` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `process`
--

INSERT INTO `process` (`ProcessID`, `MachineID`, `ProcessName`, `Timestamp`) VALUES
(5, 72, 'Milling Operation', '2025-02-10 00:10:09');

-- --------------------------------------------------------

--
-- Table structure for table `rfidsensor`
--

CREATE TABLE `rfidsensor` (
  `RFIDSensorID` int(11) NOT NULL,
  `RFID` varchar(50) DEFAULT NULL,
  `MachineID` int(11) DEFAULT NULL,
  `Location` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `rfidsensor`
--

INSERT INTO `rfidsensor` (`RFIDSensorID`, `RFID`, `MachineID`, `Location`) VALUES
(10, '6276E26D', 71, 'Main Entrance'),
(11, 'D3DD2DAD', 74, 'Assembly Line'),
(12, '123218D2', 75, 'Control Room');

-- --------------------------------------------------------

--
-- Table structure for table `shift`
--

CREATE TABLE `shift` (
  `ShiftID` int(11) NOT NULL,
  `ShiftName` enum('Day Shift','Night Shift','Weekend Shift') NOT NULL,
  `StartTime` time NOT NULL,
  `EndTime` time NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `shift`
--

INSERT INTO `shift` (`ShiftID`, `ShiftName`, `StartTime`, `EndTime`) VALUES
(1, 'Day Shift', '08:00:00', '16:00:00'),
(2, 'Night Shift', '16:00:00', '00:00:00'),
(3, 'Weekend Shift', '08:00:00', '20:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `transaction`
--

CREATE TABLE `transaction` (
  `TransactionID` int(11) NOT NULL,
  `WorkerID` int(11) DEFAULT NULL,
  `MachineID` int(11) DEFAULT NULL,
  `ProcessID` int(11) DEFAULT NULL,
  `Timestamp` datetime DEFAULT current_timestamp(),
  `TransactionType` enum('Start Process','Stop Process','Manual Override') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `transaction`
--

INSERT INTO `transaction` (`TransactionID`, `WorkerID`, `MachineID`, `ProcessID`, `Timestamp`, `TransactionType`) VALUES
(1, 2, 71, 5, '2025-02-10 00:12:39', 'Start Process'),
(2, 2, 74, 5, '2025-02-10 00:12:39', 'Stop Process'),
(3, 3, 75, 5, '2025-02-10 00:12:39', 'Manual Override');

-- --------------------------------------------------------

--
-- Table structure for table `worker`
--

CREATE TABLE `worker` (
  `WorkerID` int(11) NOT NULL,
  `WorkerFname` varchar(50) NOT NULL,
  `WorkerLname` varchar(50) NOT NULL,
  `RFID` varchar(50) NOT NULL,
  `Role` enum('Technician','Supervisor','Operator','Other') NOT NULL,
  `AccessLevel` enum('Read-Only','Operator','Maintenance') NOT NULL,
  `ShiftID` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `worker`
--

INSERT INTO `worker` (`WorkerID`, `WorkerFname`, `WorkerLname`, `RFID`, `Role`, `AccessLevel`, `ShiftID`) VALUES
(1, 'John', 'Doe', 'D3DD2DAD', 'Technician', 'Operator', 1),
(2, 'Jane', 'Smith', '6276E26D', 'Operator', 'Operator', 2),
(3, 'Mike', 'Johnson', '123218D2', 'Supervisor', 'Read-Only', 3);

-- --------------------------------------------------------

--
-- Table structure for table `workstation`
--

CREATE TABLE `workstation` (
  `WorkstationID` int(11) NOT NULL,
  `WorkstationName` varchar(100) NOT NULL,
  `Location` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `workstation`
--

INSERT INTO `workstation` (`WorkstationID`, `WorkstationName`, `Location`) VALUES
(1, 'Main Workstation', 'Factory A');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `errorlog`
--
ALTER TABLE `errorlog`
  ADD PRIMARY KEY (`ErrorID`),
  ADD KEY `MachineID` (`MachineID`);

--
-- Indexes for table `machine`
--
ALTER TABLE `machine`
  ADD PRIMARY KEY (`MachineID`),
  ADD KEY `WorkstationID` (`WorkstationID`);

--
-- Indexes for table `maintenance`
--
ALTER TABLE `maintenance`
  ADD PRIMARY KEY (`MaintenanceID`),
  ADD KEY `MachineID` (`MachineID`),
  ADD KEY `WorkerID` (`WorkerID`);

--
-- Indexes for table `operation`
--
ALTER TABLE `operation`
  ADD PRIMARY KEY (`OperationID`),
  ADD KEY `TransactionID` (`TransactionID`),
  ADD KEY `MachineID` (`MachineID`);

--
-- Indexes for table `process`
--
ALTER TABLE `process`
  ADD PRIMARY KEY (`ProcessID`),
  ADD KEY `MachineID` (`MachineID`);

--
-- Indexes for table `rfidsensor`
--
ALTER TABLE `rfidsensor`
  ADD PRIMARY KEY (`RFIDSensorID`),
  ADD KEY `RFID` (`RFID`),
  ADD KEY `MachineID` (`MachineID`);

--
-- Indexes for table `shift`
--
ALTER TABLE `shift`
  ADD PRIMARY KEY (`ShiftID`);

--
-- Indexes for table `transaction`
--
ALTER TABLE `transaction`
  ADD PRIMARY KEY (`TransactionID`),
  ADD KEY `WorkerID` (`WorkerID`),
  ADD KEY `MachineID` (`MachineID`),
  ADD KEY `ProcessID` (`ProcessID`);

--
-- Indexes for table `worker`
--
ALTER TABLE `worker`
  ADD PRIMARY KEY (`WorkerID`),
  ADD UNIQUE KEY `RFID` (`RFID`),
  ADD KEY `ShiftID` (`ShiftID`);

--
-- Indexes for table `workstation`
--
ALTER TABLE `workstation`
  ADD PRIMARY KEY (`WorkstationID`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `errorlog`
--
ALTER TABLE `errorlog`
  MODIFY `ErrorID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `machine`
--
ALTER TABLE `machine`
  MODIFY `MachineID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=76;

--
-- AUTO_INCREMENT for table `maintenance`
--
ALTER TABLE `maintenance`
  MODIFY `MaintenanceID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `operation`
--
ALTER TABLE `operation`
  MODIFY `OperationID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `process`
--
ALTER TABLE `process`
  MODIFY `ProcessID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `rfidsensor`
--
ALTER TABLE `rfidsensor`
  MODIFY `RFIDSensorID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `shift`
--
ALTER TABLE `shift`
  MODIFY `ShiftID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `transaction`
--
ALTER TABLE `transaction`
  MODIFY `TransactionID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `worker`
--
ALTER TABLE `worker`
  MODIFY `WorkerID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `workstation`
--
ALTER TABLE `workstation`
  MODIFY `WorkstationID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `errorlog`
--
ALTER TABLE `errorlog`
  ADD CONSTRAINT `errorlog_ibfk_1` FOREIGN KEY (`MachineID`) REFERENCES `machine` (`MachineID`);

--
-- Constraints for table `machine`
--
ALTER TABLE `machine`
  ADD CONSTRAINT `machine_ibfk_1` FOREIGN KEY (`WorkstationID`) REFERENCES `workstation` (`WorkstationID`);

--
-- Constraints for table `maintenance`
--
ALTER TABLE `maintenance`
  ADD CONSTRAINT `maintenance_ibfk_1` FOREIGN KEY (`MachineID`) REFERENCES `machine` (`MachineID`),
  ADD CONSTRAINT `maintenance_ibfk_2` FOREIGN KEY (`WorkerID`) REFERENCES `worker` (`WorkerID`);

--
-- Constraints for table `operation`
--
ALTER TABLE `operation`
  ADD CONSTRAINT `operation_ibfk_1` FOREIGN KEY (`TransactionID`) REFERENCES `transaction` (`TransactionID`),
  ADD CONSTRAINT `operation_ibfk_2` FOREIGN KEY (`MachineID`) REFERENCES `machine` (`MachineID`);

--
-- Constraints for table `process`
--
ALTER TABLE `process`
  ADD CONSTRAINT `process_ibfk_1` FOREIGN KEY (`MachineID`) REFERENCES `machine` (`MachineID`);

--
-- Constraints for table `rfidsensor`
--
ALTER TABLE `rfidsensor`
  ADD CONSTRAINT `rfidsensor_ibfk_1` FOREIGN KEY (`RFID`) REFERENCES `worker` (`RFID`),
  ADD CONSTRAINT `rfidsensor_ibfk_2` FOREIGN KEY (`MachineID`) REFERENCES `machine` (`MachineID`);

--
-- Constraints for table `transaction`
--
ALTER TABLE `transaction`
  ADD CONSTRAINT `transaction_ibfk_1` FOREIGN KEY (`WorkerID`) REFERENCES `worker` (`WorkerID`),
  ADD CONSTRAINT `transaction_ibfk_2` FOREIGN KEY (`MachineID`) REFERENCES `machine` (`MachineID`),
  ADD CONSTRAINT `transaction_ibfk_3` FOREIGN KEY (`ProcessID`) REFERENCES `process` (`ProcessID`);

--
-- Constraints for table `worker`
--
ALTER TABLE `worker`
  ADD CONSTRAINT `worker_ibfk_1` FOREIGN KEY (`ShiftID`) REFERENCES `shift` (`ShiftID`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
