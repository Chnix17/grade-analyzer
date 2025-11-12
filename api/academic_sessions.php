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
        case 'getSchoolYears':
            // Get all school years (optionally filter by those with grades)
            $withGradesOnly = $_GET['withGradesOnly'] ?? 'false';
            
            if ($withGradesOnly === 'true') {
                $stmt = $conn->prepare("
                    SELECT DISTINCT sy.school_year_id, sy.school_year
                    FROM school_years sy
                    WHERE EXISTS (
                        SELECT 1 FROM academic_sessions acad 
                        WHERE acad.school_year_id = sy.school_year_id
                        AND EXISTS (
                            SELECT 1 FROM subject_summaries ss 
                            WHERE ss.academic_session_id = acad.academic_session_id
                        )
                    )
                    ORDER BY sy.school_year DESC
                ");
            } else {
                $stmt = $conn->prepare("
                    SELECT school_year_id, school_year
                    FROM school_years
                    ORDER BY school_year DESC
                ");
            }
            
            $stmt->execute();
            $schoolYears = $stmt->fetchAll(PDO::FETCH_ASSOC);
            
            echo json_encode([
                'status' => 'success',
                'data' => $schoolYears
            ]);
            break;
            
        case 'getSemesters':
            // Get semesters (optionally filtered by school_year_id)
            $schoolYearId = $_GET['school_year_id'] ?? '';
            
            if (!empty($schoolYearId)) {
                // Get semesters that have academic sessions for this school year
                $stmt = $conn->prepare("
                    SELECT DISTINCT s.semester_id, s.semester_name
                    FROM semesters s
                    JOIN academic_sessions acad ON s.semester_id = acad.semester_id
                    WHERE acad.school_year_id = ?
                    ORDER BY s.semester_id
                ");
                $stmt->execute([$schoolYearId]);
            } else {
                // Get all semesters
                $stmt = $conn->prepare("
                    SELECT semester_id, semester_name
                    FROM semesters
                    ORDER BY semester_id
                ");
                $stmt->execute();
            }
            
            $semesters = $stmt->fetchAll(PDO::FETCH_ASSOC);
            
            echo json_encode([
                'status' => 'success',
                'data' => $semesters
            ]);
            break;
            
        case 'getYearLevels':
            // Get all year levels
            $stmt = $conn->prepare("
                SELECT year_level_id, year_level_name
                FROM year_levels
                ORDER BY year_level_name
            ");
            $stmt->execute();
            $yearLevels = $stmt->fetchAll(PDO::FETCH_ASSOC);
            
            echo json_encode([
                'status' => 'success',
                'data' => $yearLevels
            ]);
            break;
            
        case 'getAcademicSession':
            // Get academic session ID by school_year_id and semester_id
            $schoolYearId = $_GET['school_year_id'] ?? '';
            $semesterId = $_GET['semester_id'] ?? '';
            
            if (empty($schoolYearId) || empty($semesterId)) {
                throw new Exception('School year ID and semester ID are required');
            }
            
            $stmt = $conn->prepare("
                SELECT 
                    acad.academic_session_id,
                    sy.school_year,
                    sem.semester_name,
                    CONCAT(sy.school_year, ' - ', sem.semester_name) as session_display
                FROM academic_sessions acad
                JOIN school_years sy ON acad.school_year_id = sy.school_year_id
                JOIN semesters sem ON acad.semester_id = sem.semester_id
                WHERE acad.school_year_id = ? AND acad.semester_id = ?
            ");
            $stmt->execute([$schoolYearId, $semesterId]);
            $session = $stmt->fetch(PDO::FETCH_ASSOC);
            
            if (!$session) {
                throw new Exception('Academic session not found');
            }
            
            echo json_encode([
                'status' => 'success',
                'data' => $session
            ]);
            break;
            
        case 'getAllAcademicSessions':
            // Get all academic sessions with details
            $stmt = $conn->prepare("
                SELECT 
                    acad.academic_session_id,
                    acad.school_year_id,
                    acad.semester_id,
                    sy.school_year,
                    sem.semester_name,
                    CONCAT(sy.school_year, ' - ', sem.semester_name) as session_display
                FROM academic_sessions acad
                JOIN school_years sy ON acad.school_year_id = sy.school_year_id
                JOIN semesters sem ON acad.semester_id = sem.semester_id
                ORDER BY sy.school_year DESC, sem.semester_id
            ");
            $stmt->execute();
            $sessions = $stmt->fetchAll(PDO::FETCH_ASSOC);
            
            echo json_encode([
                'status' => 'success',
                'data' => $sessions
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
