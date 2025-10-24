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
    $action = $_GET['action'] ?? $_POST['action'] ?? '';
    
    // Get filter parameters
    $schoolYearId = $_GET['school_year_id'] ?? '';
    $semesterId = $_GET['semester_id'] ?? '';
    $periodId = $_GET['period_id'] ?? '';
    
    switch ($action) {
        case 'subjectAnalysis':
            // Get subject-level analysis
            $sql = "
                SELECT 
                    sub.subject_name,
                    yl.year_level_name as year_level,
                    sem.semester_name,
                    sy.school_year,
                    CONCAT(sy.school_year, ' - ', sem.semester_name) as semester_code,
                    COUNT(g.grade_id) as total_takers,
                    SUM(CASE WHEN g.category = 'NMS' THEN 1 ELSE 0 END) as nms_count,
                    SUM(CASE WHEN g.category = 'PTS' THEN 1 ELSE 0 END) as pts_count,
                    SUM(CASE WHEN g.category = 'MP' THEN 1 ELSE 0 END) as mp_count,
                    SUM(CASE WHEN g.category = 'EHP' THEN 1 ELSE 0 END) as ehp_count,
                    SUM(CASE WHEN g.status = 'PASS' THEN 1 ELSE 0 END) as pass_count,
                    SUM(CASE WHEN g.status = 'FAIL' THEN 1 ELSE 0 END) as fail_count,
                    AVG(g.grade) as average_grade,
                    MIN(g.grade) as min_grade,
                    MAX(g.grade) as max_grade
                FROM grades g
                JOIN subjects sub ON g.subject_id = sub.subject_id
                JOIN academic_sessions acad ON g.academic_session_id = acad.academic_session_id
                JOIN semesters sem ON acad.semester_id = sem.semester_id
                JOIN school_years sy ON acad.school_year_id = sy.school_year_id
                JOIN year_levels yl ON g.year_level_id = yl.year_level_id
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
                $sql .= " AND g.period_id = ?";
                $params[] = $periodId;
            }
            
            $sql .= " GROUP BY sub.subject_id, acad.academic_session_id, yl.year_level_id
                ORDER BY sy.school_year, sem.semester_name, sub.subject_name";
            
            $stmt = $conn->prepare($sql);
            $stmt->execute($params);
            $results = $stmt->fetchAll(PDO::FETCH_ASSOC);
            
            // Calculate percentages
            foreach ($results as &$row) {
                $total = $row['total_takers'];
                if ($total > 0) {
                    $row['nms_pct'] = round(($row['nms_count'] / $total) * 100, 2);
                    $row['pts_pct'] = round(($row['pts_count'] / $total) * 100, 2);
                    $row['mp_pct'] = round(($row['mp_count'] / $total) * 100, 2);
                    $row['ehp_pct'] = round(($row['ehp_count'] / $total) * 100, 2);
                    $row['pass_rate'] = round(($row['pass_count'] / $total) * 100, 2);
                    $row['fail_rate'] = round(($row['fail_count'] / $total) * 100, 2);
                } else {
                    $row['nms_pct'] = 0;
                    $row['pts_pct'] = 0;
                    $row['mp_pct'] = 0;
                    $row['ehp_pct'] = 0;
                    $row['pass_rate'] = 0;
                    $row['fail_rate'] = 0;
                }
                $row['average_grade'] = round($row['average_grade'], 2);
            }
            
            echo json_encode([
                'status' => 'success',
                'data' => $results
            ]);
            break;
            
        case 'studentAnalysis':
            // Get student-level analysis
            $sql = "
                SELECT 
                    s.student_id,
                    s.name,
                    CONCAT(sy.school_year, ' - ', sem.semester_name) as semester_code,
                    yl.year_level_name as year_level,
                    sem.semester_name,
                    sy.school_year,
                    COUNT(g.grade_id) as total_subjects,
                    SUM(CASE WHEN g.category = 'NMS' THEN 1 ELSE 0 END) as nms_count,
                    SUM(CASE WHEN g.category = 'PTS' THEN 1 ELSE 0 END) as pts_count,
                    SUM(CASE WHEN g.category = 'MP' THEN 1 ELSE 0 END) as mp_count,
                    SUM(CASE WHEN g.category = 'EHP' THEN 1 ELSE 0 END) as ehp_count,
                    SUM(CASE WHEN g.status = 'PASS' THEN 1 ELSE 0 END) as pass_count,
                    SUM(CASE WHEN g.status = 'FAIL' THEN 1 ELSE 0 END) as fail_count,
                    AVG(g.grade) as average_grade,
                    MIN(g.grade) as lowest_grade,
                    MAX(g.grade) as highest_grade
                FROM grades g
                JOIN students s ON g.student_id = s.student_id
                JOIN academic_sessions acad ON g.academic_session_id = acad.academic_session_id
                JOIN semesters sem ON acad.semester_id = sem.semester_id
                JOIN school_years sy ON acad.school_year_id = sy.school_year_id
                JOIN year_levels yl ON g.year_level_id = yl.year_level_id
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
                $sql .= " AND g.period_id = ?";
                $params[] = $periodId;
            }
            
            $sql .= " GROUP BY s.student_id, acad.academic_session_id, yl.year_level_id
                ORDER BY s.name, sy.school_year, sem.semester_name";
            
            $stmt = $conn->prepare($sql);
            $stmt->execute($params);
            $results = $stmt->fetchAll(PDO::FETCH_ASSOC);
            
            // Calculate percentages
            foreach ($results as &$row) {
                $total = $row['total_subjects'];
                if ($total > 0) {
                    $row['pass_rate'] = round(($row['pass_count'] / $total) * 100, 2);
                    $row['fail_rate'] = round(($row['fail_count'] / $total) * 100, 2);
                } else {
                    $row['pass_rate'] = 0;
                    $row['fail_rate'] = 0;
                }
                $row['average_grade'] = round($row['average_grade'], 2);
            }
            
            echo json_encode([
                'status' => 'success',
                'data' => $results
            ]);
            break;
            
        case 'overviewStats':
            // Get overall statistics
            $sql = "
                SELECT 
                    COUNT(DISTINCT s.student_id) as total_students,
                    COUNT(DISTINCT sub.subject_id) as total_subjects,
                    COUNT(DISTINCT acad.academic_session_id) as total_semesters,
                    COUNT(DISTINCT yl.year_level_id) as total_year_levels,
                    COUNT(g.grade_id) as total_records,
                    SUM(CASE WHEN g.status = 'PASS' THEN 1 ELSE 0 END) as total_pass,
                    SUM(CASE WHEN g.status = 'FAIL' THEN 1 ELSE 0 END) as total_fail,
                    AVG(g.grade) as overall_average,
                    MIN(g.grade) as lowest_grade,
                    MAX(g.grade) as highest_grade
                FROM grades g
                JOIN students s ON g.student_id = s.student_id
                JOIN subjects sub ON g.subject_id = sub.subject_id
                JOIN academic_sessions acad ON g.academic_session_id = acad.academic_session_id
                JOIN year_levels yl ON g.year_level_id = yl.year_level_id
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
                $sql .= " AND g.period_id = ?";
                $params[] = $periodId;
            }
            
            $stmt = $conn->prepare($sql);
            $stmt->execute($params);
            $stats = $stmt->fetch(PDO::FETCH_ASSOC);
            
            if ($stats['total_records'] > 0) {
                $stats['pass_rate'] = round(($stats['total_pass'] / $stats['total_records']) * 100, 2);
                $stats['fail_rate'] = round(($stats['total_fail'] / $stats['total_records']) * 100, 2);
            } else {
                $stats['pass_rate'] = 0;
                $stats['fail_rate'] = 0;
            }
            $stats['overall_average'] = round($stats['overall_average'], 2);
            
            echo json_encode([
                'status' => 'success',
                'data' => $stats
            ]);
            break;
            
        case 'topPerformers':
            // Get top performing students
            $limit = $_GET['limit'] ?? 10;
            $sql = "
                SELECT 
                    s.student_id,
                    s.name,
                    AVG(g.grade) as average_grade,
                    COUNT(g.grade_id) as subjects_taken,
                    SUM(CASE WHEN g.status = 'PASS' THEN 1 ELSE 0 END) as subjects_passed
                FROM grades g
                JOIN students s ON g.student_id = s.student_id
                JOIN academic_sessions acad ON g.academic_session_id = acad.academic_session_id
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
                $sql .= " AND g.period_id = ?";
                $params[] = $periodId;
            }
            
            $sql .= " GROUP BY s.student_id
                ORDER BY average_grade DESC
                LIMIT ?";
            $params[] = $limit;
            
            $stmt = $conn->prepare($sql);
            $stmt->execute($params);
            $results = $stmt->fetchAll(PDO::FETCH_ASSOC);
            
            foreach ($results as &$row) {
                $row['average_grade'] = round($row['average_grade'], 2);
            }
            
            echo json_encode([
                'status' => 'success',
                'data' => $results
            ]);
            break;
            
        case 'subjectPerformance':
            // Get subject performance ranking
            $sql = "
                SELECT 
                    sub.subject_name,
                    COUNT(g.grade_id) as total_enrollments,
                    AVG(g.grade) as average_grade,
                    SUM(CASE WHEN g.status = 'PASS' THEN 1 ELSE 0 END) as pass_count,
                    SUM(CASE WHEN g.status = 'FAIL' THEN 1 ELSE 0 END) as fail_count
                FROM grades g
                JOIN subjects sub ON g.subject_id = sub.subject_id
                JOIN academic_sessions acad ON g.academic_session_id = acad.academic_session_id
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
                $sql .= " AND g.period_id = ?";
                $params[] = $periodId;
            }
            
            $sql .= " GROUP BY sub.subject_id
                ORDER BY average_grade DESC";
            
            $stmt = $conn->prepare($sql);
            $stmt->execute($params);
            $results = $stmt->fetchAll(PDO::FETCH_ASSOC);
            
            foreach ($results as &$row) {
                $row['average_grade'] = round($row['average_grade'], 2);
                if ($row['total_enrollments'] > 0) {
                    $row['pass_rate'] = round(($row['pass_count'] / $row['total_enrollments']) * 100, 2);
                } else {
                    $row['pass_rate'] = 0;
                }
            }
            
            echo json_encode([
                'status' => 'success',
                'data' => $results
            ]);
            break;
            
        case 'semesterComparison':
            // Compare performance across semesters
            $sql = "
                SELECT 
                    CONCAT(sy.school_year, ' - ', sem.semester_name) as semester_code,
                    sem.semester_name,
                    sy.school_year,
                    yl.year_level_name as year_level,
                    COUNT(DISTINCT g.student_id) as unique_students,
                    COUNT(g.grade_id) as total_grades,
                    AVG(g.grade) as average_grade,
                    SUM(CASE WHEN g.status = 'PASS' THEN 1 ELSE 0 END) as pass_count,
                    SUM(CASE WHEN g.status = 'FAIL' THEN 1 ELSE 0 END) as fail_count
                FROM grades g
                JOIN academic_sessions acad ON g.academic_session_id = acad.academic_session_id
                JOIN semesters sem ON acad.semester_id = sem.semester_id
                JOIN school_years sy ON acad.school_year_id = sy.school_year_id
                JOIN year_levels yl ON g.year_level_id = yl.year_level_id
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
                $sql .= " AND g.period_id = ?";
                $params[] = $periodId;
            }
            
            $sql .= " GROUP BY acad.academic_session_id, yl.year_level_id
                ORDER BY sy.school_year, sem.semester_name, yl.year_level_name";
            
            $stmt = $conn->prepare($sql);
            $stmt->execute($params);
            $results = $stmt->fetchAll(PDO::FETCH_ASSOC);
            
            foreach ($results as &$row) {
                $row['average_grade'] = round($row['average_grade'], 2);
                if ($row['total_grades'] > 0) {
                    $row['pass_rate'] = round(($row['pass_count'] / $row['total_grades']) * 100, 2);
                } else {
                    $row['pass_rate'] = 0;
                }
            }
            
            echo json_encode([
                'status' => 'success',
                'data' => $results
            ]);
            break;
            
        case 'categoryDistribution':
            // Get distribution of grade categories
            $sql = "
                SELECT 
                    g.category,
                    COUNT(*) as count
                FROM grades g
                JOIN academic_sessions acad ON g.academic_session_id = acad.academic_session_id
                WHERE g.category IS NOT NULL";
            
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
                $sql .= " AND g.period_id = ?";
                $params[] = $periodId;
            }
            
            $sql .= " GROUP BY g.category
                ORDER BY FIELD(g.category, 'EHP', 'MP', 'PTS', 'NMS')";
            
            $stmt = $conn->prepare($sql);
            $stmt->execute($params);
            $results = $stmt->fetchAll(PDO::FETCH_ASSOC);
            
            // Calculate percentages based on filtered results
            $total = array_sum(array_column($results, 'count'));
            foreach ($results as &$row) {
                $row['percentage'] = $total > 0 ? round(($row['count'] / $total) * 100, 2) : 0;
            }
            
            echo json_encode([
                'status' => 'success',
                'data' => $results
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
