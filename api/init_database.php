<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    exit(0);
}

$servername = "localhost";
$dbusername = "root";
$dbpassword = "";
$dbname = "grade";

try {
    // Connect without database first
    $conn = new PDO("mysql:host=$servername", $dbusername, $dbpassword);
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    
    // Create database if not exists
    $conn->exec("CREATE DATABASE IF NOT EXISTS $dbname CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci");
    
    // Connect to the database
    $conn->exec("USE $dbname");
    
    // Create students table
    $conn->exec("CREATE TABLE IF NOT EXISTS students (
        student_id VARCHAR(50) PRIMARY KEY,
        name VARCHAR(255) NOT NULL,
        college VARCHAR(255) NULL,
        course VARCHAR(255) NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        INDEX idx_name (name),
        INDEX idx_college (college),
        INDEX idx_course (course)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci");
    
    // Create teachers table
    $conn->exec("CREATE TABLE IF NOT EXISTS teachers (
        teacher_id INT AUTO_INCREMENT PRIMARY KEY,
        teacher_name VARCHAR(255) NOT NULL UNIQUE,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        INDEX idx_teacher_name (teacher_name)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci");
    
    // Create subjects table
    $conn->exec("CREATE TABLE IF NOT EXISTS subjects (
        subject_id INT AUTO_INCREMENT PRIMARY KEY,
        subject_code VARCHAR(50) NULL,
        subject_name VARCHAR(255) NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        UNIQUE KEY unique_subject_code (subject_code),
        INDEX idx_subject_name (subject_name)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci");
    
    // Create year_levels lookup table
    $conn->exec("CREATE TABLE IF NOT EXISTS year_levels (
        year_level_id INT AUTO_INCREMENT PRIMARY KEY,
        year_level_name VARCHAR(50) NOT NULL UNIQUE,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        INDEX idx_year_level_name (year_level_name)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci");
    
    // Create tbl_period lookup table
    $conn->exec("CREATE TABLE IF NOT EXISTS tbl_period (
        period_id INT AUTO_INCREMENT PRIMARY KEY,
        period_name VARCHAR(50) NOT NULL UNIQUE,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        INDEX idx_period_name (period_name)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci");
    
    // Insert default periods if table is empty
    $conn->exec("INSERT IGNORE INTO tbl_period (period_name) VALUES ('P1'), ('P2'), ('P3')");
    
    // Create semesters lookup table (semester name only)
    $conn->exec("CREATE TABLE IF NOT EXISTS semesters (
        semester_id INT AUTO_INCREMENT PRIMARY KEY,
        semester_name VARCHAR(50) NOT NULL UNIQUE,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        INDEX idx_semester_name (semester_name)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci");
    
    // Create school_years lookup table
    $conn->exec("CREATE TABLE IF NOT EXISTS school_years (
        school_year_id INT AUTO_INCREMENT PRIMARY KEY,
        school_year VARCHAR(50) NOT NULL UNIQUE,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        INDEX idx_school_year (school_year)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci");
    
    // Create academic_sessions table (combines school_year + semester)
    $conn->exec("CREATE TABLE IF NOT EXISTS academic_sessions (
        academic_session_id INT AUTO_INCREMENT PRIMARY KEY,
        school_year_id INT NOT NULL,
        semester_id INT NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        FOREIGN KEY (school_year_id) REFERENCES school_years(school_year_id) ON DELETE CASCADE ON UPDATE CASCADE,
        FOREIGN KEY (semester_id) REFERENCES semesters(semester_id) ON DELETE CASCADE ON UPDATE CASCADE,
        UNIQUE KEY unique_academic_session (school_year_id, semester_id),
        INDEX idx_school_year (school_year_id),
        INDEX idx_semester (semester_id)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci");
    
    // Create grades table
    $conn->exec("CREATE TABLE IF NOT EXISTS grades (
        grade_id INT AUTO_INCREMENT PRIMARY KEY,
        student_id VARCHAR(50) NOT NULL,
        subject_id INT NOT NULL,
        academic_session_id INT NOT NULL,
        year_level_id INT NOT NULL,
        period_id INT NULL,
        grade DECIMAL(5,2) NOT NULL,
        category ENUM('NMS', 'PTS', 'MP', 'EHP') NULL,
        status ENUM('PASS', 'FAIL') NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE ON UPDATE CASCADE,
        FOREIGN KEY (subject_id) REFERENCES subjects(subject_id) ON DELETE CASCADE ON UPDATE CASCADE,
        FOREIGN KEY (academic_session_id) REFERENCES academic_sessions(academic_session_id) ON DELETE CASCADE ON UPDATE CASCADE,
        FOREIGN KEY (year_level_id) REFERENCES year_levels(year_level_id) ON DELETE CASCADE ON UPDATE CASCADE,
        FOREIGN KEY (period_id) REFERENCES tbl_period(period_id) ON DELETE SET NULL ON UPDATE CASCADE,
        UNIQUE KEY unique_grade (student_id, subject_id, academic_session_id, period_id),
        INDEX idx_student (student_id),
        INDEX idx_subject (subject_id),
        INDEX idx_academic_session (academic_session_id),
        INDEX idx_year_level (year_level_id),
        INDEX idx_period (period_id),
        INDEX idx_category (category),
        INDEX idx_status (status)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci");
    
    // Create subject_summaries table
    $conn->exec("CREATE TABLE IF NOT EXISTS subject_summaries (
        summary_id INT AUTO_INCREMENT PRIMARY KEY,
        subject_id INT NOT NULL,
        period_id INT NULL,
        academic_session_id INT NOT NULL,
        year_level_id INT NOT NULL,
        total_takers INT DEFAULT 0,
        nms_count INT DEFAULT 0,
        nms_percentage DECIMAL(5,2) DEFAULT 0,
        pts_count INT DEFAULT 0,
        pts_percentage DECIMAL(5,2) DEFAULT 0,
        mp_count INT DEFAULT 0,
        mp_percentage DECIMAL(5,2) DEFAULT 0,
        ehp_count INT DEFAULT 0,
        ehp_percentage DECIMAL(5,2) DEFAULT 0,
        pass_rate DECIMAL(5,2) DEFAULT 0,
        average_grade DECIMAL(5,2) DEFAULT 0,
        performance_status VARCHAR(50) NULL,
        color_indicator VARCHAR(20) NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        FOREIGN KEY (subject_id) REFERENCES subjects(subject_id) ON DELETE CASCADE ON UPDATE CASCADE,
        FOREIGN KEY (period_id) REFERENCES tbl_period(period_id) ON DELETE SET NULL ON UPDATE CASCADE,
        FOREIGN KEY (academic_session_id) REFERENCES academic_sessions(academic_session_id) ON DELETE CASCADE ON UPDATE CASCADE,
        FOREIGN KEY (year_level_id) REFERENCES year_levels(year_level_id) ON DELETE CASCADE ON UPDATE CASCADE,
        UNIQUE KEY unique_summary (subject_id, period_id, academic_session_id, year_level_id),
        INDEX idx_subject (subject_id),
        INDEX idx_period (period_id),
        INDEX idx_academic_session (academic_session_id),
        INDEX idx_year_level (year_level_id),
        INDEX idx_performance (performance_status)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci");
    
    // Create upload_logs table
    $conn->exec("CREATE TABLE IF NOT EXISTS upload_logs (
        upload_id INT AUTO_INCREMENT PRIMARY KEY,
        filename VARCHAR(255) NULL,
        records_count INT DEFAULT 0,
        upload_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        status ENUM('SUCCESS', 'FAILED') DEFAULT 'SUCCESS',
        notes TEXT NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci");
    
    echo json_encode([
        'status' => 'success',
        'message' => 'All tables created successfully',
        'tables' => ['students', 'teachers', 'subjects', 'year_levels', 'tbl_period', 'semesters', 'school_years', 'academic_sessions', 'grades', 'subject_summaries', 'upload_logs']
    ]);
    
} catch(PDOException $e) {
    echo json_encode([
        'status' => 'error',
        'message' => 'Database initialization failed: ' . $e->getMessage()
    ]);
}
?>
