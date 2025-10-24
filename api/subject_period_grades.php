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
    
    // Get filter parameters
    $schoolYearId = $_GET['school_year_id'] ?? '';
    $semesterId = $_GET['semester_id'] ?? '';
    $periodId = $_GET['period_id'] ?? '';
    $subjectId = $_GET['subject_id'] ?? '';
    
    switch ($action) {
        case 'getPeriodGrades':
            // Get subject grades per period
            $sql = "
                SELECT 
                    sgp.*,
                    sub.subject_name,
                    sub.subject_code,
                    p.period_name,
                    sem.semester_name,
                    sy.school_year,
                    CONCAT(sy.school_year, ' - ', sem.semester_name) as semester_code
                FROM subject_grades_per_period sgp
                JOIN subjects sub ON sgp.subject_id = sub.subject_id
                JOIN academic_sessions acad ON sgp.academic_session_id = acad.academic_session_id
                JOIN semesters sem ON acad.semester_id = sem.semester_id
                JOIN school_years sy ON acad.school_year_id = sy.school_year_id
                LEFT JOIN periods p ON sgp.period_id = p.period_id
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
            if (!empty($periodId)) {
                $sql .= " AND sgp.period_id = ?";
                $params[] = $periodId;
            }
            if (!empty($subjectId)) {
                $sql .= " AND sgp.subject_id = ?";
                $params[] = $subjectId;
            }
            
            $sql .= " ORDER BY sy.school_year, sem.semester_name, p.period_name, sub.subject_name";
            
            $stmt = $conn->prepare($sql);
            $stmt->execute($params);
            $results = $stmt->fetchAll(PDO::FETCH_ASSOC);
            
            echo json_encode([
                'status' => 'success',
                'data' => $results
            ]);
            break;
            
        case 'getSubjectPeriodComparison':
            // Compare grades across periods for a specific subject
            if (empty($subjectId)) {
                throw new Exception('Subject ID is required');
            }
            
            $sql = "
                SELECT 
                    sgp.*,
                    p.period_name,
                    sem.semester_name,
                    sy.school_year
                FROM subject_grades_per_period sgp
                JOIN academic_sessions acad ON sgp.academic_session_id = acad.academic_session_id
                JOIN semesters sem ON acad.semester_id = sem.semester_id
                JOIN school_years sy ON acad.school_year_id = sy.school_year_id
                LEFT JOIN periods p ON sgp.period_id = p.period_id
                WHERE sgp.subject_id = ?";
            
            $params = [$subjectId];
            
            if (!empty($schoolYearId)) {
                $sql .= " AND acad.school_year_id = ?";
                $params[] = $schoolYearId;
            }
            if (!empty($semesterId)) {
                $sql .= " AND acad.semester_id = ?";
                $params[] = $semesterId;
            }
            
            $sql .= " ORDER BY sy.school_year, sem.semester_name, p.period_name";
            
            $stmt = $conn->prepare($sql);
            $stmt->execute($params);
            $results = $stmt->fetchAll(PDO::FETCH_ASSOC);
            
            echo json_encode([
                'status' => 'success',
                'data' => $results
            ]);
            break;
            
        case 'getPeriodStatistics':
            // Get statistics for a specific period
            if (empty($periodId)) {
                throw new Exception('Period ID is required');
            }
            
            $sql = "
                SELECT 
                    COUNT(*) as total_subjects,
                    AVG(sgp.subject_avg_grade) as overall_avg,
                    MIN(sgp.subject_avg_grade) as lowest_grade,
                    MAX(sgp.subject_avg_grade) as highest_grade,
                    SUM(CASE WHEN sgp.subject_avg_grade >= 75 THEN 1 ELSE 0 END) as excellent_count,
                    SUM(CASE WHEN sgp.subject_avg_grade >= 50 AND sgp.subject_avg_grade < 75 THEN 1 ELSE 0 END) as good_count,
                    SUM(CASE WHEN sgp.subject_avg_grade >= 25 AND sgp.subject_avg_grade < 50 THEN 1 ELSE 0 END) as fair_count,
                    SUM(CASE WHEN sgp.subject_avg_grade < 25 THEN 1 ELSE 0 END) as poor_count
                FROM subject_grades_per_period sgp
                JOIN academic_sessions acad ON sgp.academic_session_id = acad.academic_session_id
                WHERE sgp.period_id = ?";
            
            $params = [$periodId];
            
            if (!empty($schoolYearId)) {
                $sql .= " AND acad.school_year_id = ?";
                $params[] = $schoolYearId;
            }
            if (!empty($semesterId)) {
                $sql .= " AND acad.semester_id = ?";
                $params[] = $semesterId;
            }
            
            $stmt = $conn->prepare($sql);
            $stmt->execute($params);
            $stats = $stmt->fetch(PDO::FETCH_ASSOC);
            
            if ($stats) {
                $stats['overall_avg'] = round($stats['overall_avg'], 2);
            }
            
            echo json_encode([
                'status' => 'success',
                'data' => $stats
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
