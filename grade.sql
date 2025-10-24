-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Oct 24, 2025 at 11:17 PM
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
-- Database: `grade`
--

-- --------------------------------------------------------

--
-- Table structure for table `academic_sessions`
--

CREATE TABLE `academic_sessions` (
  `academic_session_id` int(11) NOT NULL,
  `school_year_id` int(11) NOT NULL,
  `semester_id` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `academic_sessions`
--

INSERT INTO `academic_sessions` (`academic_session_id`, `school_year_id`, `semester_id`, `created_at`, `updated_at`) VALUES
(1, 1, 1, '2025-10-18 08:04:50', '2025-10-18 08:04:50'),
(2, 1, 2, '2025-10-18 08:04:50', '2025-10-18 08:04:50'),
(3, 1, 3, '2025-10-18 08:04:50', '2025-10-18 08:04:50'),
(4, 2, 1, '2025-10-18 08:04:50', '2025-10-18 08:04:50'),
(5, 2, 2, '2025-10-18 08:04:50', '2025-10-18 08:04:50'),
(6, 2, 3, '2025-10-18 08:04:50', '2025-10-18 08:04:50'),
(7, 3, 1, '2025-10-18 08:04:50', '2025-10-18 08:04:50'),
(8, 3, 2, '2025-10-18 08:04:50', '2025-10-18 08:04:50'),
(9, 3, 3, '2025-10-18 08:04:50', '2025-10-18 08:04:50'),
(10, 4, 1, '2025-10-18 08:04:50', '2025-10-18 08:04:50'),
(11, 4, 2, '2025-10-18 08:04:50', '2025-10-18 08:04:50'),
(12, 4, 3, '2025-10-18 08:04:50', '2025-10-18 08:04:50'),
(13, 5, 1, '2025-10-18 08:04:50', '2025-10-18 08:04:50'),
(14, 5, 2, '2025-10-18 08:04:50', '2025-10-18 08:04:50'),
(15, 5, 3, '2025-10-18 08:04:50', '2025-10-18 08:04:50'),
(16, 6, 1, '2025-10-18 08:04:50', '2025-10-18 08:04:50'),
(17, 6, 2, '2025-10-18 08:04:50', '2025-10-18 08:04:50'),
(18, 6, 3, '2025-10-18 08:04:50', '2025-10-18 08:04:50'),
(19, 7, 1, '2025-10-18 08:04:50', '2025-10-18 08:04:50'),
(20, 7, 2, '2025-10-18 08:04:50', '2025-10-18 08:04:50'),
(21, 7, 3, '2025-10-18 08:04:50', '2025-10-18 08:04:50'),
(22, 8, 1, '2025-10-18 08:04:50', '2025-10-18 08:04:50'),
(23, 8, 2, '2025-10-18 08:04:50', '2025-10-18 08:04:50'),
(24, 8, 3, '2025-10-18 08:04:50', '2025-10-18 08:04:50'),
(25, 9, 1, '2025-10-18 08:04:50', '2025-10-18 08:04:50'),
(26, 9, 2, '2025-10-18 08:04:50', '2025-10-18 08:04:50'),
(27, 9, 3, '2025-10-18 08:04:50', '2025-10-18 08:04:50'),
(28, 10, 1, '2025-10-18 08:04:50', '2025-10-18 08:04:50'),
(29, 10, 2, '2025-10-18 08:04:50', '2025-10-18 08:04:50'),
(30, 10, 3, '2025-10-18 08:04:50', '2025-10-18 08:04:50'),
(31, 11, 1, '2025-10-18 08:04:50', '2025-10-18 08:04:50'),
(32, 11, 2, '2025-10-18 08:04:50', '2025-10-18 08:04:50'),
(33, 11, 3, '2025-10-18 08:04:50', '2025-10-18 08:04:50'),
(34, 12, 1, '2025-10-18 08:04:50', '2025-10-18 08:04:50'),
(35, 12, 2, '2025-10-18 08:04:50', '2025-10-18 08:04:50'),
(36, 12, 3, '2025-10-18 08:04:50', '2025-10-18 08:04:50'),
(37, 13, 1, '2025-10-18 08:04:50', '2025-10-18 08:04:50'),
(38, 13, 2, '2025-10-18 08:04:50', '2025-10-18 08:04:50'),
(39, 13, 3, '2025-10-18 08:04:50', '2025-10-18 08:04:50'),
(40, 14, 1, '2025-10-18 08:04:50', '2025-10-18 08:04:50'),
(41, 14, 2, '2025-10-18 08:04:50', '2025-10-18 08:04:50'),
(42, 14, 3, '2025-10-18 08:04:50', '2025-10-18 08:04:50'),
(43, 15, 1, '2025-10-18 08:04:50', '2025-10-18 08:04:50'),
(44, 15, 2, '2025-10-18 08:04:50', '2025-10-18 08:04:50'),
(45, 15, 3, '2025-10-18 08:04:50', '2025-10-18 08:04:50');

-- --------------------------------------------------------

--
-- Table structure for table `grades`
--

CREATE TABLE `grades` (
  `grade_id` int(11) NOT NULL,
  `student_id` varchar(50) NOT NULL,
  `subject_id` int(11) NOT NULL,
  `academic_session_id` int(11) NOT NULL,
  `year_level_id` int(11) NOT NULL,
  `period_id` int(11) NOT NULL,
  `grade` decimal(5,2) NOT NULL,
  `category` enum('NMS','PTS','MP','EHP') DEFAULT NULL,
  `status` enum('PASS','FAIL') DEFAULT NULL,
  `added_by` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `school_years`
--

CREATE TABLE `school_years` (
  `school_year_id` int(11) NOT NULL,
  `school_year` varchar(50) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `school_years`
--

INSERT INTO `school_years` (`school_year_id`, `school_year`, `created_at`, `updated_at`) VALUES
(1, 'SY 25-26', '2025-10-18 08:03:38', '2025-10-18 08:03:38'),
(2, 'SY 26-27', '2025-10-18 08:03:38', '2025-10-18 08:03:38'),
(3, 'SY 27-28', '2025-10-18 08:03:38', '2025-10-18 08:03:38'),
(4, 'SY 28-29', '2025-10-18 08:03:38', '2025-10-18 08:03:38'),
(5, 'SY 29-30', '2025-10-18 08:03:38', '2025-10-18 08:03:38'),
(6, 'SY 30-31', '2025-10-18 08:03:38', '2025-10-18 08:03:38'),
(7, 'SY 31-32', '2025-10-18 08:03:38', '2025-10-18 08:03:38'),
(8, 'SY 32-33', '2025-10-18 08:03:38', '2025-10-18 08:03:38'),
(9, 'SY 33-34', '2025-10-18 08:03:38', '2025-10-18 08:03:38'),
(10, 'SY 34-35', '2025-10-18 08:03:38', '2025-10-18 08:03:38'),
(11, 'SY 35-36', '2025-10-18 08:03:38', '2025-10-18 08:03:38'),
(12, 'SY 36-37', '2025-10-18 08:03:38', '2025-10-18 08:03:38'),
(13, 'SY 37-38', '2025-10-18 08:03:38', '2025-10-18 08:03:38'),
(14, 'SY 38-39', '2025-10-18 08:03:38', '2025-10-18 08:03:38'),
(15, 'SY 39-40', '2025-10-18 08:03:38', '2025-10-18 08:03:38');

-- --------------------------------------------------------

--
-- Table structure for table `semesters`
--

CREATE TABLE `semesters` (
  `semester_id` int(11) NOT NULL,
  `semester_name` varchar(50) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `semesters`
--

INSERT INTO `semesters` (`semester_id`, `semester_name`, `created_at`, `updated_at`) VALUES
(1, '1st Semester', '2025-10-18 08:04:05', '2025-10-18 08:04:05'),
(2, '2nd Semester', '2025-10-18 08:04:05', '2025-10-18 08:04:05'),
(3, 'Summer', '2025-10-18 08:04:05', '2025-10-18 08:04:05');

-- --------------------------------------------------------

--
-- Table structure for table `students`
--

CREATE TABLE `students` (
  `student_id` varchar(50) NOT NULL,
  `name` varchar(255) NOT NULL,
  `college` varchar(100) DEFAULT NULL,
  `course` varchar(100) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `students`
--

INSERT INTO `students` (`student_id`, `name`, `college`, `course`, `created_at`, `updated_at`) VALUES
('02-1314-01647', 'MAGPANTAY, VAN JAMIN CANTERO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-1314-02812', 'ADORA, KHEN DACULA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:39', '2025-10-18 08:07:39'),
('02-1415-01017', 'DAAYATA, CHARITY EUCOGCO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-1415-02008', 'SUMAGANG, ANGEL CLEO ADAJAR', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-1516-00397', 'VILLAMOR, REY MART MACABINLAR', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-1516-01541', 'TILLO, VINCE JOLIO TANCONGCO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-1516-03136', 'CULABAN, CLARK JIMENEZ', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-1516-04929', 'SULIB, KATHLEEN JOY BUSTILLO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-1516-05539', 'DAYATA, ALFONSO JULIAN VELOSO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-1617-00627', 'CABUSOG, JECHAM REY TUYOGON', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:40', '2025-10-18 08:07:40'),
('02-1617-05312', 'FABIAÑA, ALBER JR. DANSILA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-1617-05557', 'GALARRITA, LAWRENCE DAIGN MACALAGUING', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-1617-05721', 'MANONGDO, MARGARETH PABUNAN', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-1617-06225', 'PADERE, RAI MOSES LIM', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-1718-00716', 'MEDEQUISO, EARL KARL NACAITUNA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-1718-01216', 'BEJONA, ZESAR JEN BALANE', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:40', '2025-10-18 08:07:40'),
('02-1718-02079', 'APOR, SELVESTER BALDON', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:39', '2025-10-18 08:07:39'),
('02-1718-02927', 'ASPIRAS, REINER LAURIANO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:39', '2025-10-18 08:07:39'),
('02-1718-03273', 'ZATA, BOSS LORENZO ASUNCION', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:46', '2025-10-18 08:07:46'),
('02-1718-03652', 'VACALARES, KIRK FRELAN MABAYLAN', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-1718-04688', 'MAXINO, KEITH MATIVO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-1819-00551', 'SALONOY, JERIC JEMUEL ESPAÑOL', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-1819-01110', 'SANTOS, CHESTER KYLE AYONAN', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-1819-01509', 'GALLEGOS, RALPH JAN PELIÑO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-1819-01520', 'CABAHUG, HONEY PEARL EGACO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:40', '2025-10-18 08:07:40'),
('02-1819-01641', 'CATID, EDMARLEN BRIONES', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-1819-02484', 'ARAZO JR., ROY SOLMAYOR', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:39', '2025-10-18 08:07:39'),
('02-1819-02515', 'BALACUIT, ZYANAH GWYNETH PONAY', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:40', '2025-10-18 08:07:40'),
('02-1819-03180', 'EDUAVE, ALLAN GABRIEL FRANCO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-1819-05668', 'SIA, YVES KHYNN CHARYL CELESTE', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-1819-06103', 'TOLIB, JOHNRYL PEÑAFOR', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-1819-07163', 'CAHAYAG, CLIENT ALABA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:40', '2025-10-18 08:07:40'),
('02-1920-00125', 'EGAMA, JOEL BILLONES', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-1920-00603', 'POLINAR, FRANKLEN ASIÑERO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-1920-00892', 'MANGONDATO, ZHEDRICK A', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-1920-01342', 'SOLIS, MAY JOY TIMBAL', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-1920-01590', 'BONIAO, JUNNARDO GASES', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:40', '2025-10-18 08:07:40'),
('02-1920-02039', 'RAL, LEOJHAY GAVIOLA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-1920-02074', 'FERRARIZ, JOEJETTE OLANO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-1920-02515', 'NAMOC, MARC ANDY SINGAYAN', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-1920-02724', 'PIMENTEL, CHARLIE GIN ABSIN', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-1920-04554', 'CASING, CHRICELLE MALING', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-1920-04677', 'RATILLA, CRISTIAN PAUL ARSENAL', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-1920-05774', 'BOBOROL, CHRISTINA BALATERO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:40', '2025-10-18 08:07:40'),
('02-2021-00159', 'PLAZA, KRYSTYLL IRA ANDREI TANO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2021-00210', 'DAYATA, MITCHEL', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2021-00344', 'DICHOS, KRISTOPHER VIADO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2021-01009', 'GALAROSA JR., JERRY ORCAJO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-2021-01013', 'BALABA, REYZYL ALCANTARA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:40', '2025-10-18 08:07:40'),
('02-2021-01034', 'LUSDOC, FRANCIS JOHN AKUT', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2021-01146', 'PAGUTA, JACOB JOHN CABONILAS', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2021-01159', 'QUIÑO, JAMAICHA MALAQUE', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2021-01274', 'CAAMIÑO, JANNETH BUCIO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:40', '2025-10-18 08:07:40'),
('02-2021-01372', 'MARISTELA, JAN NICHOLS NGUYEN', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2021-01409', 'GO, MAR LOUIS PIMENTEL', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-2021-01411', 'LUMAYAG, LAILA JEAN NAVARRO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2021-01479', 'LIPAO, DJOHN LAUREN L.', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2021-01497', 'ANDUS, JEYAN PAUL MANIB', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:39', '2025-10-18 08:07:39'),
('02-2021-01540', 'VALLE, CHRISTIAN MARK SIAHAY', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2021-01634', 'PLAZO, MARJELIANA SUMAYLO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2021-01735', 'BACSARSA, CHRISTINE GRACE ISRAEL', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:39', '2025-10-18 08:07:39'),
('02-2021-01795', 'ZAGADO, JOHN LOUISE AMISTOSO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:46', '2025-10-18 08:07:46'),
('02-2021-01835', 'BARTE, VINCENT JOHN', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:40', '2025-10-18 08:07:40'),
('02-2021-02043', 'JASO, JOHN NATHANIEL CAGO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-2021-02401', 'DOBLE, XENA PO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2021-03016', 'LEONA, HONEY FAITH', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2021-03117', 'LATRAS, ERL PERSEUS II GOMEZ', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-2021-03347', 'WAPAT, CHRISTINE JANE CAMPOMANES', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:46', '2025-10-18 08:07:46'),
('02-2021-03387', 'ABAS, ANDRE PELONIO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:39', '2025-10-18 08:07:39'),
('02-2021-03668', 'GABONADA, DAVID JOSH CANDELASA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-2021-03774', 'GARBO, KIMBERLYGRACE GUILARAN', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-2021-03843', 'TIMBAL, ARMIE JANE RAGMAC', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2021-03864', 'PORRAS, ALFRED KIRK BONTAO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2021-04212', 'LABITAD, LOUSEL ALIGATO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-2021-04532', 'BIBOSO, GLENN ROYALE MADRONA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:40', '2025-10-18 08:07:40'),
('02-2021-04543', 'LEGASPI, GIANN ISIDORE', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2021-04906', 'HIPOLITO, YODGE EXECKIEL', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-2021-05142', 'BRUCE, HARLEY STEVE CONSTANCIO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:40', '2025-10-18 08:07:40'),
('02-2021-05299', 'HIBAYA, CARL JEFFREY RANISES', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-2122-000269', 'MAGPULONG, MONETH F.', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2122-00574', 'ANCHES, LAURENZ AIZEL SINGIDAS', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:39', '2025-10-18 08:07:39'),
('02-2122-01198', 'DURA, STEPHANE DAWN SALON', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2122-030015', 'ABELLA, ALDIN ABECIA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:39', '2025-10-18 08:07:39'),
('02-2122-030041', 'LUMANDO, KING MJ SINALUBA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2122-030180', 'BAUTISTA, MARIOLITO BAAY', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:40', '2025-10-18 08:07:40'),
('02-2122-030490', 'RALUTO, ANDREW JONES PELIGRO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2122-030497', 'JADAP, KARYLLE BELLE REÑOS', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-2122-030545', 'AGAD, DAVE TACUEL', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:39', '2025-10-18 08:07:39'),
('02-2122-030899', 'PACANA, SHANDY SEDON', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2122-030923', 'LAGO, MICAH DUSIL', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-2122-031171', 'ROAYA, FRANCIS JAKE LUMACTOD', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2122-031351', 'ROMERO, MIKIE ANGELYN ALLEGO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2122-031448', 'VILLADORES, ERWIN SISA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2122-031582', 'VILLALOBOS, KRIEZYL LORONO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2122-031682', 'SIMENE, REY VINCENT AMBAL', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2122-031689', 'LUMONGSOD, MARK ADRIAN BATAWAN', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2122-032423', 'RIVERA, RODGE KURT DAGUIMOL', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2122-032611', 'ZAPICO, LOUIE CASSANDRA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:46', '2025-10-18 08:07:46'),
('02-2122-032662', 'BOOC, SHAIRAH JACKIELYN GUMAPON', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:40', '2025-10-18 08:07:40'),
('02-2122-032756', 'CAJILLA, JAIRUS JEHV DAP-OG', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:40', '2025-10-18 08:07:40'),
('02-2122-032811', 'LALANAN, JAY ANNE GUA-AN', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-2122-032860', 'TAN, HANZ EARL AZUCENA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2122-033020', 'JAVIER, JOHN RICHARD CORREOS', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-2122-033095', 'UYGUANGCO, FRANCIS BARON BONGADO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2122-033234', 'DUMAPIAS, KHARL NASH MADERAL', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2122-033335', 'LAMBAYAN, ALINOR BANGCOLA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-2122-033389', 'TORION, JEZREEL ADRIAN MACTAL', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2122-033478', 'PACAAMBUNG, NORCAYA MARIANO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2122-033522', 'TABUDLONG, KRIS CAMILLE GALINADA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2122-033586', 'VENTIC, ALDRIN DAVE VILLANUEVA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2122-033590', 'SABELLINA, JESSEL VON HIBAYA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2122-033669', 'BUCOD, LYN-GEI MAE APARILLA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:40', '2025-10-18 08:07:40'),
('02-2122-033709', 'WABAN, EXEQUIL DANIEL BANGCAS', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:46', '2025-10-18 08:07:46'),
('02-2122-033925', 'SALE, ALJE GALDO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2122-034033', 'ABROGAR, FRANCISMILE NOAH BORGADOR', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:39', '2025-10-18 08:07:39'),
('02-2122-034040', 'MICARTE, AARON YANO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2122-034066', 'KILAT, SATHYA LIBATIQUE', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-2122-034194', 'EMANO, JAMES OLIVER MALANOG', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2122-034263', 'RAAGAS, KNIGHT HEZEKIAH BARCENA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2122-034347', 'WANIWAN, DERRICK GABRIELLE LAZAR', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:46', '2025-10-18 08:07:46'),
('02-2122-034378', 'BANUAG, EIXER GORRES', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:40', '2025-10-18 08:07:40'),
('02-2122-034498', 'SABILLO, JHARED BULATETE', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2122-034643', 'JAMOROL, JADE KENNETH BADILLA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-2122-034813', 'LINAAC, SHANDI KATE AMPO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2122-035128', 'CAÑETE, EDWIN KILAT JR.', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:40', '2025-10-18 08:07:40'),
('02-2122-035140', 'CAGADAS, KEY XANDER BENDIJO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:40', '2025-10-18 08:07:40'),
('02-2122-035541', 'LOZANO, SHERLYN ALTRECHA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2122-035546', 'PABILONA, SEAN JONEIL SORDILLA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2122-035640', 'AMORGANDA, YRON HAMOT', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:39', '2025-10-18 08:07:39'),
('02-2122-035660', 'CABAÑAS, JOBERT RAMOS', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:40', '2025-10-18 08:07:40'),
('02-2122-035681', 'JABASA, WILLIAM JUSTIN CHARL NALA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-2122-035764', 'JARAMILLO, BRITT GESALAN', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-2122-035906', 'GUTIERREZ, CARL ALDRIN RAZO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-2122-035911', 'VILLA, RED STEPHEN TAN', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2122-035956', 'DEREGLA, EARL RYAN TABUAN', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2122-035985', 'PINATACAN, RUFUS AQUILIS DELACERNA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2122-036118', 'MANAMOSA, JASON ILAO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2122-036189', 'DATU, NICK RYSHER PACULBA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2223-000043', 'TURTOSA, FRITZ GERALD MICULOB', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2223-00023', 'NOYNAY, CHRISTIAN SACOSO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2223-00058', 'HALIBAS, PAUL ANGELO TIGOL', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-2223-000697', 'BAANAN, PAUL JOSEPH DOBLE', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:39', '2025-10-18 08:07:39'),
('02-2223-00100', 'SAPICO, REYNALD HAN CALUNSAG', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2223-00107', 'UMAS-AS, GRIZYL VILLARIN', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2223-00109', 'BULO, ALBRITCH JOHN CANOOG', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:40', '2025-10-18 08:07:40'),
('02-2223-00149', 'ESDICUL, KRISTINE SAY NAVARRO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2223-00171', 'SABANAL, JOHN VINCENT PATRICIO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2223-00201', 'DIZON, EZREIL JAMES PORGARILLAS', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2223-00205', 'BORRES, ANGELA CLARISE SAGARAL', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:40', '2025-10-18 08:07:40'),
('02-2223-00206', 'EBARAT, JOHANNA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2223-00310', 'PACATANG, ALLANA LIVI LALAMORO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2223-00587', 'CASTILLO, IVAN DAVE OMEGA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2223-00603', 'CABAÑAS, CRISTY JANE ABELLO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:40', '2025-10-18 08:07:40'),
('02-2223-00660', 'GUTIERREZ, CHARLES MARIE NARANJO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-2223-00686', 'BUASA, JOHN MICHAEL NEL CARAMONTE', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:40', '2025-10-18 08:07:40'),
('02-2223-00775', 'OBLIOSCA, NILE CHRISTIAN TAN', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2223-00787', 'JARIOLNE, AARON DAVE NAVIDAS', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-2223-00932', 'BATERNA, JUNEL CAJOLES', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:40', '2025-10-18 08:07:40'),
('02-2223-00935', 'RUBEN, CHRISTIAN JAY AYUBAN', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2223-01058', 'ESPINOSA, MICHAEL ROGER V', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2223-01100', 'TULEN, ALEX JOHN LABIS', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2223-01310', 'DAMLOAN, MARKGIE CABALLA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2223-01332', 'SUSON, BERNADINE ENGUITO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2223-01528', 'ENG, MARIAN NOVE LUMACANG', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2223-01533', 'SAMBAAN, ELIJA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2223-01542', 'MAGLINAO, ROJEMEL LUMACANG', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2223-01554', 'OCHAVILLO, CHELL ANN VILLALUZ', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2223-01613', 'DABATIAN, CLAIR ROSE SMITH', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2223-01713', 'VISAYA, FRANCIS ELLA MARIE NAGANDANG', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2223-01723', 'FABREA, REALAN KING YU', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2223-01734', 'MAYORDOMO, IMMARI LEA BACULIO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2223-01741', 'TAGAAN, RUDGEL SALES', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2223-01742', 'DE GUZMAN, OMELA CABILLO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2223-01904', 'VILLARMIA, KARYLLE ANN MERCADO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2223-01913', 'PABAYO, JULIUS GUATNO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2223-01955', 'PAGULA, JUDY-AN ROMERA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2223-02043', 'CORSIGA, KIRBY NOLLAS', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2223-02225', 'JOHANSSON, CRISTOPHER SISAYAN', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-2223-02290', 'CABUAL, KESHTIAN MARK NACAWILI', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:40', '2025-10-18 08:07:40'),
('02-2223-02299', 'LEGAHON, STEPHANIE BACALSO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2223-02331', 'SALEM, ROLLIE VILLANUEVA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2223-02335', 'TUMALA, MICHAEL VERANO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2223-02378', 'BANSING, PAUL MARKUSS SUELLO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:40', '2025-10-18 08:07:40'),
('02-2223-02386', 'ARCANSES, MARK DOMINIC EGNALIG', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:39', '2025-10-18 08:07:39'),
('02-2223-02389', 'TRANGIA, CHRISTIAN ABAS', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2223-02527', 'PANONG, EMMANUEL AMPORINGUEZ', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2223-02578', 'CASTILLON, CHARLES EDWARD AMOTO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2223-02581', 'PAJARON, KERBY JAMES MABELO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2223-02644', 'LONTAYAO, JUSTINE CLARKJ ROA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2223-02645', 'SALAMAÑA, GERALD REYES', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2223-02647', 'PEREZ, NOB WENDEL SIMBLANTE', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2223-02691', 'ZARATE, KENNETH VALLEDOR', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:46', '2025-10-18 08:07:46'),
('02-2223-02718', 'BACASMOT, ISAACJAMES PIALAN', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:39', '2025-10-18 08:07:39'),
('02-2223-02745', 'SOLIDARIOS, ZAIRO BIENVENUTO DADANG', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2223-02850', 'TAROC, ALJAN FIERRIE EPAN', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2223-02917', 'PINOTE, ENGELERIC CAAYAO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2223-02939', 'CAPARAS, KEITH ANDREW CABIGQUEZ', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:40', '2025-10-18 08:07:40'),
('02-2223-02943', 'ORMILLA, APPLE JANE HAYAHAY', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2223-02997', 'CASTILLO, ROBERT DIXON', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2223-03010', 'JACOB, SHARMAINE ALMAHAN', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-2223-03161', 'CALINAWAN, KHENDAL THUR', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:40', '2025-10-18 08:07:40'),
('02-2223-03204', 'PLAMOS, ANDREA MARIE BAROMA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2223-03206', 'GUANGCO, VAN MORRE ACAYLAR', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-2223-03270', 'TAROY, CLINE JAY EYANA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2223-03298', 'ANTIPUESTO, JAMES HAROLD', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:39', '2025-10-18 08:07:39'),
('02-2223-03299', 'SALISE, ARJON DAVE GRANADA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2223-03307', 'MONTEJO, HEIDERN VILLASENCIO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2223-03327', 'CAÑETE, JOSHUA ABUZO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:40', '2025-10-18 08:07:40'),
('02-2223-03357', 'SISMUNDO, MARK RENIEL LUMINGKIT', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2223-03381', 'TIN-AO, BENCH BETE', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2223-03507', 'CLAUDEL, KATHLYN TABA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2223-03530', 'CANTILADO, LYCA BAHANDI', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:40', '2025-10-18 08:07:40'),
('02-2223-03535', 'MADELO, CARL VINCENT DADANG', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2223-03553', 'BAAL, MICAH APZA AMPARO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:39', '2025-10-18 08:07:39'),
('02-2223-03570', 'OLAERA, ALTHEA SHAIRA MAE SEVILLA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2223-03633', 'DECENA, JESSA HAMBORA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2223-03654', 'AGUIRRE, LOUWIE JIE CAGAS', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:39', '2025-10-18 08:07:39'),
('02-2223-03699', 'SUMANDA, STEPHEN ELLEVERA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2223-03708', 'DAYADAYA, MARC DEXTER RUFANO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2223-03835', 'AQUINO, MICHAEL JOSEPH A', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:39', '2025-10-18 08:07:39'),
('02-2223-03936', 'PAGAPONG, JOSH YDRIANNE BALISACAN', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2223-03955', 'SANGRANO, JOHN MICHAEL', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2223-03971', 'SIMON, CHRISTOPHER JR ABANIL', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2223-03986', 'VIRTUDEZ, CEDRICK NUÑEZ', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2223-04051', 'RAFOLS, KEANU EDWARD MACASPAC', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2223-04055', 'HAMOT, MARK IAN DANAGO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-2223-04058', 'SAGUING, ASHLEY JUSTIN ENRIQUE GERALDIZO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2223-04062', 'TUNDAY, CHRISTIAN JOHN DOMAOG', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2223-04129', 'GARCIA, ALIX BORNEA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-2223-04199', 'BACULIO, CARL JOSHUA BUSTAMANTE', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:39', '2025-10-18 08:07:39'),
('02-2223-04211', 'BADLISAN, JASPHER ANDREI ARGAYOSO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:39', '2025-10-18 08:07:39'),
('02-2223-04413', 'MAESTRADO, RYCILLE TAWACAL', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2223-04439', 'ABUMOHAIMEN, MOHAMAD HASSAN SOLAIMAN', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:39', '2025-10-18 08:07:39'),
('02-2223-04506', 'TORREJAS, BANSKIN ROBBIN LIGTAS', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2223-04521', 'PEROCHO, ALLIANA NICOLE ABA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2223-04545', 'ABRATIGUIN, ELLESE AARON L.', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:39', '2025-10-18 08:07:39'),
('02-2223-04551', 'PAROL, CLYDE DENZEL LUMAYOD', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2223-04598', 'DALAUTA, CARL VINCENT DIANGO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2223-04706', 'PACALDO, LOUIGE', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2223-04730', 'MAESTRADO, SHAINA LADET', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2223-04735', 'MADLOS, JOHN MARK OLARIO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2223-04779', 'LOMONGO, NEIL CHRISTIAN BALANSAG', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2223-04970', 'GUTUAL, UJ GOBY VALLEJOS', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-2223-04972', 'CONTA, MICHELLE ALBAO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2223-04987', 'GABILAN, CHRISTIAN REY DALMAN', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-2223-05043', 'TADANG, JESSRIEL BERDON', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2223-05206', 'TAGUBA, ELVIS, JR. TAGAB', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2223-05228', 'MARIQUIT, MARJORIE SOSOSCO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2223-05232', 'RAFLORES, ALEXANDRA NAVALES', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2223-05280', 'GILDO, KENT WILSON CABALLERO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-2223-05315', 'TILLANO, HANNAH ARANDUQUE', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2223-05397', 'FRANCO, ANGELA SABIDOR', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-2223-05414', 'MUA, ABDALLAH MANTOYAN', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2223-05422', 'DIESTA, JULE ANDREW MAHISTRADO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2223-05502', 'ESQUIA, KINT JAY PAUL', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2223-05555', 'BONGGAY, ANGELY EVE AMORTIZADO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:40', '2025-10-18 08:07:40'),
('02-2223-05637', 'SARANG, KENT ZACHIE ABRIOL', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2223-05673', 'SANGCOPAN, HARRY EJ JARIOLNE', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2223-05776', 'JUMAMOY, FRANCIS BENEDICT PONTALBA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-2223-05866', 'BRUFAL, JAYSON JOHN GALINDO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:40', '2025-10-18 08:07:40'),
('02-2223-05879', 'MAANDIG, MEDWIN SENDON', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2223-05883', 'TANGGOTE, RAIHANNAH LABRADOR', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2223-05922', 'TAN, RJ LOUISE RAMOS', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2223-05936', 'RUDINAS, ELA SAYRE', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44');
INSERT INTO `students` (`student_id`, `name`, `college`, `course`, `created_at`, `updated_at`) VALUES
('02-2223-05976', 'ESPARTERO, JEREMIAH EXEQUIEL', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2223-06012', 'SAARENAS, ED FRANCIS TURTOSA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2223-06062', 'ELANO, GIDEON PAUL PINGKIAN', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2223-06092', 'OTERO, KENNETH', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2223-06139', 'TAMAYO, JHON LOWEN SON', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2223-06290', 'MABUNAY, AINSLEY KHATE PABELIC', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2223-06313', 'GERMUDO, DAVE LUIS VILLANCIO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-2223-06336', 'DALION, JEWEL VON LLIDO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2223-06421', 'ABENIR, KENT EZRA ALBERASTINE', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:39', '2025-10-18 08:07:39'),
('02-2223-06471', 'WAMINAL, SHAN CAñETE', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:46', '2025-10-18 08:07:46'),
('02-2223-06498', 'ACEDERA, HEZIE PASCUA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:39', '2025-10-18 08:07:39'),
('02-2223-06499', 'VIOLA, IMMANUEL JHON OLAYON', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2223-06524', 'FLORES, VINCE ANDREW SABAL', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2223-06709', 'MORCILLOS, JESSE RAY ZARATE', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2223-06740', 'GAMON, RICHARD SHANE MONTIZOR', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-2223-06742', 'BALDOZA, RAZIEL JADE DIAPANA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:40', '2025-10-18 08:07:40'),
('02-2223-06804', 'GAYLA, JOHN ROVIR CAMANNONG', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-2223-06835', 'CABARDO, GUILMAR MANGARON', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:40', '2025-10-18 08:07:40'),
('02-2223-06866', 'BUTAYA, CHRISTIAN COLIPANO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:40', '2025-10-18 08:07:40'),
('02-2223-06966', 'TAGULAO, JAMES VINCENT EYAC', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2223-07034', 'ZAPICO, PAOLO MIGUEL PENALES', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:46', '2025-10-18 08:07:46'),
('02-2223-07050', 'OLANO, KIAN CARLO MAGSACAY', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2223-07098', 'CABELTES, CHRISTINE MAY PEQUERO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:40', '2025-10-18 08:07:40'),
('02-2223-07123', 'YLAYA, DEN ANDREW MANISAN', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:46', '2025-10-18 08:07:46'),
('02-2223-07124', 'GALARPE, QUENNIELYN MABAYLAN', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-2223-07125', 'CLEMEÑA, JOHN REY QUINTO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2223-07132', 'BAYLOSIS, FROILAN REY BUGAY', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:40', '2025-10-18 08:07:40'),
('02-2223-07143', 'VAYSON, CHARLENE COTEJAL', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2223-07266', 'RULE, LOVERN JAY', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2223-07374', 'JAMERO, VASH AUSRAEL ORTIZ', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-2223-07402', 'ABAN, MICHELLE JEAN CAMPILAN', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:39', '2025-10-18 08:07:39'),
('02-2223-07447', 'ALIGATO, JANSMILE GAHUMAN', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:39', '2025-10-18 08:07:39'),
('02-2223-07528', 'EPE, IVAN JOSEPH RIVAS', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2223-07626', 'MACUSE, C JAY LOGONG', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2223-07708', 'DABLO, PANCHITO JR. PLANAS', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2223-07710', 'GONZAGA, SHAN CLARK JABIÑAO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-2223-07711', 'PANAGUITON, KYNT LOIGE CABILES', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2223-07724', 'ASPIRAS, PATRICIA JABAGAT', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:39', '2025-10-18 08:07:39'),
('02-2223-07772', 'AQUILAM, CLYDE SABACAJAN', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:39', '2025-10-18 08:07:39'),
('02-2223-07801', 'CLARIÑO, CHRISTIAN EJAY HISOLER', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2223-07841', 'NERONA, PAUL ANDREW LARA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2223-07987', 'CANONCE, MARY ANN', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:40', '2025-10-18 08:07:40'),
('02-2223-08003', 'SATUR, PAULO ABES', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2223-08017', 'BASA, DENVER YU', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:40', '2025-10-18 08:07:40'),
('02-2223-08208', 'PEPITO, EMAN NEESRIN CHIONG', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2223-08342', 'Garcia, JONH HARRY', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-2223-08426', 'BAJARLA, JEROME CLARK PASTEDIO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:40', '2025-10-18 08:07:40'),
('02-2223-08487', 'IROC, NATHANIEL BUTANAS', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-2223-08542', 'BARBOSA, JAY-ANN ESCUADRO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:40', '2025-10-18 08:07:40'),
('02-2223-08555', 'PEROCHO, TYRAELYO LAYA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2223-08580', 'VERSOZA, IVAN KY LACHICA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2223-08696', 'GUITA, DEAVONE KARL GAYOL', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-2223-08727', 'LACHECA, BEA YSABEL MACALUA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-2223-08732', 'JABULAN, MAE NUÑEZ', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-2223-08756', 'PANELO, PIOLO SCOTT RIVERA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2223-08766', 'SALAS, CRIS XANDER OMOL', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2223-08809', 'CABIGQUEZ, XYREX GEM SUDARIO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:40', '2025-10-18 08:07:40'),
('02-2223-08810', 'ELIPIO, RUEL ARTANGO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2223-08840', 'MACARIO, MEL ANGELO SABIDO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2223-08904', 'IGNALIG, KITTIM TANHAGA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-2223-08912', 'BALIBAGON, MARY SOPHIA RANA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:40', '2025-10-18 08:07:40'),
('02-2223-09014', 'SALUDES, JOSHUA KARL', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2223-09046', 'SACAY, GRIZON RUSSELL BANLAS', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2223-09066', 'LIGSANAN, CHRISTIAN MARK PAIRAT', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2223-09075', 'MILLADO, JOSHUA CABALLES', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2223-09158', 'LABAJAN, JAZDY GALES', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-2223-09189', 'MALOLES, MATH MINISTERIO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2223-09331', 'AMORIN, ELMER JR. MABAYLAN', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:39', '2025-10-18 08:07:39'),
('02-2223-09407', 'SAMSON, DANICA GALLEGO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2223-09412', 'PACULBA, LIAM JAIRO DURANGO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2223-09420', 'CUBANG, KIRK FRANCO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2223-09746', 'SORONGON, JURIS CHIN', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2223-09747', 'DAGUNOT, JEROME FRANZ VILLAFLOR', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2223-09883', 'CASIR, BENHASSAN AYAON', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2223-09959', 'ARRIOLA, MARY GRACE PUBLICO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:39', '2025-10-18 08:07:39'),
('02-2223-09988', 'LAGO, ANDREW JAMES SULA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-2223-10032', 'INDA, CIARA BREONA MARETHZ GUILLERMO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-2223-10129', 'CULANCULAN, LOREEN ANGEL', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2223-10456', 'BALABA, ALEXANDER JULIAN', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:40', '2025-10-18 08:07:40'),
('02-2324-000076', 'UCAT, SOPHIA ANNE', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2324-00063', 'MADRIDANO, GABRIEL PAOLO MANGUIAT', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2324-00085', 'RATUNIL, JUSTINE PAGARA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2324-00086', 'BONGOLTO, KARYL JOY', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:40', '2025-10-18 08:07:40'),
('02-2324-00090', 'DAGOHOY, KHEYSHA FATTE EARL', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2324-00092', 'ABOC, CRISBELL RIC VISTO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:39', '2025-10-18 08:07:39'),
('02-2324-00111', 'ROSALES, JESSA GONZAGA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2324-00173', 'GENON, TRIXY CANILLO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-2324-00228', 'PALMA, RAULLYN JOY DACLAN', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2324-00305', 'ACAPULCO, JARED YORONG', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:39', '2025-10-18 08:07:39'),
('02-2324-00487', 'BALACUIT, LORENZ CLOUD GUNAYAN', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:40', '2025-10-18 08:07:40'),
('02-2324-00499', 'ANCOG, DOMINGO ESTRADA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:39', '2025-10-18 08:07:39'),
('02-2324-00502', 'NACAYA, MICHAEL IGTOS', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2324-00525', 'DAYA, SHERYLL AMOG', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2324-00558', 'PAUSAL, JANSHIEN CAHOY', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2324-00707', 'MAXILOM, KIRK YAP', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2324-00766', 'ASNE, K C JOY VICENTE', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:39', '2025-10-18 08:07:39'),
('02-2324-00890', 'BANTAYAO, CHRISTIAN BELVESTRE', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:40', '2025-10-18 08:07:40'),
('02-2324-00918', 'MULIT, JELLIANNE MARIZ LANGAM', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2324-00964', 'SABANAL, MARIA ALONA A.', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2324-01051', 'TOLEDO, JUSTINE JOSHUA BUHAY', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2324-01129', 'RAGASI, BRIAN D.', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2324-01132', 'MEDINA, ANGEL VI A', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2324-01283', 'ONG, NIELBEN JAN COLINARES', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2324-01365', 'SEBIAL, LAURENCE REI DIMATANGAL', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2324-01368', 'ARIMAS III, MELCHOR SAYSON', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:39', '2025-10-18 08:07:39'),
('02-2324-01381', 'FABRIA, TRISTAN REGIE BARCENAS', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2324-01519', 'BUHAY, JESSE LOU NA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:40', '2025-10-18 08:07:40'),
('02-2324-01548', 'DINAPO, VINFRANZ TAN', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2324-01660', 'SALVO, ARGIEDAN BARBIETO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2324-01669', 'PERINO, VAN KYZER RANAY', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2324-01675', 'DELFIN, JOHN ANDREW CABARING', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2324-01719', 'GAGNAN, KIT PATRICK CANE', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-2324-01722', 'SINCO, BENJIE LAGROSAS', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2324-01739', 'GO, JAMES GABRIEL SUMAYLO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-2324-01852', 'CALUNSAG, MICHAELLA JANE HENOBLA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:40', '2025-10-18 08:07:40'),
('02-2324-01857', 'TABASAN, GLEN GIO CACULBA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2324-01871', 'GEVERO, JAN JELO ZABALLERO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-2324-01978', 'BACALSO, JONEL AMAMAG-ID', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:39', '2025-10-18 08:07:39'),
('02-2324-02046', 'SALAYSAY, JASMIN LAHAYAN', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2324-02049', 'BADANGO, KIM NIÑO AMORA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:39', '2025-10-18 08:07:39'),
('02-2324-02102', 'PACLAR, KENNETH QUIOYO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2324-02166', 'CABALLERO, JUSTINE LEE TUBOG', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:40', '2025-10-18 08:07:40'),
('02-2324-02175', 'UCAT, MERRY JOY EDROLIN', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2324-02220', 'MAGHINAY, DEIMY MUNCADA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2324-02322', 'SAGUN, MARIA MIKHAELA VALCORZA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2324-02324', 'TABOCLAON, LEONIL', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2324-02332', 'EUGENIO, NOEL AMBER CASTOR', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2324-02377', 'AVENIDO, EARL LOUISE OBNIMAGA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:39', '2025-10-18 08:07:39'),
('02-2324-02414', 'FABRIA, SHANN JERIC SABAL', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2324-02553', 'EJOS, JUSTINE IVAN C', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2324-02554', 'ROMAREZ, JUNH CARLO BORAGAY', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2324-02775', 'TURTOSA, GRACYMEI', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2324-02805', 'LECHADORES, EARL NARSLECH TUTAS', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2324-02853', 'BATALLA, HERALD VILLASTIQUE', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:40', '2025-10-18 08:07:40'),
('02-2324-02875', 'MARI, RALPH JAMES CUENCA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2324-02966', 'PAGALING, SANDARA JANE MABALE', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2324-02974', 'MAGSALAY, SYDNEY BONIAO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2324-03099', 'JAMISOLA, KENNETH DAANG', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-2324-03253', 'SANCHEZ, LEAHN MAY MANTOC', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2324-03662', 'DOROIN, JAPHET CABRERA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2324-03800', 'CABAÑEZ, KEVIN DAHANG', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:40', '2025-10-18 08:07:40'),
('02-2324-03869', 'PORTRIAS, JOSH MARVIN PADABOC', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2324-03899', 'MAGNO, JANRIDGE ARNEJO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2324-03919', 'MARAMBA, JISELLE ALINA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2324-03960', 'MIRAL, GODWIN SABANAL', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2324-03968', 'PAO, JEOGER KIM ODCHIGUE', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2324-04090', 'PABELLAN, DANIEL JAY BULLECER', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2324-04097', 'FLORES, QHKO VIESCA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2324-04126', 'AÑORA, RHEO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:39', '2025-10-18 08:07:39'),
('02-2324-04153', 'LAGNASON, KENT CHANLEE GALECIA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-2324-04289', 'TECSON, JAMES HOLDEN', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2324-04457', 'DALIT, REYMARK FETILUNA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2324-04577', 'TANGGOTE, MUHAMMAD REHAN LABRADOR', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2324-04650', 'GULIGADO, JOHN CARLO MAGALLANES', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-2324-04694', 'ENGLATERA, AERON JEZREAL OPLE', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2324-04895', 'LUMBAB, DHIMCER BARIGA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2324-05084', 'PIONAN, CHERRY JANE ARCAYENA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2324-05196', 'ENGELBRECHT, ANGELICA DAYUPAY', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2324-05428', 'VENTIC, JUSTINE MAE ALICAWAY', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2324-05468', 'CORCUERA, ALTER LLOYD MOGPO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2324-05502', 'ARADILLA, AIREL MARIE SATULOMBON', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:39', '2025-10-18 08:07:39'),
('02-2324-05544', 'MALBAROSA, ANDRE PAZA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2324-05653', 'GAAN, HONEY JEWEL', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-2324-05716', 'ESCOBILLA, JOHN CARL APARECE', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2324-05750', 'LUZON, CHARLIE JAMES CARALDE', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2324-05991', 'NOVECIO, GIL JOHN REBUYAS', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2324-06083', 'LUMANSOC, EARL GIAN JAYME', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2324-06121', 'BELONO-AC, SHAUN MICHAEL TERCEñO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:40', '2025-10-18 08:07:40'),
('02-2324-06345', 'ROMITARES, IRENE MAE MACAMAY', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2324-06359', 'RAOTRAOT, ASHLEY VALCORZA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2324-06543', 'MIFRANO, TRIXIE CAGAMPANG', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2324-06545', 'BANNISTER, JOEFREY PAKIS', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:40', '2025-10-18 08:07:40'),
('02-2324-06642', 'GREGORIO, SOFIA GWYN SANTAN', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-2324-06743', 'SIMENE, AL ANGELO IGTOS', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2324-06796', 'GACITA, VEN KYLE ANGANA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-2324-06829', 'INSON, JOSEPH JAMES SATO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-2324-06930', 'BALACUIT, APRIL SHRECK ANTIPUESTO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:40', '2025-10-18 08:07:40'),
('02-2324-06942', 'PACALA, SHIELA MAE BELONIO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2324-06943', 'BERSANO, RIZIEL TACOGDOY', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:40', '2025-10-18 08:07:40'),
('02-2324-06961', 'JARANILLA, JOHANN LAWRENCE PACANA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-2324-07052', 'ZARSOSA, JOHN LESTER PANILAG', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:46', '2025-10-18 08:07:46'),
('02-2324-07054', 'VALLE, BRYAN MITCH TIMBAL', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2324-07079', 'TAMAYO, LORE LINDELL BECOY', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2324-07097', 'LINTAWAHAN, VINCENT ANGELO BRINGGUILLA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2324-07168', 'LABADAN, MIKO GULAY', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-2324-07262', 'MAGLINAO, JHON VINCENT BANATE', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2324-07277', 'RESMEROS, HAZEL LORRAINE CAGAMPANG', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2324-07317', 'INESIN, JOHN MICHAEL ROA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-2324-07318', 'SALILING, JOEANNA THERESE SALESA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2324-07324', 'PADLA III, EDWIN ALBASETE', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2324-07333', 'JUMAWID, BABY JEAN GALENDEZ', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-2324-07337', 'EDROLIN, APPLE JANE MEMORACION', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2324-07395', 'BALORO, JOHN PHILIP RAZO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:40', '2025-10-18 08:07:40'),
('02-2324-07413', 'TADOY, CYRUS VITERBO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2324-07462', 'BONIEL, CHRISTIAN VILLARUZ', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:40', '2025-10-18 08:07:40'),
('02-2324-07483', 'CORTAL, ERL JANE SALUDES', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2324-07569', 'EMBRALINAG, ALVIN JR. HALOOT', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2324-07593', 'MAAÑO, RALPH JAY PACLAR', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2324-07597', 'CONTADO, MARICHU', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2324-07753', 'JANGAO, WARREN JOHN ABROGAR', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-2324-08025', 'CADUYAC, LAURICE MAYE CLOMA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:40', '2025-10-18 08:07:40'),
('02-2324-08200', 'GABUTAN, KERBY CADELIñA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-2324-08223', 'OBEÑITA, RONA LASTIMOSA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2324-08237', 'ARDIENTE, BERN JOSES QUIR', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:39', '2025-10-18 08:07:39'),
('02-2324-08258', 'NAIVE, RAICIEL P.', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2324-08269', 'BAGUIO, MARVEN JAMES MENDOZA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:40', '2025-10-18 08:07:40'),
('02-2324-08398', 'IDAGO, ASHLEY CATALONIA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-2324-08408', 'LIM, TRISHA MARIE I.', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2324-08438', 'TAGALOG, JUSTIN RAFAEL CABUG', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2324-08543', 'DACULA, JANA VINZY ESCALA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2324-08740', 'GUINTAO, CHRISTIAN PAOLO AGUILAR', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-2324-08746', 'ABDULWAHAB, MOHAMMADJARER ABDULGAFOR', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:39', '2025-10-18 08:07:39'),
('02-2324-08952', 'ESPINOSA, PAUL CHRISTIAN POLO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2324-08980', 'LABADAN, LUWELL RYAN ACLAN', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-2324-09096', 'TAN, CLINT JOHN SANCHEZ', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2324-09165', 'NABO, KAREL J.', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2324-09270', 'ROXAS, CAMILLE ELLO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2324-09285', 'DELGADO, KAYE GALARRITA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2324-09302', 'VELASCO, GODBOTZ IVON JAMES BONSUCAN', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2324-09338', 'AGCOPRA, MARJORIE LLAGAS', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:39', '2025-10-18 08:07:39'),
('02-2324-09416', 'CAARE, MARIANE MILDRED CABAÑEZ', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:40', '2025-10-18 08:07:40'),
('02-2324-09461', 'MERIDA, KRISTINA CASS G.', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2324-09582', 'SEMAÑA, BERNADETH PETERE', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2324-09616', 'CASINILLO, JOHN DAVID NAMBATAC', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2324-09729', 'CABASAG, JECEL R.', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:40', '2025-10-18 08:07:40'),
('02-2324-09733', 'GAROL, MIKAELA V.', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-2324-09734', 'PANONG, SANDY JEAN AMPORINGUES', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2324-09735', 'MANCIA, MARK ANTHONY SANTAAN', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2324-09736', 'PARAJES, JESSIE JAMES CASTINO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2324-09824', 'LOPEZ, KENNETH REYES', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2324-09835', 'NAVARRO, TRISIA JOYCE LAZADA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2324-09914', 'IBAOC, SILWYN BANAC', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-2324-10046', 'DELGADO, LADY ANN SALAYON', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2324-10090', 'MIRAFLOR, GRAZELLE ANNE OBASA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2324-10117', 'PACILAN, JOEVENAL JR. ROXAS', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2324-10160', 'GAAMIL, JUSTINE LLOBIA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-2324-10210', 'PASIA, JAYCHELLE CANOMON', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2324-10233', 'ALABA, FRANCIS OLIVER GALONO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:39', '2025-10-18 08:07:39'),
('02-2324-10399', 'PAJE, CHRISTINE MAE FLORES', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2324-10429', 'DAMO, RONALD CABALLERO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2324-10478', 'NANALE, SHAHANIE YAMUT', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2324-10544', 'MANZANO, JOHN ANGELO CALMA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2324-10564', 'RODRIGO, KENNETH NG', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2324-10632', 'PLAZA, CLINT DENZEL VILLANUEVA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2324-10688', 'SAMILLANO, CYRA CUSTADO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2324-10692', 'VILLARIAS, CHRISTIAN KING MALINAO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2324-10747', 'LOSAÑES, RUZZYLL JANE BAELLO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2324-10792', 'BALANLAY, REYMOND ABELLA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:40', '2025-10-18 08:07:40'),
('02-2324-10812', 'MIGRASO, JADE Q.', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2324-10868', 'KHALID, JAMIL RECAMARA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-2324-10871', 'ORINA, RHICK MARGUO FLORES', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2324-10982', 'NAMOC, RYLE JOHN', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2324-11013', 'TUTANES, AMIEL VAN RUSSEL G.', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2324-11015', 'ACIDO, MIGUEL LORENZ ABALDE', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:39', '2025-10-18 08:07:39'),
('02-2324-11016', 'CABILUNA, MIKE ROMIL LENTIJA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:40', '2025-10-18 08:07:40'),
('02-2324-11023', 'NAMOC, ROBERTH', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2324-11053', 'SIWALA, HAROLD TACULOD', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2324-11066', 'BALDADO, JHOMARIEL VENICE VELARDE', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:40', '2025-10-18 08:07:40'),
('02-2324-11110', 'BU-ONG, MARK REYNAN SONTILLANO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:40', '2025-10-18 08:07:40'),
('02-2324-11282', 'TAGAPULOT, RYAN CHRISTIAN O', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2324-11442', 'PALOMERAS, ANDRE Y.', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2324-11526', 'QUINTO, VINCENT NIEL DACLAG', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2324-11618', 'BABA, REYNANTE JR. ALUNAN', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:39', '2025-10-18 08:07:39'),
('02-2324-11705', 'ROSELIM, ERICSON LAHILAN', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2324-11779', 'MALINAO, ANDRE CLEMENT LOUIE STA. MARIA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43');
INSERT INTO `students` (`student_id`, `name`, `college`, `course`, `created_at`, `updated_at`) VALUES
('02-2324-11884', 'RAMOS, RORRY AMPUYAS', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2324-12056', 'BARICUATRO, JOHN HARVEY PATALINGHUG', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:40', '2025-10-18 08:07:40'),
('02-2324-12145', 'JAMACA, KEN MAVERICK MAPUTE', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-2324-12148', 'GENARIS, RICHARD B.', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-2324-12231', 'ROSAL, BJORN LATRELL', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2324-12253', 'ARGATE, KENT JOSHUA BASALAN', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:39', '2025-10-18 08:07:39'),
('02-2324-12330', 'CARVAJAL, JOSEPH LLOREN', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:40', '2025-10-18 08:07:40'),
('02-2324-12373', 'LAURENTE, LENARD JAMES TINGAS', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2324-12408', 'DELIGERO, JODISA MAE CAHIMAT', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2324-12412', 'RUGAY, REGINE SABANDAL', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2324-12448', 'BACASMOT, BRYEN BERN SABUERO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:39', '2025-10-18 08:07:39'),
('02-2324-12910', 'AMPER, EDCEL JOHN PARNADA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:39', '2025-10-18 08:07:39'),
('02-2324-12980', 'DELIG, JOHN CARLO NOBO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2324-13165', 'MACARAMBON, JONAIDA JANNAH DIMAKUTA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2324-13299', 'GONZALES, IVAN LOUIZ MAGLUPAY', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-2324-13328', 'CABAHUG, AMIE DAMAS', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:40', '2025-10-18 08:07:40'),
('02-2324-13335', 'ODARVE, VICTOR EDULSA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2324-13373', 'MONTERDE, CHUDNEY RON DAMPOG', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2324-13443', 'VILLARTA, ALEXANDRA TONGAO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2324-13450', 'EMBORGO, NEIL JOEBERT NARVASA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2324-13524', 'BLANCAFLOR, MAIRE GREECO CAYETANO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:40', '2025-10-18 08:07:40'),
('02-2324-13575', 'PADERAN, DON REY GILIG', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2324-13583', 'GAMUTAN, IRISHDWIN POTOT', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-2324-13611', 'PORTUGAL, SHENNIELYN AGUILAR', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2324-13628', 'RUIZ, FRANCISCO REY ALUNAN', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2324-13629', 'ARADO, GERALDINE MABAYLAN', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:39', '2025-10-18 08:07:39'),
('02-2324-13768', 'MAGHANOY, DESIREE LUISE BUYOSE', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2324-13818', 'BONCALES, CHRISTIAN DAVE BALAMAD', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:40', '2025-10-18 08:07:40'),
('02-2324-13838', 'DELA PEÑA, CHRISTIAN DAVE REYES', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2324-13843', 'CUBILLAN, HANNAH MARIE DAPANAS', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2324-13857', 'PABELLAN, ROMEO MONTES', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2324-13881', 'RABANAL, EDCHEL B.', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2324-13899', 'CHIPOCO, SEAN LANDON SINADJAN', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2324-13916', 'STA.RITA, JAYLYN ROSE CUARESMA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2324-13956', 'ESTRADA, RECHELLE JANE -', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2324-13980', 'PABE, MARICAR JIMENEZ', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2324-14046', 'LUMAYOG, KENJI SADERA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2324-14066', 'DEALINO, MIGUEL BALIOS', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2324-14404', 'SAGAYON JR., AHMED RANIEGO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2324-14411', 'BADA, JEZRYL MAE', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:39', '2025-10-18 08:07:39'),
('02-2324-14551', 'PAGKALINAWAN, CHRISTINE SHAYNE LAPLAP', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2324-14641', 'REYES, SHIN CASIDI', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2425-000008', 'ORLANES, KEEZELL RENCE OSIP', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2425-000033', 'PACILAN, CHARITY ROXAS', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2425-000053', 'ALASTRA, JAY DAHILAN', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:39', '2025-10-18 08:07:39'),
('02-2425-000107', 'DATAHAN, EARL GABRIEL DACLES', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2425-000128', 'DACOROON, PAUL CLARENCE BETONIO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2425-00019', 'Destura, Crizela Marie', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2425-000219', 'JAPSON, RAINIER NAMOCATCAT', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-2425-000300', 'QUINTO, ARGIE TAYAOTAO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2425-000361', 'LARIZA, KENT JHON CALABIO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-2425-000374', 'HAYO, DJ SIM', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-2425-000380', 'CLOTARIO, LATRILL MONDEJO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2425-000415', 'LEGASPI, NOELLY AMOR', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2425-000503', 'MAGALLANES, ARJEAN DIAZ', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2425-000511', 'SALAN, ROBERTO GULLEBAN', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2425-000533', 'LLAGAS, KENT CHAVEZ', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2425-000549', 'NAMOCO, SYBELLE MAE LUNTAYAO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2425-000628', 'PIONAN, NICA ALARILLA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2425-000656', 'SIBULON, JIAN TYRONE BEROU', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2425-000674', 'ORATE, JEZIEL KATE BARITOS', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2425-000683', 'SUMAGANG, JERRY MANGUBAT', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2425-000695', 'BACLAYON, ALIEZA RADOC', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:39', '2025-10-18 08:07:39'),
('02-2425-000761', 'LUMINDA, PHILIP LIBOGAN', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2425-000763', 'TAPIC, FITZ ALLENBERT IRIZARI', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2425-000774', 'INDOC, JHON PAUL SULINAY', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-2425-000798', 'YEE, KURT ANDREY A.', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:46', '2025-10-18 08:07:46'),
('02-2425-000842', 'DAULONG, JOSHUA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2425-000903', 'MOLINA, MARK LHESTER GALAGAR', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2425-000954', 'PICATO, ALEXA NICOLE CASAS', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2425-000982', 'DISAMBURN, ABDUL AZIS ANGNI', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2425-001196', 'SIAROT, NIÑO MAGLANGIT', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2425-001198', 'VALE, SHANEL YANEZ', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2425-001209', 'QUINLAT, ZAIRA MARRIAH KATE TAGAYLO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2425-001210', 'QUINLAT, AIRA MARRIAH FATE TAGAYLO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2425-001300', 'MONTILLERO, FRANCIS ADRIAN QUILISADIO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2425-001317', 'SOSOSCO, RINZ CAYANPAT', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2425-001342', 'LUPEBA, CHRISDANIEL ISAHN ROMANILLIOS', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2425-001355', 'VILLASTIQUE, MARY ROSE UBOD', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2425-001408', 'VALMORIA, CHRISTINE SALVALEON', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2425-001423', 'CURIBA, WALTER PEREZ', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2425-001458', 'DELOS SANTOS, RONA JANE BARCELONA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2425-001486', 'ARAÑA, KRESTINE MEA LOGO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:39', '2025-10-18 08:07:39'),
('02-2425-001488', 'PETO, JOHN MARK PUDOT', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2425-001511', 'JALOP, JIMSON CASTILLO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-2425-001556', 'CAPE, APRIL MAE OPENDO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:40', '2025-10-18 08:07:40'),
('02-2425-001557', 'LLARENAS, JEFFERSON VIERNES', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2425-001568', 'VALENCIA, CHRIS JUSTINE GANIO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2425-001602', 'REDONDO, JENNIE LOU LIGUTAN', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2425-001605', 'TALLO, XIAN NICOL BADIANG', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2425-001632', 'CLAUDEL, JOHN PAUL MACABENLAR', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2425-001635', 'OGOC, JUSTIN RAIN TELACAS', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2425-001670', 'LORONO, RHEALIZA JALAGAT', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2425-001764', 'PALARCA, MARSIMLE IBRAHIM', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2425-001786', 'LERION, LOURENCE JADE CATIIL', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2425-001798', 'CASAS, MARK ANTHONY AMAMALIN', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2425-001830', 'CAILO, ALEXANDRA FAITH MAQUE', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:40', '2025-10-18 08:07:40'),
('02-2425-001910', 'SULTAN, LIAN SUZAINE', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2425-001912', 'BACQUIAL, PHIL MARK EMPERADO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:39', '2025-10-18 08:07:39'),
('02-2425-001979', 'MABALACAD, HERBERT EMBORES', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2425-002012', 'MADERAL, JOHN ERNEST LUCAGBO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2425-002036', 'VILLATUNA, PAUL VINCENT ACERO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2425-002037', 'CAÑALES, JHAP LEIVINCE VILLATONA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:40', '2025-10-18 08:07:40'),
('02-2425-002049', 'MESA, JELYA MAE PAILANZA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2425-002070', 'POLO, JHUSTIN JAMES ENTERINA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2425-002243', 'MELLEJOR, ZIN ESGANA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2425-002274', 'AMAR, LYSTER BRYCE BOFETIADO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:39', '2025-10-18 08:07:39'),
('02-2425-002324', 'LABOR, ANDREAH GOLEZ', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-2425-002588', 'COLLONG, CEIAN CZAR SACALA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2425-002596', 'DALUAN, KEM YENAH MARQUITA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2425-002620', 'GABE, JOHN MICHAEL ELILIOT', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-2425-002835', 'PASCUA, IVAN MIGUEL J', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2425-002872', 'CANDELARIO, CHRISTIAN FRITZDON OMANDAC', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:40', '2025-10-18 08:07:40'),
('02-2425-003037', 'GABUYA, JOHN ARNIEL PANILAG', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-2425-003117', 'PAREDES, CARL JUNMAR P.', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2425-003153', 'ODIONGAN, MARK THRIESTAN DAUG', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2425-003221', 'VITO, JOHN LLOYD BARBER', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2425-003233', 'MAGLANGIT, JOEVANN RAPIRAP', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2425-003334', 'DALAPO, TRICIA ALTHA ACOSTA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2425-003504', 'MING, JOSE GABRIEL DAGARAGA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2425-003508', 'MASUCOL, MEKHYLA JOSAINE', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2425-003527', 'BEJA, GERONIMO ESCAÑAN', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:40', '2025-10-18 08:07:40'),
('02-2425-003556', 'BARSARSA, JOHN QUERBIE LULO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:40', '2025-10-18 08:07:40'),
('02-2425-003608', 'NAVAROSA, KRISTIAN JEKKO LIM', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2425-003804', 'DELIG, CHARLES DAVE DELGADO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2425-003814', 'SUN, ABIGAIL COMPAS', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2425-003859', 'SATERA, CARL DENZYL RONQUILLO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2425-003867', 'TARUGO, ANGELITO CHEE', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2425-003905', 'NOEL, JHAMER JAY', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2425-003930', 'ILIGAN, CARLWIN JOHN TIGUE', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-2425-003955', 'ANSING, KHYLA JANE CANTILLER', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:39', '2025-10-18 08:07:39'),
('02-2425-004103', 'YABA, GARBY ESCULTOR', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:46', '2025-10-18 08:07:46'),
('02-2425-004119', 'ANGGA, RINIL JAN CARBONERO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:39', '2025-10-18 08:07:39'),
('02-2425-004165', 'BERBESADA, FRANCIS QUITORIANO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:40', '2025-10-18 08:07:40'),
('02-2425-004208', 'ACERA, CHRISTIAN CAHOY', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:39', '2025-10-18 08:07:39'),
('02-2425-004291', 'VILLANUEVA, FRITZ EARL MAGALLANES', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2425-004292', 'JANGAO, RAMINDER NANAK', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-2425-004371', 'FAGUTAO, LEXICYN CARDEÑO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2425-004467', 'PASCUAL, JESSIE PALILEO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2425-004476', 'VILLANO, ALEXA CARMEN NARIO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2425-004508', 'SEMINO, DAVE ANDRIAN', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2425-004522', 'BALANDRA, REMARC BAHIAN', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:40', '2025-10-18 08:07:40'),
('02-2425-004778', 'BARGAMENTO, CHRISTINE TAPIC', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:40', '2025-10-18 08:07:40'),
('02-2425-004781', 'TOLILIS, JINKY NACALABAN', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2425-004800', 'RENDON, MICHAEL CONROY', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2425-004807', 'FEBRES, JOHN REYNALD BARRIOS', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2425-004878', 'GUIMBA, ROLLY INADAP', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-2425-004928', 'PEDROSO, ANGELA TAGSIP', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2425-004984', 'HASSIM, HAYANISA SALOMABAO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-2425-004987', 'MARIMON, GLAIZA JADE MANOSA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2425-005042', 'GERONIMO, JAMAICA LABASBAS', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-2425-005055', 'SALINAS, SHANDY JAMORA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2425-005065', 'CABANGAL, AXL SHAWN CARUMBA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:40', '2025-10-18 08:07:40'),
('02-2425-005137', 'DIBDIB, KHAYE ASHLEE ANTOLIN', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2425-005278', 'LAPIZ, PRINCESS JAMODIONG', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-2425-005389', 'MACABENLAR, ZHENMAR N.', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2425-005457', 'GALITO, CARL MANUEL ELLONOR', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-2425-005496', 'SORIA, DANIEL SINODLAY', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2425-005522', 'SABUERO, ANTONETTE KYLE', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2425-005572', 'CASONA, LUI JAY FAMAT', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2425-005638', 'SALAS, MARK JOVEL PAJE', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2425-005831', 'BANNISTER, JHEPHERSON ESTO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:40', '2025-10-18 08:07:40'),
('02-2425-005848', 'CAHUAN, BRIX ALFRED BONITA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:40', '2025-10-18 08:07:40'),
('02-2425-005854', 'CAMBA, JHON CARLO SABUERO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:40', '2025-10-18 08:07:40'),
('02-2425-005914', 'TANHAY, BRYLE ADORA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2425-005956', 'GABORNE, RAMON JOSH ANDRI DACALOS', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-2425-006027', 'LUMAHANG, DOCTORA ALEXA MERRY SAGALA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2425-006073', 'BRONOLA, ISIAH LEE CUTAYAN', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:40', '2025-10-18 08:07:40'),
('02-2425-006102', 'DELITO, JENNEATH CABANDAY', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2425-006155', 'WABE, JOSEPHREY OLAMIT', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:46', '2025-10-18 08:07:46'),
('02-2425-006204', 'MAG-USARA, GABBY GALANAY', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2425-006298', 'VALLEJA, MARCO JAY TAHUD', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2425-006371', 'GENON, PHILIPPE JONATHAN ALLO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-2425-006491', 'TARIPE, FRITZIE FAITH BUSLATAN', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2425-006557', 'PEDRIDO, LEMUEL JOHN CAMPANA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2425-006674', 'GARCIA, JOREL LASTIMOSO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-2425-006749', 'ANDO, JEWEL BATAL', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:39', '2025-10-18 08:07:39'),
('02-2425-006801', 'GALO, GILBERT PATIGDAS', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-2425-006928', 'HERMOSO, VINCE REY GAAMIL', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-2425-006933', 'SABELLITA, KATHLEEN HAZEL MAGLANGIT', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2425-007059', 'BAEL, KYLE FERRER', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:39', '2025-10-18 08:07:39'),
('02-2425-007074', 'ABATON, JERALD NONE', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:39', '2025-10-18 08:07:39'),
('02-2425-007119', 'CAILING, ALLEN KIRK ALAJID', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:40', '2025-10-18 08:07:40'),
('02-2425-007125', 'QUEZON, ROCHEN MAE GALARCE', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2425-007132', 'ALIWANAG, ALFMAR TUASTOMBAN', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:39', '2025-10-18 08:07:39'),
('02-2425-007141', 'GUMBAY, JEROME LABAN', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-2425-007157', 'PADILLA, GODFREY UBA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2425-007169', 'MATILDO, CHARLES OLIVER PRADO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2425-007182', 'VELASCO, GEROME LOMONGO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2425-007190', 'BAJO, KRISHA CHESKA REBARBOSA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:40', '2025-10-18 08:07:40'),
('02-2425-007271', 'BANSING, RASTEL CYRUS ROSAL', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:40', '2025-10-18 08:07:40'),
('02-2425-007442', 'INTUD, RONALD RYAN SABAS', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-2425-007516', 'BALASABAS, HARVEY ANGOT', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:40', '2025-10-18 08:07:40'),
('02-2425-007620', 'GO, ZHACK TOCMO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-2425-007621', 'VILLADORES, MARIANE SISA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2425-007647', 'TABOBO, HANNAH BONDAD', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2425-007743', 'MANANSALA, REXIMUS AURELIUS LOPEZ', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2425-007805', 'GONZAGA, JOSHUANOEL GANINAY', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-2425-007951', 'ASOY, SAMUEL NONE', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:39', '2025-10-18 08:07:39'),
('02-2425-008003', 'LAO, JHON PAUL EDNALIG', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-2425-008102', 'MANALO, JAMES ALLEN BAHIAN', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2425-008103', 'DAGASUHAN, CLARD JUDE AUGUSTINE', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2425-008234', 'ABDON, RENIER REYES', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:39', '2025-10-18 08:07:39'),
('02-2425-008291', 'BERNARDO, JOHN MARK PASAUL', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:40', '2025-10-18 08:07:40'),
('02-2425-008366', 'GALAGAR, BRENT C.J AGCOPRA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-2425-008413', 'AMAD, MARBEN OBEJERO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:39', '2025-10-18 08:07:39'),
('02-2425-008548', 'ORTIZ, LOVE JUN JACOSALEM', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2425-008580', 'BELAYO, CLARK TOLENTINO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:40', '2025-10-18 08:07:40'),
('02-2425-008581', 'GAYOMALI, ROVIN ROSALES', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-2425-008588', 'BALATERO, JACK DANIEL BONGO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:40', '2025-10-18 08:07:40'),
('02-2425-008774', 'ABRIOL, ARIES BRYLLE CASULUCAN', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:39', '2025-10-18 08:07:39'),
('02-2425-008796', 'DAOHOG, JASMINE MARIELLE FUENTES', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2425-008811', 'MORADA, JUAN CARLOS DALMAN', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2425-008812', 'ESPINOSA, REYNOLD FRANCIS BANAAG', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2425-008820', 'JAPLAG, JASON JAY DUMAY', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-2425-008868', 'BAGARES, ANDREI ALBERT PATRIANA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:40', '2025-10-18 08:07:40'),
('02-2425-008883', 'GALOSAN, CEZAR ALFONSO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-2425-008896', 'PAIRAT, CHRISZEL CASTILLO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2425-008908', 'NAGALES, JOHN REY LEOPAOPAO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2425-008979', 'SARENANA, XANDER JOHN', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2425-009149', 'COSTELO, SHANIAH NEGROS', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2425-009210', 'ALFANTE, GIFFORD CLINT ASOTIGUE', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:39', '2025-10-18 08:07:39'),
('02-2425-009300', 'BESIN, EARL JAMES AKUT', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:40', '2025-10-18 08:07:40'),
('02-2425-009302', 'GULANE, AXIL ROZE BENOLIRAO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-2425-009472', 'DAMPAL, EARL KRISTIAN', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2425-009566', 'ORCULLO, CHARLZ LEVI PASAHINGUE', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2425-009723', 'CADERAO, ELUHYM JAY', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:40', '2025-10-18 08:07:40'),
('02-2425-009850', 'SACULINGAN, JERICHO PADERANGA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2425-009855', 'ANTID, NHICK ALFRED DACAYO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:39', '2025-10-18 08:07:39'),
('02-2425-009912', 'PAILAGO, JECEL BARRETE', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2425-010017', 'EPIS, ROBERT MANSALAYNON', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2425-010076', 'DALUPA, KURT ROB TAMULA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2425-010110', 'RANCES, IVAN LACONDE', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2425-010117', 'ECHAVEZ, CHARLES TADLE', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2425-010126', 'VIADOR, CHARLIE BARRERO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2425-010152', 'FERNANDEZ, KHARYLL KATE ALCANTARA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2425-010160', 'MAHUNYAG, KENNETH LOCSIN', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2425-010167', 'LLEREZA, JOSHUA TABALBA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2425-010238', 'DELFIN, CLINTON OMEGA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2425-010310', 'SABILLO, JOSHUA PABAYO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2425-010338', 'CARPENTERO, CHRISTIAN HINGPIT', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:40', '2025-10-18 08:07:40'),
('02-2425-010347', 'LAGO, JOSHUA CENA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-2425-010351', 'SUGANOB, KARIZZA DALE BRIGOLI', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2425-010356', 'EDLANG, FRENZ JERALD BALLERAS', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2425-010456', 'IGNACIO, HEART NACAYTUNA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-2425-010586', 'VILLALOBOS, MARY ZCALCY CABASAG', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2425-010593', 'TATOY, ALEXANDER ARAMBALA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2425-010610', 'ALMEDA, JOHNXIN MICOLLE ROLUNA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:39', '2025-10-18 08:07:39'),
('02-2425-010615', 'LEDESMA, KERT IAN OLANDIO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2425-010663', 'MACEDA, JERYL VERGARA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2425-010666', 'CADUGO-AN, ANGEL SHANE TANGUAMOS', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:40', '2025-10-18 08:07:40'),
('02-2425-010667', 'VICTORIANO, JOHN MARK SALVA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2425-010673', 'ABEJUELA, NEWEL BALUCAN', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:39', '2025-10-18 08:07:39'),
('02-2425-010740', 'BULALA, MICA PETOGO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:40', '2025-10-18 08:07:40'),
('02-2425-010743', 'BALINGIT, YVES DWIGHT DELARMENTE', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:40', '2025-10-18 08:07:40'),
('02-2425-010754', 'ABAO, ALLYSSA BACORRO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:39', '2025-10-18 08:07:39'),
('02-2425-010791', 'DAVID, ANGELO POTOT', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2425-010823', 'GABUTAN, DEXTER JOHN MANILI', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-2425-010949', 'PIMENTEL, RHOVALENTINE', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2425-010950', 'DAIGDIGAN, CRIX TABAMO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2425-010962', 'BUHAYANG, MATHEW WYETH CABALLES', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:40', '2025-10-18 08:07:40'),
('02-2425-010965', 'CAGUMBAY, IVANN', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:40', '2025-10-18 08:07:40'),
('02-2425-010977', 'JAMODIONG, JOHN EDMARK BACULIO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-2425-010993', 'CADIAO, MICHELLE ANN ABELLA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:40', '2025-10-18 08:07:40');
INSERT INTO `students` (`student_id`, `name`, `college`, `course`, `created_at`, `updated_at`) VALUES
('02-2425-011059', 'DAGUPLO, MYWIN GALES', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2425-011088', 'GALORIO, PRINCE KYLE LERION', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-2425-011136', 'FANTONIAL, VINCHY HECIERA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2425-011158', 'RATUNIL, HANS JASON DAJAY', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2425-011201', 'BAS, DIANA MARIE SACOLINGGAN', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:40', '2025-10-18 08:07:40'),
('02-2425-011247', 'LLOBIA, CHRISTIAN UMASDANG', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2425-011309', 'ALOLOR, FRANCIS CLYDE FLORA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:39', '2025-10-18 08:07:39'),
('02-2425-011366', 'COMPOC, JHOEFEL RANGCASAJO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2425-011471', 'ACUT, CHRISTOPHER IAN PAJO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:39', '2025-10-18 08:07:39'),
('02-2425-011552', 'BELANDRES, CRIS JOHN TANATE', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:40', '2025-10-18 08:07:40'),
('02-2425-011650', 'QUISTADIO, JIRO VERA CRUZ', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2425-011818', 'ANG, JEILRHONE SEVILLA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:39', '2025-10-18 08:07:39'),
('02-2425-011884', 'BALINAS, BON JHOVE GICANA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:40', '2025-10-18 08:07:40'),
('02-2425-011891', 'CAÑETE, KRISSHA CASSANDRA AGUSILA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:40', '2025-10-18 08:07:40'),
('02-2425-011905', 'SHAIK, NORHANIFAH HADJI USOP', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2425-011926', 'BALANE, REY ANGECELO LLOBRERA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:40', '2025-10-18 08:07:40'),
('02-2425-011928', 'EMBORNAS, VANESSA VILLAMOR', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2425-011953', 'SORIAL, SHAQUILLE BATAL', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2425-011959', 'MOLINA, KENT JOVERSON MATA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2425-012036', 'YPARRAGUIRRE, JANNRELLE MADRID', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:46', '2025-10-18 08:07:46'),
('02-2425-012037', 'FERRARIZ, JOHN LATRELL TINGSON', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2425-012160', 'WABE, KRIZZA LEAH YVONNE MARENTES', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:46', '2025-10-18 08:07:46'),
('02-2425-012216', 'PAJELA, CHALES DAVE DAHAN', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2425-012228', 'DAGALANGIT, MOMIT ADIL', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2425-012323', 'COLITA, REYNZ JORELL BAJA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2425-012367', 'ALCORIZA, JOHN STEVEN PUGTA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:39', '2025-10-18 08:07:39'),
('02-2425-012376', 'PACUDAN, MARC NETHAN DARON', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2425-012377', 'APOSTOL, CRISTIAN DAVE ABREZ', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:39', '2025-10-18 08:07:39'),
('02-2425-012379', 'GONGOB, ELWIN HAROLD ABRAGAN', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-2425-012390', 'SALVATIERA, JUNIL MIER', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2425-012492', 'SANTARITA, ERYLE KRIS LAURENZE SATUR', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2425-012556', 'DIGABE, KASSANDRA KATE EGAGAMAO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2425-012561', 'PAMISA, FRANK ANTHONY GILA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2425-012571', 'PIIT, KARL ANTHONY DAUMAR', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2425-012632', 'BONIEL, JEAN BARCOMA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:40', '2025-10-18 08:07:40'),
('02-2425-012650', 'GALVE, PETE D', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-2425-012657', 'ESPERON, EMANUEL DAVE TORRALBA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2425-012695', 'BASTATAS, ALEXIES MAE', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:40', '2025-10-18 08:07:40'),
('02-2425-012731', 'SABUERO, JAY QUILICON', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2425-012732', 'ARISTAS, JOSEPH MENTOPA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:39', '2025-10-18 08:07:39'),
('02-2425-012749', 'MANGUBAT, ALLIZA ESPEJON', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2425-012753', 'SAROMINES, KAYCE ESTRABELA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2425-012754', 'TIMBANG, CATHERINE LAKE', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2425-012786', 'BAHIAN, KINSHEN NOB', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:40', '2025-10-18 08:07:40'),
('02-2425-012788', 'TENOBALE, MARJUN QUIETA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2425-012802', 'FUENTES, CHARLOTTE BATINO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-2425-012814', 'CASAS, MARVEN REY MAGHANOY', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2425-012848', 'SALIGUMBA, SAM CABILLO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2425-012856', 'BORGONOS, ERICH ENOT', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:40', '2025-10-18 08:07:40'),
('02-2425-012857', 'MONDELO, JOSUA VILLARMIA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2425-012868', 'BABAYSON, ROSHIEL GRACE AURIT', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:39', '2025-10-18 08:07:39'),
('02-2425-012874', 'PAIGNA, JUSIE MER AMOLO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2425-012898', 'RAMOS, STEVEN KIEFER OLAIVAR', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2425-012943', 'PICUT, JOHN ANDREI PABILLAN', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2425-012954', 'ZAGADO, VINCENT JADE AMISTOSO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:46', '2025-10-18 08:07:46'),
('02-2425-013042', 'TUTO, JHON REY TERO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2425-013054', 'OLAMIT, CHRISTIAN VICOY', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2425-013055', 'BAYAON, LESLIE ANNE', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:40', '2025-10-18 08:07:40'),
('02-2425-013086', 'MIRABUENO, JONAH SHEENA SARDIDO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2425-013138', 'MACABALE, HANNAH JEAN GALONO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2425-013159', 'SANOY, JOHN DAVE VERGARA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2425-013233', 'PARCIA, CHEMIE VILLA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2425-013241', 'LORA, EARL GIAN CHEZTER RUGAY', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2425-013252', 'PABILLORE, KRISHA FAITH VANGUARDIA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2425-013261', 'RIVERAL, BHEA MARIE ALTARIBA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2425-013330', 'JAMACA, MICHAELA IBONA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-2425-013337', 'MAGDUGO, CLIFFORD ELLEVERA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2425-013400', 'SANTUA, EARL DAN ROSALES', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2425-013403', 'AMPORINGUES, VINCENT BUONG', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:39', '2025-10-18 08:07:39'),
('02-2425-013433', 'RUBIO, PRINCESS ALTHIA IGBALIC', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2425-013438', 'SASAM, ABEGAIL MUGOT', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2425-013440', 'JACOB, CRIZ JOHN YANOYAN', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-2425-013461', 'DECIPULO, ANDREY TAGAAN', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2425-013465', 'OGA, FRANCO SALUDES', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2425-013483', 'LIM, ALLAINE JOHANNA ITORRALDES', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2425-013538', 'YANGA, MECCAELLA THEFANEE SABUERO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:46', '2025-10-18 08:07:46'),
('02-2425-013540', 'SOMOGOY, MARK AGUSTIN SARAOS', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2425-013546', 'OLINAN, NATHANIEL GALINATO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2425-013577', 'CORPUZ, VAN AXCELL PODES', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2425-013616', 'DUMANGCAS, KEN ALPUERTO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2425-013637', 'SURIGAO, JOHN MARVIN TABASA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2425-013661', 'NUEVAS, CRIS MICHAEL HALLASGO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2425-013662', 'BABIA, AARON JOHN C.', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:39', '2025-10-18 08:07:39'),
('02-2425-013684', 'HERNAN, MARK JUDE UBALANG', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-2425-013685', 'MAROHOM, HANNAH MARIE ROBLE', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2425-013688', 'PERATER, ROYEN JULY PANTANOSAS', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2425-013800', 'SANTOS, KHARLO JOSE VILLA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2425-013820', 'MANATAD, LEO RAYE GRONDIANO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2425-013821', 'RAGASAJO, KERO AQUINO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2425-013831', 'HADJI SIRAD, ZOBAIR ALIP', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-2425-013912', 'LUMBAN, KATE CHRISTINE CUBAO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2425-013917', 'JAMAR, JOHN KENNETH AMORES', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-2425-013942', 'FAMACION, CHRISTIAN JOHN', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2425-013965', 'LAVADOR, LYCA RIVERO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2425-013976', 'CONSIAL, HAMDANIE DIMAARIG', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2425-013985', 'NOBLE, ISMAEL CEBALLO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2425-013991', 'SAPIO, KIERL ANDRIE LLOREN', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2425-013992', 'OLILA, CHRISTINE TENIO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2425-014000', 'MALONG, ART NATHANIEL BONCALES', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2425-014010', 'ZAFRA, JORENCE PIQUERO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:46', '2025-10-18 08:07:46'),
('02-2425-014020', 'JAMERO, THOMAS LLAGAS', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-2425-014024', 'PADILLA, QUENTIN', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2425-014025', 'BONILLA, EARL LAURENCE LIBO-ON', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:40', '2025-10-18 08:07:40'),
('02-2425-014029', 'CAGADAS, DAVE NATHAN SASIL', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:40', '2025-10-18 08:07:40'),
('02-2425-014037', 'ADISON, VON HENRICH', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:39', '2025-10-18 08:07:39'),
('02-2425-014047', 'CASTRO, PSYPHARE LAMILA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2425-014057', 'CASTRO, SCYTHER KENT LAMILA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2425-014092', 'OBERA, CARL', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2425-014094', 'CORDOVA, ROSE ESTEPHANIE BUNTOD', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2425-014096', 'GALVEZ, KRYZ IGEL YONSON', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-2425-014135', 'LLIDO, ROCKY CLARK BACANGGOY', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2425-014143', 'PIELAGO, JERICO SUDARIA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2425-014172', 'SAYSON, JOHN OWEN POVADORA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2425-014216', 'YAMSON, JHAY PAUL CAMANNONG', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:46', '2025-10-18 08:07:46'),
('02-2425-014249', 'TUMAKAY, JANNINE ROSE BOCADO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2425-014310', 'ROSETE, RAYMART GALLOGO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2425-014311', 'DUSOL, ALEXANDER CAPUTLI', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2425-014318', 'VIRREY, JEFFERSON RAY', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2425-014322', 'TABUDLONG, VALERIE TADLIP', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2425-014338', 'ALQUITELA, MARCO JHENOU YECYEC', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:39', '2025-10-18 08:07:39'),
('02-2425-014339', 'BANQUIL, DARRYL FELISILDA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:40', '2025-10-18 08:07:40'),
('02-2425-014370', 'GUIMBA, VANESS SANOPAO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-2425-014423', 'TABIGNE, CARYL CLARABAL', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2425-014428', 'ESLIT, ANGELINE BALUCAN', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2425-014434', 'BUKHAMMAS, SAEED SAAD KHALIL MANSEGUIAO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:40', '2025-10-18 08:07:40'),
('02-2425-014449', 'SALCEDO, ANNA LEAH BANDUNGAN', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2425-014468', 'LACDAO, KIAN CARLO A.', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-2425-014494', 'DIZON, CATERENHOPE', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2425-014504', 'AGOCOY, MICHAEL JOHN LAUYOG', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:39', '2025-10-18 08:07:39'),
('02-2425-014557', 'JARAULA, JOSHUA TABOCLAON', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-2425-014617', 'OLANDRIA, GIAN TADLAS', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2425-014628', 'LOPEZ, KENJI CORDERO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2425-014631', 'JUMUWAD, VANLOUIE CAYLO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-2425-014674', 'FUENTES, JASON GURRO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-2425-014689', 'SHIMOYAMA, JHOSHUA CHRISTIAN AMORA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2425-014780', 'JANGAO, DATU MIGUEL', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-2425-014796', 'SECHICO, FRERCH IAN LABASTIDA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2425-014810', 'DE ASIS, CHRISTINE CAHAM', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2425-014816', 'BAJENTING, FIONA MARGARET BENEMERITO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:40', '2025-10-18 08:07:40'),
('02-2425-014851', 'AMION, ANGELA BOBOROL', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:39', '2025-10-18 08:07:39'),
('02-2425-014878', 'CALAGUE, SHYRA ROJAS', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:40', '2025-10-18 08:07:40'),
('02-2425-014885', 'TUYOR, VLADIMER CHRISTOFF ALPAS', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2425-014965', 'CABALLERO, ALLEAH BLANCE SALAN', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:40', '2025-10-18 08:07:40'),
('02-2425-015091', 'BACOL, DARYL JAMES PEJE', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:39', '2025-10-18 08:07:39'),
('02-2425-015118', 'TARAN, JOSHUA ASINERO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2425-015190', 'PAJALLA, STEVENE MONTEJO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2425-015193', 'LAGUMBAY, FAITH HAINEE DENQUE', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-2425-015204', 'ACUL- ACUL, DARYL JAVE ALEONAR', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:39', '2025-10-18 08:07:39'),
('02-2425-015230', 'GALEON, JAY LOURENZ CULLA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-2425-015279', 'FELISILDA, JOYCE BRITOS', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2425-015284', 'BALABA, NIÑO CHRISTIAN PALADIAS', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:40', '2025-10-18 08:07:40'),
('02-2425-015301', 'DALIMBANG, JAYMARK BECARES', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2425-015328', 'MAGHINAY, GLACE ABREA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2425-015382', 'PULGARINAS, WINS LAURANCE MAQUILING', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2425-015538', 'CLARITO, NICK CHARLES DURANGPARANG', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2425-015581', 'SERRA, DENZEL ESCALONA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2425-015591', 'CABILI, EDWARD B.', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:40', '2025-10-18 08:07:40'),
('02-2425-015614', 'TUBIL, CHRISTIAN GALLA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2425-015651', 'CAÑETE, KENT ANDREI ESTROBO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:40', '2025-10-18 08:07:40'),
('02-2425-015661', 'OLIVAS, CYD ANTIPOLO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2425-015693', 'GAABUCAYAN, TRISTAN JOPHEL DIGOL', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-2425-015752', 'MARTINEZ, JOWEN FRANK SALVADOR', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2425-015753', 'MARTINEZ, BIAFEL AMOR GRACE SALVADOR', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2425-015756', 'DE LA CERNA, JOVEN VINCENT BABANTO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2425-015774', 'LINCUNA, CLARK DANIEL SANCHEZ', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2425-015876', 'UY, ALLEN JAPETH HERMOSO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2425-015924', 'TORRALBA, NEO QUIROGA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2425-015962', 'DITUCALAN, USMAN SUMUHID', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2425-016030', 'CALINGASAN, IAN JAY LONGNO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:40', '2025-10-18 08:07:40'),
('02-2425-016054', 'NUÑEZ, PRINZ EMMANUEL BALBON', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2425-016070', 'PIMENTEL, STEVEN MARC FABRE', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2425-016114', 'BULAY-BULAY, BRYLLE KENT FLORIDA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:40', '2025-10-18 08:07:40'),
('02-2425-016125', 'ANSUNGAY, STEPHEN CHARLS ACLARACION', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:39', '2025-10-18 08:07:39'),
('02-2425-016184', 'ABESAMIS, MISHAEL D.', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:39', '2025-10-18 08:07:39'),
('02-2425-016222', 'GERMANO, KENT AUDREY BACULIO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-2425-016229', 'ABERDE, NOVIE FAITH MEMBREVE', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:39', '2025-10-18 08:07:39'),
('02-2425-016275', 'SAYON, ALTON DEREK FILOTEO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2425-016289', 'RONDINA, HANZ ANDREW NA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2425-016293', 'ELISON, CEDRIC ELLARINA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2425-016353', 'ABAO, JUN EMMANUEL CABIGON', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:39', '2025-10-18 08:07:39'),
('02-2425-016383', 'DAANG, JAMES VALDEZ', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2425-016386', 'ESTRADA, JYRREL JAMES NADELA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2425-016410', 'PALMARES, JERRY LORIGAS', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2425-016415', 'ESTRADA, CHRISTIAN DAVE SALOM', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2425-016455', 'RAFFIÑAN, JOE BEN MATALINES', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2425-016538', 'HINALOC, ZYNAMAE BASLOT', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-2425-016608', 'BARILLO, JULAM VIC ADLAON', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:40', '2025-10-18 08:07:40'),
('02-2425-016643', 'CALDERON, ESMAEL DAMMANG', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:40', '2025-10-18 08:07:40'),
('02-2425-016645', 'ABRIOL, CLINTON BAUGO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:39', '2025-10-18 08:07:39'),
('02-2425-016686', 'LUMANDONG, MARLJUNE LOPEZ', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2425-905466', 'DAUMAR, RAYMARK CABASAG', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2425-905472', 'SAGUING, JELIAN KIM BAHIAN', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2425-905475', 'GORDO, CHERRY DENISE MENDOZA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-2425-905484', 'PEREZ, JOHN MICHAEL LADERA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2425-905594', 'PAHILMAGAN, JAYBE POLINAR', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2425-905599', 'PANTUAN, LEIGH HENRIC DENSING', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2425-905625', 'DAGULO, CARL LOUIS WAGA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2425-905635', 'BALABA, MARC JONES TABUDLONG', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:40', '2025-10-18 08:07:40'),
('02-2425-905745', 'SALVA, CRISTYL BALABA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2425-905772', 'ANTIDO, KIAN CARL BORGONIA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:39', '2025-10-18 08:07:39'),
('02-2425-905858', 'CECI, STEVEN ANGELOU -', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2425-905884', 'BAGSICAN, ANDRIAN ABUBUYOG', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:40', '2025-10-18 08:07:40'),
('02-2425-905890', 'MAGNA, DANIEL JOHN JABLA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2425-905919', 'MACARANAS, ANTHONY BACALSO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2425-905937', 'DALURA, ELAIZA RANARA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2425-906095', 'CABANA, JAYVEE KING VILLARUEL', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:40', '2025-10-18 08:07:40'),
('02-2425-906140', 'PAGAPULAR, JOHS RHADS ATABELO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2425-906156', 'GALDO, JUSTINE BUSILAC', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-2425-906157', 'GALDO, JOSHUA BUSILAC', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-2425-906165', 'SUMAOANG, ALJEN TAW-ON', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2425-906175', 'IBONA, KIFF WENN GREY NACUA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-2425-906285', 'CALALA, AINODEN CASAN', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:40', '2025-10-18 08:07:40'),
('02-2425-906288', 'PENALES, HAZEL MAE MAQUILING', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2425-906415', 'ALAY, LUKE GABRIEL', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:39', '2025-10-18 08:07:39'),
('02-2425-906500', 'PACARAT, KHEAN EZRA PENAROYA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2425-906523', 'PACOMIOS, ARVY VILLARTE', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2425-906676', 'LIGUAN, ZYRILLE FRANCIS', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2425-906722', 'BINASAG, JHONLLOYD ORIBE', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:40', '2025-10-18 08:07:40'),
('02-2425-906752', 'OSIC, MICA JANE MAY', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2425-906757', 'APAL, NESTOR RJ PITOS', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:39', '2025-10-18 08:07:39'),
('02-2425-906783', 'PINGUET, KIERBI NAZARINO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('02-2425-906837', 'AGUIRRE, DARREN HAYES GOMEZ', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:39', '2025-10-18 08:07:39'),
('02-2425-906879', 'CAHAYAG, CHINO BILL CALAMBUHAY', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:40', '2025-10-18 08:07:40'),
('02-2425-906988', 'TAGADIAD, VINA BACTONG', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2425-907002', 'GALONIA JR., ORLANDO GONZAGA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-2425-907042', 'SEBUCO, JOHN MIKE TIMBAL', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2425-907046', 'ACEBES, ARSENIO HALLASGO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:39', '2025-10-18 08:07:39'),
('02-2425-907142', 'BALINADO, KIRTH GAID', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:40', '2025-10-18 08:07:40'),
('02-2425-907144', 'CHAN, ETHAN SHAWN TALUGCO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2425-907305', 'ANDIG, LOURD CHRISTIAN VALMORIA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:39', '2025-10-18 08:07:39'),
('02-2425-907545', 'JOMOC, SVENSKA P', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:42', '2025-10-18 08:07:42'),
('02-2425-907615', 'TURNO, EDWIN MARTINEZ', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:45', '2025-10-18 08:07:45'),
('02-2425-907616', 'LUMAPAC, JOHN CLAYD TURNO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2526-015373', 'ABBU, JERICHO DAVE ROSELLO', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:39', '2025-10-18 08:07:39'),
('02-2526-019823', 'MUTIA, LOUIE CAYETANO PINEDA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:43', '2025-10-18 08:07:43'),
('02-2526-020527', 'CUENCA, ADRIANE DAVE PERONCE', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-2526-020872', 'ALON, AL HADJI', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:39', '2025-10-18 08:07:39'),
('02-2526-031388', 'DAGARAGA, VINCE XYREH PTOLEMY BAÑASIA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:41', '2025-10-18 08:07:41'),
('02-701-05-37317', 'PACANA, DEXTER DAING', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:44', '2025-10-18 08:07:44'),
('131008882', 'CANINO, RAVEN JAY LAPEÑA', 'College of Information Technology Education', 'Bachelor of Science in Information Technology', '2025-10-18 08:07:40', '2025-10-18 08:07:40');

-- --------------------------------------------------------

--
-- Table structure for table `subjects`
--

CREATE TABLE `subjects` (
  `subject_id` int(11) NOT NULL,
  `subject_name` varchar(255) NOT NULL,
  `subject_code` varchar(20) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `subjects`
--

INSERT INTO `subjects` (`subject_id`, `subject_name`, `subject_code`, `created_at`, `updated_at`) VALUES
(1, 'DATA STRUCTURE &amp; ALGORITHMS', 'ITE 031', '2025-10-18 08:08:43', '2025-10-18 08:08:43'),
(2, 'IT PROJECT MANAGEMENT', 'ITE 083', '2025-10-18 08:08:43', '2025-10-18 08:08:43'),
(3, 'NETWORKING 1', 'ITE 292', '2025-10-18 08:08:43', '2025-10-18 08:08:43'),
(4, 'INFORMATION MANAGEMENT (INCLUDING FUNDAMENTALS OF DATABASE SYSTEMS)', 'ITE 298', '2025-10-18 08:08:43', '2025-10-18 08:08:43'),
(5, 'OBJECT ORIENTED PROGRAMMING', 'ITE 300', '2025-10-18 08:08:43', '2025-10-18 08:08:43'),
(6, 'CAPSTONES PROJECT AND RESEARCH 2', 'ITE 310', '2025-10-18 08:08:43', '2025-10-18 08:08:43'),
(7, 'MANAGING IT RESOURCES (INCLUDING SOCIAL AND PROFESSIONAL ISSUES)', 'ITE 367', '2025-10-18 08:08:43', '2025-10-18 08:08:43'),
(8, 'IT BUSINESS SOLUTIONS', 'ITE 381', '2025-10-18 08:08:43', '2025-10-18 08:08:43'),
(9, 'FREEHAND AND DIGITAL DRAWING', 'ITE 391', '2025-10-18 08:08:43', '2025-10-18 08:08:43'),
(10, 'QUANTITATIVE METHODS (INCLUDING MODELING AND SIMULATION)', 'ITE 307', '2025-10-18 08:08:43', '2025-10-18 08:08:43'),
(11, 'DATA SCALABILITY &amp; ANALYTICS', 'ITE 353', '2025-10-18 08:08:43', '2025-10-18 08:08:43'),
(12, 'NETWORKING 2', 'ITE 359', '2025-10-18 08:08:43', '2025-10-18 08:08:43'),
(13, 'INFORMATION ASSURANCE AND SECURITY 1', 'ITE 369', '2025-10-18 08:08:43', '2025-10-18 08:08:43'),
(14, 'NETWORK SECURITY', 'ITE 383', '2025-10-18 08:08:43', '2025-10-18 08:08:43'),
(15, 'ADVANCED DATABASE SYSTEMS (INCLUDING ADVANCED SYSTEMS INTEGRATION AND ARCHITECTURE)', 'ITE 397', '2025-10-18 08:08:43', '2025-10-18 08:08:43'),
(16, 'BUSINESS ANALYSIS FOR IT', 'BAM 285', '2025-10-18 08:08:43', '2025-10-18 08:08:43'),
(17, 'CLEAN-UP AND IN-BETWEEN FOR IT', 'ITE 388', '2025-10-18 08:08:43', '2025-10-18 08:08:43'),
(18, 'ADVANCED PROGRAMMING', 'ITE 387', '2025-10-18 08:08:43', '2025-10-18 08:08:43'),
(19, 'APPLIED ANALYTICS IN BUSINESS FOR IT', 'BAM 286', '2025-10-18 08:08:44', '2025-10-18 08:08:44'),
(20, 'NEW VENTURE CREATION', 'ITE 323', '2025-10-18 08:08:47', '2025-10-18 08:08:47'),
(21, 'SYSTEMS INTEGRATION AND ARCHITECTURE 2', 'ITE 372', '2025-10-18 08:08:47', '2025-10-18 08:08:47');

-- --------------------------------------------------------

--
-- Table structure for table `subject_summaries`
--

CREATE TABLE `subject_summaries` (
  `summary_id` int(11) NOT NULL,
  `subject_id` int(11) NOT NULL,
  `period_id` int(11) DEFAULT NULL,
  `academic_session_id` int(11) NOT NULL,
  `year_level_id` int(11) NOT NULL,
  `total_takers` int(11) DEFAULT 0,
  `nms_count` int(11) DEFAULT 0,
  `nms_percentage` decimal(5,2) DEFAULT 0.00,
  `pts_count` int(11) DEFAULT 0,
  `pts_percentage` decimal(5,2) DEFAULT 0.00,
  `mp_count` int(11) DEFAULT 0,
  `mp_percentage` decimal(5,2) DEFAULT 0.00,
  `ehp_count` int(11) DEFAULT 0,
  `ehp_percentage` decimal(5,2) DEFAULT 0.00,
  `pass_rate` decimal(5,2) DEFAULT 0.00,
  `average_grade` decimal(5,2) DEFAULT 0.00,
  `performance_status` varchar(50) DEFAULT NULL,
  `color_indicator` varchar(20) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `subject_summaries`
--

INSERT INTO `subject_summaries` (`summary_id`, `subject_id`, `period_id`, `academic_session_id`, `year_level_id`, `total_takers`, `nms_count`, `nms_percentage`, `pts_count`, `pts_percentage`, `mp_count`, `mp_percentage`, `ehp_count`, `ehp_percentage`, `pass_rate`, `average_grade`, `performance_status`, `color_indicator`, `created_at`, `updated_at`) VALUES
(38, 1, 1, 1, 5, 583, 7, 1.20, 28, 4.80, 158, 27.10, 390, 66.90, 94.00, 78.28, 'Excellent', 'green', '2025-10-23 18:13:01', '2025-10-23 18:13:01'),
(39, 2, 1, 1, 5, 599, 5, 0.83, 20, 3.34, 132, 22.04, 442, 73.79, 95.83, 79.06, 'Excellent', 'green', '2025-10-23 18:13:01', '2025-10-23 18:13:01'),
(40, 3, 1, 1, 5, 592, 9, 1.52, 20, 3.38, 263, 44.43, 300, 50.68, 95.10, 72.46, 'Excellent', 'green', '2025-10-23 18:13:01', '2025-10-23 18:13:01'),
(41, 4, 1, 1, 5, 591, 16, 2.71, 30, 5.08, 283, 47.88, 262, 44.33, 92.22, 70.66, 'Excellent', 'green', '2025-10-23 18:13:01', '2025-10-23 18:13:01'),
(42, 5, 1, 1, 5, 584, 8, 1.37, 43, 7.36, 243, 41.61, 290, 49.66, 91.27, 72.65, 'Excellent', 'green', '2025-10-23 18:13:01', '2025-10-23 18:13:01'),
(43, 6, 1, 1, 6, 124, 0, 0.00, 0, 0.00, 56, 45.16, 68, 54.84, 100.00, 75.35, 'Excellent', 'green', '2025-10-23 18:13:01', '2025-10-23 18:13:01'),
(44, 7, 1, 1, 6, 127, 0, 0.00, 3, 2.36, 42, 33.07, 82, 64.57, 97.64, 77.67, 'Excellent', 'green', '2025-10-23 18:13:01', '2025-10-23 18:13:01'),
(45, 8, 1, 1, 6, 121, 1, 0.83, 10, 8.26, 103, 85.12, 7, 5.79, 90.91, 68.82, 'Excellent', 'green', '2025-10-23 18:13:01', '2025-10-23 18:13:01'),
(46, 9, 1, 1, 6, 38, 0, 0.00, 0, 0.00, 21, 55.26, 17, 44.74, 100.00, 70.54, 'Excellent', 'green', '2025-10-23 18:13:01', '2025-10-23 18:13:01'),
(47, 10, 1, 1, 7, 275, 3, 1.09, 3, 1.09, 13, 4.73, 256, 93.09, 97.82, 90.12, 'Excellent', 'green', '2025-10-23 18:13:01', '2025-10-23 18:13:01'),
(48, 11, 1, 1, 7, 280, 3, 1.07, 13, 4.64, 226, 80.71, 38, 13.57, 94.29, 62.64, 'Excellent', 'green', '2025-10-23 18:13:01', '2025-10-23 18:13:01'),
(49, 12, 1, 1, 7, 275, 14, 5.09, 55, 20.00, 193, 70.18, 13, 4.73, 74.91, 55.29, 'Good', 'blue', '2025-10-23 18:13:01', '2025-10-23 18:13:01'),
(50, 13, 1, 1, 7, 277, 1, 0.36, 149, 53.79, 127, 45.85, 0, 0.00, 45.85, 47.90, 'Fair', 'yellow', '2025-10-23 18:13:01', '2025-10-23 18:13:01'),
(51, 14, 1, 1, 7, 94, 1, 1.06, 68, 72.34, 25, 26.60, 0, 0.00, 26.60, 45.79, 'Fair', 'yellow', '2025-10-23 18:13:01', '2025-10-23 18:13:01'),
(52, 15, 1, 1, 7, 266, 1, 0.38, 21, 7.89, 180, 67.67, 64, 24.06, 91.73, 65.31, 'Excellent', 'green', '2025-10-23 18:13:01', '2025-10-23 18:13:01'),
(53, 16, 1, 1, 7, 78, 0, 0.00, 0, 0.00, 38, 48.72, 40, 51.28, 100.00, 74.66, 'Excellent', 'green', '2025-10-23 18:13:01', '2025-10-23 18:13:01'),
(54, 17, 1, 1, 6, 23, 0, 0.00, 0, 0.00, 8, 34.78, 15, 65.22, 100.00, 78.10, 'Excellent', 'green', '2025-10-23 18:13:01', '2025-10-23 18:13:01'),
(55, 9, 1, 1, 7, 67, 2, 2.99, 6, 8.96, 42, 62.69, 17, 25.37, 88.06, 65.89, 'Excellent', 'green', '2025-10-23 18:13:01', '2025-10-23 18:13:01'),
(56, 18, 1, 1, 7, 35, 2, 5.71, 6, 17.14, 13, 37.14, 14, 40.00, 77.14, 63.02, 'Excellent', 'green', '2025-10-23 18:13:01', '2025-10-23 18:13:01'),
(57, 18, 1, 1, 6, 30, 0, 0.00, 1, 3.33, 9, 30.00, 20, 66.67, 96.67, 79.56, 'Excellent', 'green', '2025-10-23 18:13:01', '2025-10-23 18:13:01'),
(58, 19, 1, 1, 6, 27, 0, 0.00, 1, 3.70, 3, 11.11, 23, 85.19, 96.30, 85.37, 'Excellent', 'green', '2025-10-23 18:13:01', '2025-10-23 18:13:01'),
(59, 16, 1, 1, 6, 4, 0, 0.00, 0, 0.00, 3, 75.00, 1, 25.00, 100.00, 70.25, 'Excellent', 'green', '2025-10-23 18:13:01', '2025-10-23 18:13:01'),
(60, 13, 1, 1, 6, 8, 0, 0.00, 3, 37.50, 5, 62.50, 0, 0.00, 62.50, 47.43, 'Good', 'blue', '2025-10-23 18:13:01', '2025-10-23 18:13:01'),
(61, 11, 1, 1, 6, 2, 0, 0.00, 0, 0.00, 2, 100.00, 0, 0.00, 100.00, 58.30, 'Excellent', 'green', '2025-10-23 18:13:01', '2025-10-23 18:13:01'),
(62, 1, 1, 1, 7, 7, 0, 0.00, 2, 28.57, 3, 42.86, 2, 28.57, 71.43, 61.94, 'Good', 'blue', '2025-10-23 18:13:01', '2025-10-23 18:13:01'),
(63, 3, 1, 1, 7, 10, 3, 30.00, 0, 0.00, 4, 40.00, 3, 30.00, 70.00, 55.64, 'Good', 'blue', '2025-10-23 18:13:01', '2025-10-23 18:13:01'),
(64, 5, 1, 1, 7, 8, 2, 25.00, 3, 37.50, 3, 37.50, 0, 0.00, 37.50, 37.13, 'Fair', 'yellow', '2025-10-23 18:13:01', '2025-10-23 18:13:01'),
(65, 2, 1, 1, 6, 1, 0, 0.00, 0, 0.00, 0, 0.00, 1, 100.00, 100.00, 90.98, 'Excellent', 'green', '2025-10-23 18:13:01', '2025-10-23 18:13:01'),
(66, 2, 1, 1, 7, 10, 0, 0.00, 0, 0.00, 3, 30.00, 7, 70.00, 100.00, 77.12, 'Excellent', 'green', '2025-10-23 18:13:01', '2025-10-23 18:13:01'),
(67, 14, 1, 1, 6, 2, 0, 0.00, 1, 50.00, 1, 50.00, 0, 0.00, 50.00, 46.85, 'Good', 'blue', '2025-10-23 18:13:01', '2025-10-23 18:13:01'),
(68, 15, 1, 1, 6, 1, 0, 0.00, 0, 0.00, 1, 100.00, 0, 0.00, 100.00, 57.90, 'Excellent', 'green', '2025-10-23 18:13:01', '2025-10-23 18:13:01'),
(69, 10, 1, 1, 6, 4, 1, 25.00, 0, 0.00, 1, 25.00, 2, 50.00, 75.00, 68.72, 'Excellent', 'green', '2025-10-23 18:13:01', '2025-10-23 18:13:01'),
(70, 12, 1, 1, 6, 5, 2, 40.00, 0, 0.00, 3, 60.00, 0, 0.00, 60.00, 38.03, 'Good', 'blue', '2025-10-23 18:13:01', '2025-10-23 18:13:01'),
(71, 20, 1, 1, 6, 2, 0, 0.00, 0, 0.00, 2, 100.00, 0, 0.00, 100.00, 70.10, 'Excellent', 'green', '2025-10-23 18:13:01', '2025-10-23 18:13:01'),
(72, 21, 1, 1, 6, 1, 0, 0.00, 0, 0.00, 1, 100.00, 0, 0.00, 100.00, 70.00, 'Excellent', 'green', '2025-10-23 18:13:01', '2025-10-23 18:13:01'),
(73, 4, 1, 1, 7, 4, 1, 25.00, 0, 0.00, 1, 25.00, 2, 50.00, 75.00, 58.55, 'Excellent', 'green', '2025-10-23 18:13:01', '2025-10-23 18:13:01'),
(74, 4, 1, 1, 6, 1, 0, 0.00, 0, 0.00, 1, 100.00, 0, 0.00, 100.00, 58.80, 'Excellent', 'green', '2025-10-23 18:13:01', '2025-10-23 18:13:01');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_period`
--

CREATE TABLE `tbl_period` (
  `period_id` int(11) NOT NULL,
  `period_name` varchar(100) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_period`
--

INSERT INTO `tbl_period` (`period_id`, `period_name`, `created_at`, `updated_at`) VALUES
(1, 'P1', '2025-10-18 08:04:15', '2025-10-18 08:04:15'),
(2, 'P2', '2025-10-18 08:04:15', '2025-10-18 08:04:15'),
(3, 'P3', '2025-10-18 08:04:15', '2025-10-18 08:04:15');

-- --------------------------------------------------------

--
-- Table structure for table `teachers`
--

CREATE TABLE `teachers` (
  `teacher_id` int(11) NOT NULL,
  `teacher_name` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `upload_logs`
--

CREATE TABLE `upload_logs` (
  `upload_id` int(11) NOT NULL,
  `filename` varchar(255) DEFAULT NULL,
  `records_count` int(11) DEFAULT 0,
  `upload_date` timestamp NOT NULL DEFAULT current_timestamp(),
  `status` enum('SUCCESS','FAILED') DEFAULT NULL,
  `notes` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `user_id` int(11) NOT NULL,
  `username` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `full_name` varchar(255) DEFAULT NULL,
  `department_id` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `year_levels`
--

CREATE TABLE `year_levels` (
  `year_level_id` int(11) NOT NULL,
  `year_level_name` varchar(50) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `year_levels`
--

INSERT INTO `year_levels` (`year_level_id`, `year_level_name`, `created_at`, `updated_at`) VALUES
(1, 'Y1', '2025-10-18 08:03:31', '2025-10-18 08:03:31'),
(2, 'Y2', '2025-10-18 08:03:31', '2025-10-18 08:03:31'),
(3, 'Y3', '2025-10-18 08:03:31', '2025-10-18 08:03:31'),
(4, 'Y4', '2025-10-18 08:03:31', '2025-10-18 08:03:31'),
(5, 'Year 2', '2025-10-18 08:08:43', '2025-10-18 08:08:43'),
(6, 'Year 4', '2025-10-18 08:08:43', '2025-10-18 08:08:43'),
(7, 'Year 3', '2025-10-18 08:08:43', '2025-10-18 08:08:43');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `academic_sessions`
--
ALTER TABLE `academic_sessions`
  ADD PRIMARY KEY (`academic_session_id`),
  ADD UNIQUE KEY `uq_session` (`school_year_id`,`semester_id`),
  ADD KEY `school_year_id` (`school_year_id`),
  ADD KEY `semester_id` (`semester_id`);

--
-- Indexes for table `grades`
--
ALTER TABLE `grades`
  ADD PRIMARY KEY (`grade_id`),
  ADD UNIQUE KEY `uq_grade_unique` (`student_id`,`subject_id`,`academic_session_id`,`year_level_id`,`period_id`),
  ADD KEY `student_id` (`student_id`),
  ADD KEY `subject_id` (`subject_id`),
  ADD KEY `academic_session_id` (`academic_session_id`),
  ADD KEY `year_level_id` (`year_level_id`),
  ADD KEY `period_id` (`period_id`),
  ADD KEY `category` (`category`),
  ADD KEY `status` (`status`),
  ADD KEY `added_by` (`added_by`);

--
-- Indexes for table `school_years`
--
ALTER TABLE `school_years`
  ADD PRIMARY KEY (`school_year_id`),
  ADD UNIQUE KEY `school_year` (`school_year`),
  ADD KEY `school_year_2` (`school_year`);

--
-- Indexes for table `semesters`
--
ALTER TABLE `semesters`
  ADD PRIMARY KEY (`semester_id`),
  ADD UNIQUE KEY `semester_name` (`semester_name`),
  ADD KEY `semester_name_2` (`semester_name`);

--
-- Indexes for table `students`
--
ALTER TABLE `students`
  ADD PRIMARY KEY (`student_id`),
  ADD KEY `name` (`name`);

--
-- Indexes for table `subjects`
--
ALTER TABLE `subjects`
  ADD PRIMARY KEY (`subject_id`),
  ADD UNIQUE KEY `subject_name` (`subject_name`),
  ADD KEY `subject_name_2` (`subject_name`);

--
-- Indexes for table `subject_summaries`
--
ALTER TABLE `subject_summaries`
  ADD PRIMARY KEY (`summary_id`),
  ADD UNIQUE KEY `unique_summary` (`subject_id`,`period_id`,`academic_session_id`,`year_level_id`),
  ADD KEY `idx_subject` (`subject_id`),
  ADD KEY `idx_period` (`period_id`),
  ADD KEY `idx_academic_session` (`academic_session_id`),
  ADD KEY `idx_year_level` (`year_level_id`),
  ADD KEY `idx_performance` (`performance_status`);

--
-- Indexes for table `tbl_period`
--
ALTER TABLE `tbl_period`
  ADD PRIMARY KEY (`period_id`),
  ADD UNIQUE KEY `period_name` (`period_name`),
  ADD KEY `period_name_2` (`period_name`);

--
-- Indexes for table `teachers`
--
ALTER TABLE `teachers`
  ADD PRIMARY KEY (`teacher_id`),
  ADD UNIQUE KEY `teacher_name` (`teacher_name`),
  ADD KEY `idx_teacher_name` (`teacher_name`);

--
-- Indexes for table `upload_logs`
--
ALTER TABLE `upload_logs`
  ADD PRIMARY KEY (`upload_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- Indexes for table `year_levels`
--
ALTER TABLE `year_levels`
  ADD PRIMARY KEY (`year_level_id`),
  ADD UNIQUE KEY `year_level_name` (`year_level_name`),
  ADD KEY `year_level_name_2` (`year_level_name`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `academic_sessions`
--
ALTER TABLE `academic_sessions`
  MODIFY `academic_session_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=46;

--
-- AUTO_INCREMENT for table `grades`
--
ALTER TABLE `grades`
  MODIFY `grade_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `school_years`
--
ALTER TABLE `school_years`
  MODIFY `school_year_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `semesters`
--
ALTER TABLE `semesters`
  MODIFY `semester_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `subjects`
--
ALTER TABLE `subjects`
  MODIFY `subject_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT for table `subject_summaries`
--
ALTER TABLE `subject_summaries`
  MODIFY `summary_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=75;

--
-- AUTO_INCREMENT for table `tbl_period`
--
ALTER TABLE `tbl_period`
  MODIFY `period_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=63;

--
-- AUTO_INCREMENT for table `teachers`
--
ALTER TABLE `teachers`
  MODIFY `teacher_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `upload_logs`
--
ALTER TABLE `upload_logs`
  MODIFY `upload_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `year_levels`
--
ALTER TABLE `year_levels`
  MODIFY `year_level_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `academic_sessions`
--
ALTER TABLE `academic_sessions`
  ADD CONSTRAINT `fk_session_school_year` FOREIGN KEY (`school_year_id`) REFERENCES `school_years` (`school_year_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_session_semester` FOREIGN KEY (`semester_id`) REFERENCES `semesters` (`semester_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `grades`
--
ALTER TABLE `grades`
  ADD CONSTRAINT `fk_grade_added_by` FOREIGN KEY (`added_by`) REFERENCES `users` (`user_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_grade_period` FOREIGN KEY (`period_id`) REFERENCES `tbl_period` (`period_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_grade_session` FOREIGN KEY (`academic_session_id`) REFERENCES `academic_sessions` (`academic_session_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_grade_student` FOREIGN KEY (`student_id`) REFERENCES `students` (`student_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_grade_subject` FOREIGN KEY (`subject_id`) REFERENCES `subjects` (`subject_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_grade_year_level` FOREIGN KEY (`year_level_id`) REFERENCES `year_levels` (`year_level_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `subject_summaries`
--
ALTER TABLE `subject_summaries`
  ADD CONSTRAINT `subject_summaries_ibfk_1` FOREIGN KEY (`subject_id`) REFERENCES `subjects` (`subject_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `subject_summaries_ibfk_2` FOREIGN KEY (`period_id`) REFERENCES `tbl_period` (`period_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `subject_summaries_ibfk_3` FOREIGN KEY (`academic_session_id`) REFERENCES `academic_sessions` (`academic_session_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `subject_summaries_ibfk_4` FOREIGN KEY (`year_level_id`) REFERENCES `year_levels` (`year_level_id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
