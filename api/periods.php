<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    exit(0);
}

require_once 'connection-pdo.php';

try {
    $action = $_GET['action'] ?? '';
    
    switch ($action) {
        case 'getPeriods':
            // Get periods (optionally filtered by school_year_id and semester_id)
            $schoolYearId = $_GET['school_year_id'] ?? '';
            $semesterId = $_GET['semester_id'] ?? '';
            
            if (!empty($schoolYearId) && !empty($semesterId)) {
                // Get periods that have subject summaries for this academic session
                $stmt = $conn->prepare("
                    SELECT DISTINCT p.period_id, p.period_name
                    FROM tbl_period p
                    JOIN subject_summaries ss ON p.period_id = ss.period_id
                    JOIN academic_sessions acad ON ss.academic_session_id = acad.academic_session_id
                    WHERE acad.school_year_id = ? AND acad.semester_id = ?
                    ORDER BY p.period_name
                ");
                $stmt->execute([$schoolYearId, $semesterId]);
            } else {
                // Get all periods
                $stmt = $conn->query("
                    SELECT period_id, period_name, created_at, updated_at 
                    FROM tbl_period 
                    ORDER BY period_name
                ");
            }
            
            $periods = $stmt->fetchAll(PDO::FETCH_ASSOC);
            
            echo json_encode([
                'status' => 'success',
                'data' => $periods
            ]);
            break;
            
        default:
            throw new Exception('Invalid action specified');
    }
    
} catch (Exception $e) {
    echo json_encode([
        'status' => 'error',
        'message' => $e->getMessage()
    ]);
}
?>
