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
    $allPeriods = $_GET['all_periods'] ?? 'false';
    
    switch ($action) {
        case 'getSummaries':
            // Get subject summaries from subject_summaries table
            $sql = "
                SELECT 
                    ss.summary_id,
                    sub.subject_id,
                    sub.subject_name,
                    sub.subject_code,
                    yl.year_level_name,
                    p.period_name,
                    sem.semester_name,
                    sy.school_year,
                    CONCAT(sy.school_year, ' - ', sem.semester_name) as semester_code,
                    ss.total_takers,
                    ss.nms_count,
                    ss.nms_percentage,
                    ss.pts_count,
                    ss.pts_percentage,
                    ss.mp_count,
                    ss.mp_percentage,
                    ss.ehp_count,
                    ss.ehp_percentage,
                    ss.pass_rate,
                    ss.average_grade,
                    ss.performance_status,
                    ss.color_indicator
                FROM subject_summaries ss
                JOIN subjects sub ON ss.subject_id = sub.subject_id
                JOIN academic_sessions acad ON ss.academic_session_id = acad.academic_session_id
                JOIN semesters sem ON acad.semester_id = sem.semester_id
                JOIN school_years sy ON acad.school_year_id = sy.school_year_id
                JOIN year_levels yl ON ss.year_level_id = yl.year_level_id
                LEFT JOIN tbl_period p ON ss.period_id = p.period_id
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
                $sql .= " AND ss.period_id = ?";
                $params[] = $periodId;
            }
            
            $sql .= " ORDER BY sy.school_year, sem.semester_name, sub.subject_name, yl.year_level_name, p.period_name";
            
            $stmt = $conn->prepare($sql);
            $stmt->execute($params);
            $results = $stmt->fetchAll(PDO::FETCH_ASSOC);
            
            echo json_encode([
                'status' => 'success',
                'data' => $results
            ]);
            break;
            
        case 'getOverviewStats':
            // Get overview statistics from subject_summaries table
            $sql = "
                SELECT 
                    COUNT(DISTINCT ss.subject_id) as total_subjects,
                    COUNT(DISTINCT ss.academic_session_id) as total_semesters,
                    COUNT(DISTINCT ss.year_level_id) as total_year_levels,
                    SUM(ss.total_takers) as total_students,
                    COUNT(ss.summary_id) as total_records,
                    SUM(ss.nms_count) as total_nms,
                    SUM(ss.pts_count) as total_pts,
                    SUM(ss.mp_count) as total_mp,
                    SUM(ss.ehp_count) as total_ehp,
                    SUM(ss.mp_count + ss.ehp_count) as total_pass,
                    SUM(ss.nms_count + ss.pts_count) as total_fail,
                    AVG(ss.average_grade) as overall_average_grade
                FROM subject_summaries ss
                JOIN academic_sessions acad ON ss.academic_session_id = acad.academic_session_id
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
                $sql .= " AND ss.period_id = ?";
                $params[] = $periodId;
            }
            
            $stmt = $conn->prepare($sql);
            $stmt->execute($params);
            $stats = $stmt->fetch(PDO::FETCH_ASSOC);
            
            // Calculate percentages
            $totalGrades = ($stats['total_nms'] + $stats['total_pts'] + $stats['total_mp'] + $stats['total_ehp']) ?? 0;
            if ($totalGrades > 0) {
                $stats['pass_rate'] = round(($stats['total_pass'] / $totalGrades) * 100, 2);
                $stats['fail_rate'] = round(($stats['total_fail'] / $totalGrades) * 100, 2);
            } else {
                $stats['pass_rate'] = 0;
                $stats['fail_rate'] = 0;
            }
            $stats['overall_average_grade'] = round($stats['overall_average_grade'], 2);
            
            echo json_encode([
                'status' => 'success',
                'data' => $stats
            ]);
            break;
            
        case 'getTopSubjects':
            $limit = intval($_GET['limit'] ?? 10);
            
            $sql = "
                SELECT 
                    sub.subject_name,
                    sub.subject_code,
                    yl.year_level_name,
                    p.period_name,
                    ss.total_takers,
                    (ss.mp_count + ss.ehp_count) as pass_count,
                    ss.pass_rate,
                    ss.average_grade,
                    CONCAT(sy.school_year, ' - ', sem.semester_name) as semester_code
                FROM subject_summaries ss
                JOIN subjects sub ON ss.subject_id = sub.subject_id
                JOIN year_levels yl ON ss.year_level_id = yl.year_level_id
                JOIN academic_sessions acad ON ss.academic_session_id = acad.academic_session_id
                JOIN semesters sem ON acad.semester_id = sem.semester_id
                JOIN school_years sy ON acad.school_year_id = sy.school_year_id
                LEFT JOIN tbl_period p ON ss.period_id = p.period_id
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
                $sql .= " AND ss.period_id = ?";
                $params[] = $periodId;
            }
            
            $sql .= " AND ss.total_takers > 0
                ORDER BY ss.pass_rate DESC, ss.average_grade DESC LIMIT ?";
            $params[] = $limit;
            
            $stmt = $conn->prepare($sql);
            $stmt->execute($params);
            $results = $stmt->fetchAll(PDO::FETCH_ASSOC);
            
            echo json_encode([
                'status' => 'success',
                'data' => $results
            ]);
            break;
            
        case 'getCategoryDistribution':
            // Get category distribution from subject_summaries table
            $sql = "
                SELECT 
                    SUM(ss.nms_count) as nms_count,
                    SUM(ss.pts_count) as pts_count,
                    SUM(ss.mp_count) as mp_count,
                    SUM(ss.ehp_count) as ehp_count
                FROM subject_summaries ss
                JOIN academic_sessions acad ON ss.academic_session_id = acad.academic_session_id
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
                $sql .= " AND ss.period_id = ?";
                $params[] = $periodId;
            }
            
            $stmt = $conn->prepare($sql);
            $stmt->execute($params);
            $counts = $stmt->fetch(PDO::FETCH_ASSOC);
            
            // Build results array
            $results = [
                ['category' => 'EHP', 'count' => intval($counts['ehp_count'] ?? 0)],
                ['category' => 'MP', 'count' => intval($counts['mp_count'] ?? 0)],
                ['category' => 'PTS', 'count' => intval($counts['pts_count'] ?? 0)],
                ['category' => 'NMS', 'count' => intval($counts['nms_count'] ?? 0)]
            ];
            
            // Calculate total and percentages
            $total = array_sum(array_column($results, 'count'));
            
            foreach ($results as &$row) {
                if ($total > 0) {
                    $row['percentage'] = round(($row['count'] / $total) * 100, 2);
                } else {
                    $row['percentage'] = 0;
                }
            }
            
            echo json_encode([
                'status' => 'success',
                'data' => $results,
                'total' => $total
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
