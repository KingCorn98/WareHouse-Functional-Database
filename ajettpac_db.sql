-- phpMyAdmin SQL Dump
-- version 4.9.5deb2
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Dec 04, 2022 at 07:18 PM
-- Server version: 10.3.37-MariaDB-0ubuntu0.20.04.1
-- PHP Version: 7.4.3

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `ajettpac_db`
--
CREATE DATABASE IF NOT EXISTS `ajettpac_db` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `ajettpac_db`;

-- --------------------------------------------------------

--
-- Table structure for table `ABSENSE`
--

DROP TABLE IF EXISTS `ABSENSE`;
CREATE TABLE `ABSENSE` (
  `EMP_ID` int(3) NOT NULL,
  `ABSC_DATE` date NOT NULL DEFAULT curdate(),
  `ABSC_REASON` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `ABSENSE`
--

INSERT INTO `ABSENSE` (`EMP_ID`, `ABSC_DATE`, `ABSC_REASON`) VALUES
(1, '2018-09-08', 'Getting Flu Shot'),
(1, '2019-10-12', 'Getting Flu Shot'),
(2, '2018-09-08', 'Wife sick, tending to her'),
(2, '2018-09-09', 'Wife still sick, still tending to her'),
(3, '2020-06-06', 'Might have covid'),
(11, '2022-08-13', 'Have Covid');

-- --------------------------------------------------------

--
-- Table structure for table `CUSTOMER`
--

DROP TABLE IF EXISTS `CUSTOMER`;
CREATE TABLE `CUSTOMER` (
  `CSTM_ID` int(5) NOT NULL,
  `CSTM_UNAME` varchar(30) NOT NULL,
  `CSTM_FNAME` varchar(30) NOT NULL,
  `CSTM_LNAME` varchar(30) NOT NULL,
  `CSTM_JOIN` date NOT NULL,
  `CSTM_PNTS` int(3) NOT NULL DEFAULT 0 CHECK (`CSTM_PNTS` between 0 and 999),
  `CSTM_PHONE` char(12) NOT NULL DEFAULT '###-###-####' CHECK (`CSTM_PHONE` like '___-___-____'),
  `CSTM_ADD` varchar(50) NOT NULL,
  `CSTM_CITY` varchar(50) NOT NULL,
  `CSTM_ST` char(2) NOT NULL,
  `CSTM_ZIP` char(5) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `CUSTOMER`
--

INSERT INTO `CUSTOMER` (`CSTM_ID`, `CSTM_UNAME`, `CSTM_FNAME`, `CSTM_LNAME`, `CSTM_JOIN`, `CSTM_PNTS`, `CSTM_PHONE`, `CSTM_ADD`, `CSTM_CITY`, `CSTM_ST`, `CSTM_ZIP`) VALUES
(0, 'FORMER_CUSTOMER', 'LOST', 'LOST', '3000-12-15', 0, '###-###-####', 'LOST', 'LOST', 'XX', '99999'),
(1, 'KingCorn', 'Alden', 'Jettpace', '2019-09-25', 100, '###-###-####', 'Some Street', 'Somewhere', 'IN', '46147'),
(2, 'Gijop', 'Wiley', 'Jettpace', '2019-09-25', 200, '###-###-####', 'Some Street', 'Somewhere', 'IN', '46147'),
(3, 'Albood', 'Greg', 'Gregerson', '2020-09-25', 0, '317-431-4171', '72 Park Avenue', 'Zionsville', 'IN', '46188'),
(4, 'Lilah', 'Ellicker', 'Silvis', '2021-09-07', 200, '###-###-####', '466 Oak Brv', 'Chicago', 'IL', '60611'),
(5, 'AGENT_SMITH', 'Jacob', 'Smith', '2021-11-20', 445, '###-###-####', 'Park Avn', 'New York City', 'NY', '44444'),
(6, 'Mr_President', 'Bill', 'Clinton', '2022-01-01', 998, '###-###-####', 'Pennslyvania Avn', 'DC', 'DC', '00000');

--
-- Triggers `CUSTOMER`
--
DROP TRIGGER IF EXISTS `former_customer`;
DELIMITER $$
CREATE TRIGGER `former_customer` BEFORE DELETE ON `CUSTOMER` FOR EACH ROW BEGIN 
UPDATE `ORDER` SET CSTM_ID = 0 WHERE `ORDER`.CSTM_ID = OLD.CSTM_ID; 
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `DRIVER`
--

DROP TABLE IF EXISTS `DRIVER`;
CREATE TABLE `DRIVER` (
  `EMP_ID` int(3) NOT NULL,
  `DRIVER_LCNS` char(12) NOT NULL CHECK (`DRIVER_LCNS` like '____-__-____')
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `DRIVER`
--

INSERT INTO `DRIVER` (`EMP_ID`, `DRIVER_LCNS`) VALUES
(0, 'XXXX-XX-XXXX'),
(1, '0123-45-6789'),
(4, '9876-54-3210'),
(8, '1717-34-1717'),
(9, '1800-44-3987'),
(10, '3434-89-4534');

--
-- Triggers `DRIVER`
--
DROP TRIGGER IF EXISTS `drivers_insert`;
DELIMITER $$
CREATE TRIGGER `drivers_insert` BEFORE INSERT ON `DRIVER` FOR EACH ROW BEGIN
	DECLARE x CHAR(6);
	SELECT EMP_TITLE INTO x FROM EMPLOYEE WHERE EMP_ID = NEW.EMP_ID;
	IF (x <> "Driver" OR X IS NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Cannot insert non-drivers into Driver Table";
	END IF;
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `drivers_update`;
DELIMITER $$
CREATE TRIGGER `drivers_update` BEFORE UPDATE ON `DRIVER` FOR EACH ROW BEGIN
	DECLARE x CHAR(6);
	SELECT EMP_TITLE INTO x FROM EMPLOYEE WHERE EMP_ID = NEW.EMP_ID;
	IF (x <> "Driver" OR X IS NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Cannot insert non-drivers into Driver Table";
	END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `EMPLOYEE`
--

DROP TABLE IF EXISTS `EMPLOYEE`;
CREATE TABLE `EMPLOYEE` (
  `EMP_ID` int(3) NOT NULL,
  `EMP_FNAME` varchar(30) NOT NULL,
  `EMP_LNAME` varchar(30) NOT NULL,
  `EMP_PHONE` char(12) NOT NULL DEFAULT '###-###-####',
  `EMP_HIRE` date NOT NULL DEFAULT curdate(),
  `EMP_WAGE` decimal(4,2) NOT NULL CHECK (`EMP_WAGE` between 0 and 100),
  `EMP_SHIFT` char(7) NOT NULL CHECK (`EMP_SHIFT` in ('Morning','Evening','Night')),
  `EMP_TITLE` char(6) DEFAULT NULL CHECK (`EMP_TITLE` in (NULL,'Driver','Packer'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `EMPLOYEE`
--

INSERT INTO `EMPLOYEE` (`EMP_ID`, `EMP_FNAME`, `EMP_LNAME`, `EMP_PHONE`, `EMP_HIRE`, `EMP_WAGE`, `EMP_SHIFT`, `EMP_TITLE`) VALUES
(0, 'DUMMY', 'EMPLOYEE', '###-###-####', '1900-01-01', '0.00', 'Morning', 'Driver'),
(1, 'Al', 'Alenson', '###-###-####', '2017-01-01', '17.00', 'Morning', 'Driver'),
(2, 'Ben', 'Benson', '###-###-####', '2017-01-01', '17.00', 'Morning', 'Packer'),
(3, 'Clark', 'Clarkson', '###-###-####', '2017-01-01', '15.00', 'Evening', 'Packer'),
(4, 'David', 'Davidson', '###-###-####', '2017-01-01', '15.50', 'Night', 'Driver'),
(5, 'Ellise', 'Shaw', '###-###-####', '2018-07-07', '19.00', 'Night', 'Packer'),
(6, 'Fred', 'Fredrickson', '###-###-####', '2018-08-01', '14.00', 'Evening', 'Packer'),
(7, 'Greg', 'Kinel', '###-###-####', '2018-08-01', '21.00', 'Morning', NULL),
(8, 'Harriet', 'Loush', '###-###-####', '2019-02-02', '14.00', 'Morning', 'Driver'),
(9, 'Henry', 'Loush', '###-###-####', '2019-02-02', '15.50', 'Night', 'Driver'),
(10, 'Sheliah', 'Perkins', '###-###-####', '2020-01-02', '19.00', 'Evening', 'Driver'),
(11, 'Mike', 'Routch', '###-###-####', '2022-01-01', '10.00', 'Evening', 'Packer');

--
-- Triggers `EMPLOYEE`
--
DROP TRIGGER IF EXISTS `wage_init`;
DELIMITER $$
CREATE TRIGGER `wage_init` BEFORE INSERT ON `EMPLOYEE` FOR EACH ROW INSERT INTO `WAGE_REGISTER` VALUES (NEW.EMP_ID, NEW.EMP_HIRE, NEW.EMP_WAGE)
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `wage_update`;
DELIMITER $$
CREATE TRIGGER `wage_update` BEFORE UPDATE ON `EMPLOYEE` FOR EACH ROW BEGIN IF(NEW.EMP_WAGE <> OLD.EMP_WAGE) THEN
	INSERT INTO `WAGE_REGISTER` VALUES (NEW.EMP_ID, CURRENT_DATE(), NEW.EMP_WAGE);
	END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `FLEET`
--

DROP TABLE IF EXISTS `FLEET`;
CREATE TABLE `FLEET` (
  `FLEET_ID` int(2) NOT NULL,
  `FLEET_BUY_DATE` date NOT NULL DEFAULT curdate(),
  `FLEET_COST` decimal(8,2) NOT NULL,
  `FLEET_TYPE` char(8) NOT NULL CHECK (`FLEET_TYPE` in ('Truck','Forklift'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `FLEET`
--

INSERT INTO `FLEET` (`FLEET_ID`, `FLEET_BUY_DATE`, `FLEET_COST`, `FLEET_TYPE`) VALUES
(0, '1900-01-01', '0.00', 'Truck'),
(1, '2017-09-09', '100000.00', 'Truck'),
(2, '2017-09-10', '120000.00', 'Truck'),
(3, '2017-12-10', '120500.00', 'Truck'),
(4, '2018-01-01', '30000.00', 'Forklift'),
(5, '2018-01-04', '30000.00', 'Forklift'),
(6, '2018-04-20', '36000.00', 'Forklift'),
(7, '2018-04-20', '28000.00', 'Forklift'),
(8, '2020-05-19', '200000.00', 'Truck'),
(9, '2021-04-20', '210000.00', 'Truck'),
(10, '2022-01-01', '19000.00', 'Forklift');

-- --------------------------------------------------------

--
-- Table structure for table `FORKLIFT`
--

DROP TABLE IF EXISTS `FORKLIFT`;
CREATE TABLE `FORKLIFT` (
  `FLEET_ID` int(2) NOT NULL,
  `FORK_MAKE` varchar(20) NOT NULL,
  `FORK_TYPE` char(9) NOT NULL CHECK (`FORK_TYPE` in ('Sitting','Standing')),
  `FORK_MAST` int(1) NOT NULL CHECK (`FORK_MAST` between 1 and 3),
  `FORK_BATTERY` int(3) NOT NULL,
  `FORK_MAX_WGT` int(4) NOT NULL,
  `FORK_MAX_HGT` decimal(3,1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `FORKLIFT`
--

INSERT INTO `FORKLIFT` (`FLEET_ID`, `FORK_MAKE`, `FORK_TYPE`, `FORK_MAST`, `FORK_BATTERY`, `FORK_MAX_WGT`, `FORK_MAX_HGT`) VALUES
(4, 'Deer', 'Sitting', 1, 120, 2000, '8.0'),
(5, 'Deer', 'Standing', 2, 120, 2500, '15.0'),
(6, 'Sella', 'Standing', 2, 100, 2200, '14.0'),
(7, 'Deer', 'Standing', 3, 150, 3000, '30.0'),
(10, 'Warehelp', 'Sitting', 1, 100, 2000, '9.0');

--
-- Triggers `FORKLIFT`
--
DROP TRIGGER IF EXISTS `forklift_insert`;
DELIMITER $$
CREATE TRIGGER `forklift_insert` BEFORE INSERT ON `FORKLIFT` FOR EACH ROW BEGIN
	DECLARE x CHAR(8);
	SELECT FLEET_TYPE INTO x FROM FLEET WHERE FLEET_ID = NEW.FLEET_ID;
	IF (x <> "Forklift") THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Cannot insert non-forklifts into Forklift Table";
	END IF;
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `forklift_update`;
DELIMITER $$
CREATE TRIGGER `forklift_update` BEFORE UPDATE ON `FORKLIFT` FOR EACH ROW BEGIN
	DECLARE x CHAR(8);
	SELECT FLEET_TYPE INTO x FROM FLEET WHERE FLEET_ID = NEW.FLEET_ID;
	IF (x <> "Forklift") THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Cannot insert non-forklifts into Forklift Table";
	END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `INSURANCE`
--

DROP TABLE IF EXISTS `INSURANCE`;
CREATE TABLE `INSURANCE` (
  `INSR_ID` int(2) NOT NULL,
  `FLEET_ID` int(2) NOT NULL,
  `INSR_PROV` varchar(30) NOT NULL,
  `INSR_PREM` decimal(7,2) NOT NULL,
  `INSR_RENEW` date NOT NULL DEFAULT (curdate() + interval 1 year)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `INSURANCE`
--

INSERT INTO `INSURANCE` (`INSR_ID`, `FLEET_ID`, `INSR_PROV`, `INSR_PREM`, `INSR_RENEW`) VALUES
(1, 1, 'MARQUE', '4000.00', '2023-09-25'),
(2, 2, 'MARQUE', '3500.00', '2023-09-25'),
(3, 3, 'MARQUE', '3600.00', '2023-09-25'),
(4, 8, 'JDW', '6000.00', '2023-09-25'),
(6, 9, 'ZURIK', '6000.00', '2023-09-26'),
(7, 0, 'DUMMY', '0.00', '1900-01-01');

-- --------------------------------------------------------

--
-- Table structure for table `ITEM`
--

DROP TABLE IF EXISTS `ITEM`;
CREATE TABLE `ITEM` (
  `ITEM_ID` int(5) NOT NULL,
  `ITEM_NAME` varchar(30) NOT NULL,
  `SUPP_ID` int(4) NOT NULL,
  `ITEM_WGT` decimal(5,2) NOT NULL,
  `ITEM_AMOUNT` int(5) NOT NULL DEFAULT 0 CHECK (`ITEM_AMOUNT` between 0 and 60000),
  `ITEM_COST` decimal(5,2) NOT NULL CHECK (`ITEM_COST` between 0.01 and 700.00),
  `ITEM_PRICE` decimal(5,2) NOT NULL CHECK (`ITEM_PRICE` between 0.01 and 999.99)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `ITEM`
--

INSERT INTO `ITEM` (`ITEM_ID`, `ITEM_NAME`, `SUPP_ID`, `ITEM_WGT`, `ITEM_AMOUNT`, `ITEM_COST`, `ITEM_PRICE`) VALUES
(1, 'HeaterCoil', 1, '3.50', 102, '7.00', '10.00'),
(2, 'Buffeter', 1, '25.00', 8, '25.00', '30.00'),
(3, 'CTRL_ELEC', 2, '1.20', 13, '19.00', '25.00'),
(4, 'CTRL_ELEC', 2, '1.50', 3, '20.00', '30.00'),
(5, 'CTRL_ELEC', 2, '1.50', 11, '16.00', '25.00'),
(6, 'RustRemover', 3, '1.00', 11, '15.00', '20.00'),
(7, 'SCREW-0.5', 4, '0.05', 3450, '0.01', '0.05'),
(8, 'SCREW-0.1', 4, '0.02', 4470, '0.05', '0.10'),
(9, 'NAIL-0.5', 4, '0.03', 2950, '0.02', '0.05'),
(10, 'NAIL-1.1', 4, '0.09', 3000, '0.03', '0.05'),
(11, 'WashArm', 5, '1.40', 229, '4.00', '6.99'),
(12, 'WasherFrame', 1, '250.50', 18, '300.00', '599.99'),
(13, 'Fanblade', 0, '0.50', 0, '6.00', '7.40');

-- --------------------------------------------------------

--
-- Table structure for table `ORDER`
--

DROP TABLE IF EXISTS `ORDER`;
CREATE TABLE `ORDER` (
  `ORDER_ID` int(8) NOT NULL,
  `CSTM_ID` int(5) NOT NULL,
  `ORDER_TIME` datetime NOT NULL DEFAULT current_timestamp(),
  `ORDER_COMP` tinyint(1) NOT NULL DEFAULT 0,
  `ORDER_COST` decimal(6,2) NOT NULL CHECK (`ORDER_COST` between 0.00 and 9999.99),
  `ORDER_ADD` varchar(50) NOT NULL,
  `ORDER_CITY` varchar(50) NOT NULL,
  `ORDER_ST` char(2) NOT NULL,
  `ORDER_ZIP` char(5) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `ORDER`
--

INSERT INTO `ORDER` (`ORDER_ID`, `CSTM_ID`, `ORDER_TIME`, `ORDER_COMP`, `ORDER_COST`, `ORDER_ADD`, `ORDER_CITY`, `ORDER_ST`, `ORDER_ZIP`) VALUES
(1, 1, '2020-07-07 00:00:00', 1, '300.97', 'Another Street', 'Somewhere', 'IN', '41417'),
(2, 1, '2021-11-29 00:00:00', 1, '21.50', 'Some Street', 'Somewhere', 'IN', '46147'),
(3, 6, '2022-02-01 00:00:00', 1, '600.00', 'Pennslyvania Avn', 'DC', 'DC', '00000'),
(4, 4, '2022-03-21 00:00:00', 1, '99.99', '466 Oak Brv', 'Chicago', 'IL', '60611'),
(5, 2, '2022-04-01 00:00:00', 1, '101.10', 'Some Street', 'Somewhere', 'IN', '46147'),
(6, 5, '2022-06-28 00:00:00', 1, '67.00', 'Park Avn', 'New York City', 'NY', '44444'),
(7, 1, '2022-08-19 00:00:00', 1, '1.99', 'Another Street', 'Somewhere', 'IN', '41417');

-- --------------------------------------------------------

--
-- Table structure for table `ORDER_ITEM`
--

DROP TABLE IF EXISTS `ORDER_ITEM`;
CREATE TABLE `ORDER_ITEM` (
  `ITEM_ID` int(5) NOT NULL,
  `ORDER_ID` int(8) NOT NULL,
  `ORIT_AMOUNT` int(3) NOT NULL DEFAULT 1 CHECK (`ORIT_AMOUNT` between 0 and 999),
  `ORIT_PACKED` int(3) NOT NULL DEFAULT 0 CHECK (`ORIT_PACKED` <= `ORIT_AMOUNT`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `ORDER_ITEM`
--

INSERT INTO `ORDER_ITEM` (`ITEM_ID`, `ORDER_ID`, `ORIT_AMOUNT`, `ORIT_PACKED`) VALUES
(1, 1, 5, 5),
(1, 2, 2, 2),
(1, 6, 1, 1),
(2, 1, 5, 5),
(3, 1, 2, 2),
(3, 4, 4, 4),
(4, 6, 2, 2),
(5, 5, 4, 4),
(7, 1, 50, 50),
(8, 2, 30, 30),
(9, 1, 50, 50),
(11, 7, 1, 1),
(12, 3, 1, 1);

-- --------------------------------------------------------

--
-- Table structure for table `PACKAGE`
--

DROP TABLE IF EXISTS `PACKAGE`;
CREATE TABLE `PACKAGE` (
  `PACK_ID` int(11) NOT NULL,
  `ORDER_ID` int(8) NOT NULL,
  `EMP_ID` int(3) NOT NULL,
  `PACK_TIME` datetime NOT NULL DEFAULT current_timestamp(),
  `PACK_TYPE` char(4) NOT NULL CHECK (`PACK_TYPE` in ('Bag','Box','Skid')),
  `PACK_WGT` decimal(5,2) NOT NULL CHECK (`PACK_WGT` between 0.01 and 600.00),
  `SHIP_ID` int(7) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `PACKAGE`
--

INSERT INTO `PACKAGE` (`PACK_ID`, `ORDER_ID`, `EMP_ID`, `PACK_TIME`, `PACK_TYPE`, `PACK_WGT`, `SHIP_ID`) VALUES
(1, 1, 2, '2022-09-25 11:07:32', 'Skid', '130.10', 1),
(2, 1, 2, '2022-09-25 11:07:32', 'Box', '22.40', 1),
(3, 2, 3, '2022-09-25 17:05:15', 'Box', '7.10', 2),
(4, 3, 5, '2022-10-25 01:04:15', 'Skid', '253.00', 3),
(5, 4, 6, '2022-09-29 17:15:12', 'Bag', '5.00', 3),
(6, 5, 11, '2022-09-29 17:17:09', 'Bag', '5.10', 4),
(7, 6, 6, '2022-09-26 19:57:41', 'Box', '8.10', 5),
(8, 7, 11, '2022-10-06 19:11:54', 'Box', '2.20', 0);

-- --------------------------------------------------------

--
-- Table structure for table `PACKER`
--

DROP TABLE IF EXISTS `PACKER`;
CREATE TABLE `PACKER` (
  `EMP_ID` int(3) NOT NULL,
  `PCKR_FORK_CRT` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `PACKER`
--

INSERT INTO `PACKER` (`EMP_ID`, `PCKR_FORK_CRT`) VALUES
(2, 1),
(3, 1),
(5, 1),
(6, 0),
(11, 0);

--
-- Triggers `PACKER`
--
DROP TRIGGER IF EXISTS `packers_insert`;
DELIMITER $$
CREATE TRIGGER `packers_insert` BEFORE INSERT ON `PACKER` FOR EACH ROW BEGIN
	DECLARE x CHAR(6);
	SELECT EMP_TITLE INTO x FROM EMPLOYEE WHERE EMP_ID = NEW.EMP_ID;
	IF (x <> "Packer" OR x is NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Cannot insert non-packers into Packer Table";
	END IF;
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `packers_update`;
DELIMITER $$
CREATE TRIGGER `packers_update` BEFORE UPDATE ON `PACKER` FOR EACH ROW BEGIN
	DECLARE x CHAR(6);
	SELECT EMP_TITLE INTO x FROM EMPLOYEE WHERE EMP_ID = NEW.EMP_ID;
	IF (x <> "Packer" OR x is NULL) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Cannot insert non-packers into Packer Table";
	END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `PACK_ITEM`
--

DROP TABLE IF EXISTS `PACK_ITEM`;
CREATE TABLE `PACK_ITEM` (
  `PACK_ID` int(11) NOT NULL,
  `ITEM_ID` int(5) NOT NULL,
  `PKIT_AMOUNT` int(3) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `PACK_ITEM`
--

INSERT INTO `PACK_ITEM` (`PACK_ID`, `ITEM_ID`, `PKIT_AMOUNT`) VALUES
(1, 2, 5),
(2, 1, 5),
(2, 3, 2),
(2, 7, 50),
(2, 9, 50),
(3, 1, 2),
(3, 8, 30),
(4, 12, 1),
(5, 3, 4),
(6, 5, 4),
(7, 1, 1),
(7, 4, 2),
(8, 11, 1);

--
-- Triggers `PACK_ITEM`
--
DROP TRIGGER IF EXISTS `pack_part`;
DELIMITER $$
CREATE TRIGGER `pack_part` BEFORE INSERT ON `PACK_ITEM` FOR EACH ROW BEGIN
	DECLARE x INT DEFAULT NEW.PKIT_AMOUNT;
	DECLARE y INT;
	DECLARE z INT;
	SELECT ITEM.ITEM_AMOUNT INTO y FROM ITEM WHERE ITEM.ITEM_ID = NEW.ITEM_ID;	

	SELECT (ORIT_AMOUNT - ORIT_PACKED) INTO z FROM ORDER_ITEM WHERE ITEM_ID = NEW.ITEM_ID AND
	ORDER_ID = (SELECT ORDER_ID FROM PACKAGE WHERE NEW.PACK_ID = PACK_ID);

	IF (y - x < 0) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Cannot pack more items than exist in stock";
	ELSE UPDATE `ITEM` SET ITEM_AMOUNT = ITEM_AMOUNT - x WHERE ITEM_ID = NEW.ITEM_ID;

	END IF;

	IF (z < NEW.PKIT_AMOUNT) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 
		"Cannot pack larger amount of item than is left in order";

	ELSE UPDATE `ORDER_ITEM` SET ORIT_PACKED = (ORIT_PACKED + NEW.PKIT_AMOUNT)
	WHERE ITEM_ID = NEW.ITEM_ID AND ORDER_ID = (SELECT ORDER_ID FROM PACKAGE WHERE NEW.PACK_ID = PACK_ID);

END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `RESTOCK`
--

DROP TABLE IF EXISTS `RESTOCK`;
CREATE TABLE `RESTOCK` (
  `ITEM_ID` int(5) NOT NULL,
  `RSTK_DATE` date NOT NULL DEFAULT curdate(),
  `RSTK_SUPPLIER` int(4) NOT NULL,
  `RSTK_AMOUNT` int(5) NOT NULL DEFAULT 1 CHECK (`RSTK_AMOUNT` > 0),
  `RSTK_ITEM_COST` decimal(5,2) NOT NULL,
  `RSTK_TOTAL` decimal(12,2) NOT NULL DEFAULT (`RSTK_AMOUNT` * `RSTK_ITEM_COST`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `RESTOCK`
--

INSERT INTO `RESTOCK` (`ITEM_ID`, `RSTK_DATE`, `RSTK_SUPPLIER`, `RSTK_AMOUNT`, `RSTK_ITEM_COST`, `RSTK_TOTAL`) VALUES
(1, '2017-09-01', 1, 10, '7.00', '70.00'),
(1, '2022-09-25', 1, 100, '7.00', '700.00'),
(2, '2017-09-01', 1, 10, '25.00', '250.00'),
(2, '2022-09-26', 1, 3, '25.00', '75.00'),
(3, '2017-09-02', 2, 5, '19.00', '95.00'),
(3, '2022-09-26', 2, 10, '19.00', '190.00'),
(4, '2017-09-02', 2, 5, '20.00', '100.00'),
(5, '2017-09-02', 2, 5, '16.00', '80.00'),
(5, '2018-01-01', 2, 10, '16.00', '160.00'),
(6, '2018-01-01', 3, 10, '15.00', '150.00'),
(6, '2022-09-26', 3, 1, '15.00', '15.00'),
(7, '2018-02-01', 4, 2000, '0.01', '20.00'),
(7, '2022-09-26', 4, 1500, '0.01', '150.00'),
(8, '2018-02-01', 4, 2000, '0.05', '100.00'),
(8, '2022-09-26', 4, 2500, '0.05', '125.00'),
(9, '2018-02-01', 4, 2000, '0.02', '40.00'),
(9, '2022-09-26', 4, 1000, '0.02', '20.00'),
(10, '2018-02-10', 4, 3000, '0.03', '90.00'),
(11, '2018-02-10', 5, 30, '4.00', '120.00'),
(11, '2022-09-26', 5, 200, '4.00', '1000.00'),
(12, '2020-09-08', 1, 5, '300.00', '1500.00'),
(12, '2022-09-26', 1, 3, '300.00', '900.00'),
(12, '2022-10-06', 1, 11, '300.00', '3300.00');

--
-- Triggers `RESTOCK`
--
DROP TRIGGER IF EXISTS `item_restock`;
DELIMITER $$
CREATE TRIGGER `item_restock` BEFORE INSERT ON `RESTOCK` FOR EACH ROW BEGIN
	DECLARE x INT;
	DECLARE y DECIMAL(5,2);
	SELECT SUPP_ID, ITEM_COST INTO x,y FROM ITEM WHERE ITEM_ID = NEW.ITEM_ID;
	IF (x = 0) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Cannot restock an item without a supplier"; 
	ELSE SET NEW.RSTK_SUPPLIER = x;
	END IF;
	SET NEW.RSTK_ITEM_COST = y;
	IF (NEW.RSTK_TOTAL = 0 OR NEW.RSTK_TOTAL = NULL) THEN
 	SET NEW.RSTK_TOTAL = NEW.RSTK_ITEM_COST * NEW.RSTK_AMOUNT;
	END IF;
	UPDATE `ITEM` SET ITEM_AMOUNT = ITEM_AMOUNT + NEW.RSTK_AMOUNT WHERE ITEM_ID = NEW.ITEM_ID;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `SHIPMENT`
--

DROP TABLE IF EXISTS `SHIPMENT`;
CREATE TABLE `SHIPMENT` (
  `SHIP_ID` int(7) NOT NULL,
  `FLEET_ID` int(2) NOT NULL,
  `EMP_ID` int(3) NOT NULL,
  `SHIP_LTIME` datetime NOT NULL,
  `SHIP_ADD` varchar(30) NOT NULL,
  `SHIP_CITY` varchar(30) NOT NULL,
  `SHIP_ST` char(2) NOT NULL,
  `SHIP_ZIP` char(5) NOT NULL,
  `SHIP_DIST` decimal(4,1) NOT NULL,
  `SHIP_COST` decimal(6,2) NOT NULL DEFAULT 0.00,
  `SHIP_WGT` decimal(7,2) NOT NULL DEFAULT 0.00
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `SHIPMENT`
--

INSERT INTO `SHIPMENT` (`SHIP_ID`, `FLEET_ID`, `EMP_ID`, `SHIP_LTIME`, `SHIP_ADD`, `SHIP_CITY`, `SHIP_ST`, `SHIP_ZIP`, `SHIP_DIST`, `SHIP_COST`, `SHIP_WGT`) VALUES
(0, 0, 0, '1900-01-01 00:00:01', 'NOWHERE', 'NOWHERE', 'XX', 'LOST', '0.0', '0.00', '0.00'),
(1, 1, 1, '2022-10-10 17:06:46', '622 EM ST', 'Indianapolis', 'IN', '46201', '30.4', '300.00', '30000.00'),
(2, 2, 4, '2022-10-11 17:10:29', '622 EM ST', 'Indianapolis', 'IN', '46201', '30.4', '341.00', '45000.00'),
(3, 3, 8, '2022-10-11 17:15:23', 'Elmwood Avenue', 'Chicago', 'IL', '60007', '100.4', '551.00', '13000.00'),
(4, 8, 9, '2022-10-14 08:30:45', '102 Daneway', 'Zionsville', 'IN', '46077', '23.4', '101.00', '34000.00'),
(5, 9, 10, '2022-11-02 17:24:45', 'Pokemsi Blvd', 'Mount Sterling', 'KY', '40353', '230.1', '500.60', '47000.00');

--
-- Triggers `SHIPMENT`
--
DROP TRIGGER IF EXISTS `shipment_insert`;
DELIMITER $$
CREATE TRIGGER `shipment_insert` BEFORE INSERT ON `SHIPMENT` FOR EACH ROW BEGIN
	DECLARE x INT;
	SELECT  (5*TRUCK_AXEL) INTO x FROM TRUCK WHERE FLEET_ID = NEW.FLEET_ID;
	IF (NEW.SHIP_WGT > x) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Shipment weight above Truck axel limits: Unsafe"; 
	END IF;
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `shipment_update`;
DELIMITER $$
CREATE TRIGGER `shipment_update` BEFORE UPDATE ON `SHIPMENT` FOR EACH ROW BEGIN
	DECLARE x INT;
	SELECT  (5*TRUCK_AXEL) INTO x FROM TRUCK WHERE FLEET_ID = NEW.FLEET_ID;
	IF (NEW.SHIP_WGT > x) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Shipment weight above Truck axel limits: Unsafe"; 
	END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `SUPPLIER`
--

DROP TABLE IF EXISTS `SUPPLIER`;
CREATE TABLE `SUPPLIER` (
  `SUPP_ID` int(4) NOT NULL,
  `SUPP_NAME` varchar(50) NOT NULL,
  `SUPP_ADD` varchar(50) NOT NULL,
  `SUPP_CITY` varchar(50) NOT NULL,
  `SUPP_ST` char(2) NOT NULL,
  `SUPP_ZIP` char(5) NOT NULL,
  `SUPP_PHONE` char(12) NOT NULL DEFAULT '###-###-####' CHECK (`SUPP_PHONE` like '___-___-____'),
  `SUPP_EMAIL` varchar(50) NOT NULL DEFAULT '???@???' CHECK (`SUPP_EMAIL` like '%@%')
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `SUPPLIER`
--

INSERT INTO `SUPPLIER` (`SUPP_ID`, `SUPP_NAME`, `SUPP_ADD`, `SUPP_CITY`, `SUPP_ST`, `SUPP_ZIP`, `SUPP_PHONE`, `SUPP_EMAIL`) VALUES
(0, 'FORMER_SUPPLIER', 'LOST', 'LOST', 'XX', '', '###-###-####', '???@???'),
(1, 'Mikel Company', '444 Parkway St', 'Detroit', 'MI', '44444', '###-###-####', 'mklc@yahoo.com'),
(2, 'TechFutures', '333 Narkway St', 'Los Angeles', 'CA', '44444', '454-989-1234', 'TechFutr@yahoo.com'),
(3, 'OilSolution', '222 Larkway Avn', 'Indianapolis', 'IN', '44444', '###-###-####', 'Oily@gmail.com'),
(4, 'ScrewyNails', '111 Clarkway St', 'Zionsville', 'IN', '44444', '422-494-0711', 'SWN@gmail.com'),
(5, 'Washy', '999 Oak Bridge', 'Abendale', 'ND', '44444', '222-222-2222', 'WASHY@yahoo.com');

--
-- Triggers `SUPPLIER`
--
DROP TRIGGER IF EXISTS `former_supplier`;
DELIMITER $$
CREATE TRIGGER `former_supplier` BEFORE DELETE ON `SUPPLIER` FOR EACH ROW UPDATE `ITEM` SET SUPP_ID = 0 WHERE ITEM.SUPP_ID = OLD.SUPP_ID
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `TIMECLOCK`
--

DROP TABLE IF EXISTS `TIMECLOCK`;
CREATE TABLE `TIMECLOCK` (
  `EMP_ID` int(3) NOT NULL,
  `CLOCK_IN` datetime NOT NULL DEFAULT current_timestamp(),
  `CLOCK_OUT` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `TIMECLOCK`
--

INSERT INTO `TIMECLOCK` (`EMP_ID`, `CLOCK_IN`, `CLOCK_OUT`) VALUES
(0, '1900-01-01 00:00:01', '1900-01-01 00:00:59'),
(1, '2022-04-05 06:01:24', '2022-04-05 16:02:34'),
(1, '2022-04-06 06:01:21', '2022-04-06 16:03:05'),
(2, '2022-04-05 06:00:36', '2022-04-05 16:00:25'),
(2, '2022-04-06 06:01:24', '2022-04-06 16:02:34'),
(3, '2022-04-05 16:31:00', '2022-04-06 00:31:01'),
(3, '2022-04-06 16:31:00', '2022-04-07 00:33:01'),
(4, '2022-04-06 00:32:01', '2022-04-06 08:32:12'),
(5, '2022-04-06 00:30:36', '2022-04-06 08:31:01'),
(6, '2022-04-05 16:32:06', '2022-04-06 00:32:32'),
(6, '2022-04-06 16:32:06', '2022-04-07 00:33:32'),
(7, '2022-04-05 06:01:21', '2022-04-05 16:03:14'),
(7, '2022-04-06 06:00:06', '2022-04-06 16:01:21'),
(8, '2022-04-05 06:00:06', '2022-04-05 16:01:31'),
(8, '2022-04-06 06:00:36', '2022-04-06 16:00:25'),
(9, '2022-04-06 00:31:25', '2022-04-06 08:30:50'),
(9, '2022-04-07 00:31:25', NULL),
(10, '2022-04-05 16:31:24', '2022-04-06 00:30:12'),
(10, '2022-04-06 16:31:24', '2022-04-07 00:31:12'),
(11, '2022-04-05 16:33:09', '2022-04-06 00:31:00'),
(11, '2022-04-06 16:33:09', '2022-04-07 00:32:00');

-- --------------------------------------------------------

--
-- Table structure for table `TRUCK`
--

DROP TABLE IF EXISTS `TRUCK`;
CREATE TABLE `TRUCK` (
  `FLEET_ID` int(2) NOT NULL,
  `TRUCK_MAKE` varchar(20) NOT NULL,
  `TRUCK_MODEL` varchar(20) NOT NULL,
  `TRUCK_MILE` decimal(3,1) NOT NULL,
  `TRUCK_TANK` int(3) NOT NULL,
  `TRUCK_AXEL` int(5) NOT NULL,
  `TRUCK_PLATE` char(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `TRUCK`
--

INSERT INTO `TRUCK` (`FLEET_ID`, `TRUCK_MAKE`, `TRUCK_MODEL`, `TRUCK_MILE`, `TRUCK_TANK`, `TRUCK_AXEL`, `TRUCK_PLATE`) VALUES
(0, 'LOST', 'LOST', '0.0', 0, 99999, '??????'),
(1, 'Western Star', 'Honsena', '9.5', 160, 10000, 'ABER01'),
(2, 'Western Star', 'Corera', '4.5', 140, 13000, 'SWDG01'),
(3, 'CAT', 'BUSTER', '9.0', 120, 11000, 'ZORLA1'),
(8, 'CAT', 'CASATA', '12.0', 100, 11000, 'T14311'),
(9, 'Bronto', 'BRG', '7.0', 130, 12000, 'R12345');

--
-- Triggers `TRUCK`
--
DROP TRIGGER IF EXISTS `former_truck`;
DELIMITER $$
CREATE TRIGGER `former_truck` BEFORE DELETE ON `TRUCK` FOR EACH ROW UPDATE `SHIPMENT` SET FLEET_ID = 0 WHERE `SHIPMENT`.FLEET_ID = OLD.FLEET_ID
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `truck_insert`;
DELIMITER $$
CREATE TRIGGER `truck_insert` BEFORE INSERT ON `TRUCK` FOR EACH ROW BEGIN
	DECLARE x CHAR(8);
	SELECT FLEET_TYPE INTO x FROM FLEET WHERE FLEET_ID = NEW.FLEET_ID;
	IF (x <> "Truck") THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Cannot insert non-Trucks into Truck Table";
	END IF;
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `truck_update`;
DELIMITER $$
CREATE TRIGGER `truck_update` BEFORE UPDATE ON `TRUCK` FOR EACH ROW BEGIN
	DECLARE x CHAR(8);
	SELECT FLEET_TYPE INTO x FROM FLEET WHERE FLEET_ID = NEW.FLEET_ID;
	IF (x <> "Truck") THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Cannot insert non-Trucks into Truck Table";
	END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `WAGE_REGISTER`
--

DROP TABLE IF EXISTS `WAGE_REGISTER`;
CREATE TABLE `WAGE_REGISTER` (
  `EMP_ID` int(3) NOT NULL,
  `WAGE_DATE` date NOT NULL,
  `WAGE_NEW` decimal(4,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `WAGE_REGISTER`
--

INSERT INTO `WAGE_REGISTER` (`EMP_ID`, `WAGE_DATE`, `WAGE_NEW`) VALUES
(0, '2022-09-25', '0.00'),
(1, '2022-09-25', '17.00'),
(2, '2022-09-25', '17.00'),
(3, '2022-09-25', '15.00'),
(4, '2022-09-25', '15.00'),
(4, '2022-10-06', '15.50'),
(5, '2022-09-25', '19.00'),
(6, '2022-09-25', '14.00'),
(7, '2022-09-25', '21.00'),
(8, '2022-09-25', '14.00'),
(9, '2022-09-25', '15.50'),
(10, '2022-09-25', '19.00'),
(11, '2022-09-25', '10.00');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `ABSENSE`
--
ALTER TABLE `ABSENSE`
  ADD PRIMARY KEY (`EMP_ID`,`ABSC_DATE`),
  ADD UNIQUE KEY `EMP_ID` (`EMP_ID`,`ABSC_DATE`);

--
-- Indexes for table `CUSTOMER`
--
ALTER TABLE `CUSTOMER`
  ADD PRIMARY KEY (`CSTM_ID`),
  ADD UNIQUE KEY `CSTM_UNAME` (`CSTM_UNAME`);

--
-- Indexes for table `DRIVER`
--
ALTER TABLE `DRIVER`
  ADD PRIMARY KEY (`EMP_ID`);

--
-- Indexes for table `EMPLOYEE`
--
ALTER TABLE `EMPLOYEE`
  ADD PRIMARY KEY (`EMP_ID`);

--
-- Indexes for table `FLEET`
--
ALTER TABLE `FLEET`
  ADD PRIMARY KEY (`FLEET_ID`);

--
-- Indexes for table `FORKLIFT`
--
ALTER TABLE `FORKLIFT`
  ADD PRIMARY KEY (`FLEET_ID`);

--
-- Indexes for table `INSURANCE`
--
ALTER TABLE `INSURANCE`
  ADD PRIMARY KEY (`INSR_ID`),
  ADD KEY `INSR_FLT_FK` (`FLEET_ID`);

--
-- Indexes for table `ITEM`
--
ALTER TABLE `ITEM`
  ADD PRIMARY KEY (`ITEM_ID`),
  ADD KEY `SUPP_FK` (`SUPP_ID`);

--
-- Indexes for table `ORDER`
--
ALTER TABLE `ORDER`
  ADD PRIMARY KEY (`ORDER_ID`),
  ADD KEY `CSTM_FK` (`CSTM_ID`);

--
-- Indexes for table `ORDER_ITEM`
--
ALTER TABLE `ORDER_ITEM`
  ADD PRIMARY KEY (`ITEM_ID`,`ORDER_ID`),
  ADD UNIQUE KEY `ITEM_ID` (`ITEM_ID`,`ORDER_ID`),
  ADD KEY `ORIT_ORDER_FK` (`ORDER_ID`);

--
-- Indexes for table `PACKAGE`
--
ALTER TABLE `PACKAGE`
  ADD PRIMARY KEY (`PACK_ID`),
  ADD KEY `PS_FK` (`SHIP_ID`),
  ADD KEY `PE_FK` (`EMP_ID`),
  ADD KEY `PACK_ORDER_FK` (`ORDER_ID`);

--
-- Indexes for table `PACKER`
--
ALTER TABLE `PACKER`
  ADD PRIMARY KEY (`EMP_ID`);

--
-- Indexes for table `PACK_ITEM`
--
ALTER TABLE `PACK_ITEM`
  ADD PRIMARY KEY (`PACK_ID`,`ITEM_ID`),
  ADD UNIQUE KEY `PACK_ID` (`PACK_ID`,`ITEM_ID`),
  ADD KEY `PKIT_ITEM_FK` (`ITEM_ID`);

--
-- Indexes for table `RESTOCK`
--
ALTER TABLE `RESTOCK`
  ADD PRIMARY KEY (`ITEM_ID`,`RSTK_DATE`),
  ADD UNIQUE KEY `ITEM_ID` (`ITEM_ID`,`RSTK_DATE`);

--
-- Indexes for table `SHIPMENT`
--
ALTER TABLE `SHIPMENT`
  ADD PRIMARY KEY (`SHIP_ID`),
  ADD KEY `SHIP_EMP_FK` (`EMP_ID`),
  ADD KEY `SHIP_FLT_FK` (`FLEET_ID`);

--
-- Indexes for table `SUPPLIER`
--
ALTER TABLE `SUPPLIER`
  ADD PRIMARY KEY (`SUPP_ID`);

--
-- Indexes for table `TIMECLOCK`
--
ALTER TABLE `TIMECLOCK`
  ADD PRIMARY KEY (`EMP_ID`,`CLOCK_IN`),
  ADD UNIQUE KEY `EMP_ID` (`EMP_ID`,`CLOCK_IN`);

--
-- Indexes for table `TRUCK`
--
ALTER TABLE `TRUCK`
  ADD PRIMARY KEY (`FLEET_ID`),
  ADD UNIQUE KEY `TRUCK_PLATE` (`TRUCK_PLATE`);

--
-- Indexes for table `WAGE_REGISTER`
--
ALTER TABLE `WAGE_REGISTER`
  ADD PRIMARY KEY (`EMP_ID`,`WAGE_DATE`),
  ADD UNIQUE KEY `EMP_ID` (`EMP_ID`,`WAGE_DATE`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `CUSTOMER`
--
ALTER TABLE `CUSTOMER`
  MODIFY `CSTM_ID` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `EMPLOYEE`
--
ALTER TABLE `EMPLOYEE`
  MODIFY `EMP_ID` int(3) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `FLEET`
--
ALTER TABLE `FLEET`
  MODIFY `FLEET_ID` int(2) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `INSURANCE`
--
ALTER TABLE `INSURANCE`
  MODIFY `INSR_ID` int(2) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `ITEM`
--
ALTER TABLE `ITEM`
  MODIFY `ITEM_ID` int(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `ORDER`
--
ALTER TABLE `ORDER`
  MODIFY `ORDER_ID` int(8) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `PACKAGE`
--
ALTER TABLE `PACKAGE`
  MODIFY `PACK_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `SHIPMENT`
--
ALTER TABLE `SHIPMENT`
  MODIFY `SHIP_ID` int(7) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `SUPPLIER`
--
ALTER TABLE `SUPPLIER`
  MODIFY `SUPP_ID` int(4) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `ABSENSE`
--
ALTER TABLE `ABSENSE`
  ADD CONSTRAINT `ABS_EMP_FK` FOREIGN KEY (`EMP_ID`) REFERENCES `EMPLOYEE` (`EMP_ID`) ON UPDATE CASCADE;

--
-- Constraints for table `DRIVER`
--
ALTER TABLE `DRIVER`
  ADD CONSTRAINT `DRIVE_EMP_FK` FOREIGN KEY (`EMP_ID`) REFERENCES `EMPLOYEE` (`EMP_ID`) ON UPDATE CASCADE;

--
-- Constraints for table `FORKLIFT`
--
ALTER TABLE `FORKLIFT`
  ADD CONSTRAINT `FR_FLT_FK` FOREIGN KEY (`FLEET_ID`) REFERENCES `FLEET` (`FLEET_ID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `INSURANCE`
--
ALTER TABLE `INSURANCE`
  ADD CONSTRAINT `INSR_FLT_FK` FOREIGN KEY (`FLEET_ID`) REFERENCES `TRUCK` (`FLEET_ID`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `ITEM`
--
ALTER TABLE `ITEM`
  ADD CONSTRAINT `SUPP_FK` FOREIGN KEY (`SUPP_ID`) REFERENCES `SUPPLIER` (`SUPP_ID`) ON UPDATE CASCADE;

--
-- Constraints for table `ORDER`
--
ALTER TABLE `ORDER`
  ADD CONSTRAINT `CSTM_FK` FOREIGN KEY (`CSTM_ID`) REFERENCES `CUSTOMER` (`CSTM_ID`) ON UPDATE CASCADE;

--
-- Constraints for table `ORDER_ITEM`
--
ALTER TABLE `ORDER_ITEM`
  ADD CONSTRAINT `ORIT_ITEM_FK` FOREIGN KEY (`ITEM_ID`) REFERENCES `ITEM` (`ITEM_ID`) ON UPDATE CASCADE,
  ADD CONSTRAINT `ORIT_ORDER_FK` FOREIGN KEY (`ORDER_ID`) REFERENCES `ORDER` (`ORDER_ID`) ON UPDATE CASCADE;

--
-- Constraints for table `PACKAGE`
--
ALTER TABLE `PACKAGE`
  ADD CONSTRAINT `PACK_ORDER_FK` FOREIGN KEY (`ORDER_ID`) REFERENCES `ORDER` (`ORDER_ID`) ON UPDATE CASCADE,
  ADD CONSTRAINT `PE_FK` FOREIGN KEY (`EMP_ID`) REFERENCES `PACKER` (`EMP_ID`) ON UPDATE CASCADE,
  ADD CONSTRAINT `PS_FK` FOREIGN KEY (`SHIP_ID`) REFERENCES `SHIPMENT` (`SHIP_ID`) ON UPDATE CASCADE;

--
-- Constraints for table `PACKER`
--
ALTER TABLE `PACKER`
  ADD CONSTRAINT `PACK_EMP_FK` FOREIGN KEY (`EMP_ID`) REFERENCES `EMPLOYEE` (`EMP_ID`) ON UPDATE CASCADE;

--
-- Constraints for table `PACK_ITEM`
--
ALTER TABLE `PACK_ITEM`
  ADD CONSTRAINT `PKIT_ITEM_FK` FOREIGN KEY (`ITEM_ID`) REFERENCES `ITEM` (`ITEM_ID`) ON UPDATE CASCADE,
  ADD CONSTRAINT `PKIT_PACK_FK` FOREIGN KEY (`PACK_ID`) REFERENCES `PACKAGE` (`PACK_ID`) ON UPDATE CASCADE;

--
-- Constraints for table `RESTOCK`
--
ALTER TABLE `RESTOCK`
  ADD CONSTRAINT `RE_ITEM_FK` FOREIGN KEY (`ITEM_ID`) REFERENCES `ITEM` (`ITEM_ID`) ON UPDATE CASCADE;

--
-- Constraints for table `SHIPMENT`
--
ALTER TABLE `SHIPMENT`
  ADD CONSTRAINT `SHIP_EMP_FK` FOREIGN KEY (`EMP_ID`) REFERENCES `DRIVER` (`EMP_ID`) ON UPDATE CASCADE,
  ADD CONSTRAINT `SHIP_FLT_FK` FOREIGN KEY (`FLEET_ID`) REFERENCES `TRUCK` (`FLEET_ID`) ON UPDATE CASCADE;

--
-- Constraints for table `TRUCK`
--
ALTER TABLE `TRUCK`
  ADD CONSTRAINT `TK_FLT_FK` FOREIGN KEY (`FLEET_ID`) REFERENCES `FLEET` (`FLEET_ID`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
