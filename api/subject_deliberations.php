<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    exit(0);
}

require_once 'connection-pdo.php';

function ensure_tables($conn) {
    // deliberation_uploads
    $conn->exec("CREATE TABLE IF NOT EXISTS deliberation_uploads (
        upload_id INT AUTO_INCREMENT PRIMARY KEY,
        academic_session_id INT NOT NULL,
        period_id INT NULL,
        file_name VARCHAR(255) NOT NULL,
        uploaded_by VARCHAR(100) NULL,
        uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4");

    // subject_deliberations
    $conn->exec("CREATE TABLE IF NOT EXISTS subject_deliberations (
        deliberation_id INT AUTO_INCREMENT PRIMARY KEY,
        upload_id INT NOT NULL,
        academic_session_id INT NOT NULL,
        year_level_id INT NOT NULL,
        period_id INT NULL,
        subject_id INT NOT NULL,
        student_id VARCHAR(50) NOT NULL,
        raw_score DECIMAL(6,2) NULL,
        grade DECIMAL(5,2) NULL,
        status ENUM('PASS','FAIL') NULL,
        decision ENUM('PROMOTE','RETAIN','REMEDIATION') NULL,
        remarks VARCHAR(500) NULL,
        metadata JSON NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        UNIQUE KEY uniq_row (academic_session_id, subject_id, student_id, period_id)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4");
}

try {
    ensure_tables($conn);

    $action = $_GET['action'] ?? '';
    $schoolYearId = $_GET['school_year_id'] ?? '';
    $semesterId = $_GET['semester_id'] ?? '';
    $periodId = $_GET['period_id'] ?? '';
    $allPeriods = $_GET['all_periods'] ?? 'false';

    switch ($action) {
        case 'getRows':
            $sql = "
                SELECT 
                    sd.deliberation_id,
                    sd.student_id,
                    sd.subject_id,
                    s.subject_code,
                    s.subject_name,
                    sd.year_level_id,
                    yl.year_level_name,
                    sd.period_id,
                    p.period_name,
                    sd.raw_score,
                    sd.grade,
                    sd.status,
                    sd.decision,
                    sd.remarks,
                    sd.created_at,
                    CONCAT(sy.school_year, ' - ', sem.semester_name) as semester_code
                FROM subject_deliberations sd
                JOIN subjects s ON sd.subject_id = s.subject_id
                JOIN year_levels yl ON sd.year_level_id = yl.year_level_id
                JOIN academic_sessions acad ON sd.academic_session_id = acad.academic_session_id
                JOIN semesters sem ON acad.semester_id = sem.semester_id
                JOIN school_years sy ON acad.school_year_id = sy.school_year_id
                LEFT JOIN tbl_period p ON sd.period_id = p.period_id
                WHERE 1=1";

            $params = [];
            if (!empty($schoolYearId)) {
                $sql .= " AND acad.school_year_id = ?";
                $params[] = $schoolYearId;
            }
            if (!empty($semesterId)) {
                $sql .= " AND acad.semester_id = ?";
                $params[] = $semesterId;
            }
            if ($allPeriods !== 'true' && !empty($periodId)) {
                $sql .= " AND sd.period_id = ?";
                $params[] = $periodId;
            }
            $sql .= " ORDER BY s.subject_name, yl.year_level_name, p.period_name, sd.student_id";

            $stmt = $conn->prepare($sql);
            $stmt->execute($params);
            $rows = $stmt->fetchAll(PDO::FETCH_ASSOC);

            echo json_encode(['status' => 'success', 'data' => $rows]);
            break;

        case 'getBatches':
            $stmt = $conn->query("SELECT 
                du.upload_id,
                du.file_name,
                du.academic_session_id,
                du.period_id,
                du.uploaded_by,
                du.uploaded_at,
                (SELECT COUNT(*) FROM subject_deliberations sd WHERE sd.upload_id = du.upload_id) as row_count
            FROM deliberation_uploads du ORDER BY du.uploaded_at DESC");
            $batches = $stmt->fetchAll(PDO::FETCH_ASSOC);
            echo json_encode(['status' => 'success', 'data' => $batches]);
            break;

        default:
            throw new Exception('Invalid action specified');
    }
} catch (Exception $e) {
    echo json_encode(['status' => 'error', 'message' => $e->getMessage()]);
}
?>


