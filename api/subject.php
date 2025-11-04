<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    exit(0);
}

require_once 'connection-pdo.php';

function getColumnValue($row, $possibleNames, $type = 'string') {
    foreach ($possibleNames as $name) {
        if (isset($row[$name]) && $row[$name] !== '') {
            $value = $row[$name];
            if (is_string($value)) {
                $value = trim($value);
                if (in_array(strtoupper($value), ['#VALUE!', '#REF!', '#DIV/0!', '#N/A', '#NAME?', '#NULL!', '#NUM!'])) {
                    continue;
                }
            }
            if ($type === 'int') return intval($value);
            if ($type === 'float') return floatval($value);
            return $value;
        }
    }
    return $type === 'int' ? 0 : ($type === 'float' ? 0.0 : '');
}

function getCategoryAndStatus($grade) {
    $status = 'FAIL';
    if ($grade >= 75) return ['category' => 'EHP', 'status' => 'PASS'];
    if ($grade >= 50) return ['category' => 'MP', 'status' => 'PASS'];
    if ($grade >= 25) return ['category' => 'PTS', 'status' => 'FAIL'];
    return ['category' => 'NMS', 'status' => 'FAIL'];
}

/**
 * SubjectProcessor Class
 * Handles processing of Subject Raw Sheet data and generates summaries
 */
class SubjectProcessor {
    private $conn;
    private $academicSessionId;
    
    public function __construct($conn, $academicSessionId) {
        $this->conn = $conn;
        $this->academicSessionId = $academicSessionId;
    }
    
    /**
     * Helper function to find column value with flexible matching
     */
    private function getColumnValue($row, $possibleNames, $type = 'string') {
        foreach ($possibleNames as $name) {
            if (isset($row[$name]) && $row[$name] !== '') {
                $value = $row[$name];
                
                // Skip Excel error values
                if (is_string($value)) {
                    $value = trim($value);
                    if (in_array(strtoupper($value), ['#VALUE!', '#REF!', '#DIV/0!', '#N/A', '#NAME?', '#NULL!', '#NUM!'])) {
                        continue;
                    }
                }
                
                if ($type === 'int') return intval($value);
                if ($type === 'float') return floatval($value);
                return $value;
            }
        }
        return $type === 'int' ? 0 : ($type === 'float' ? 0.0 : '');
    }
    
    /**
     * Categorize grade based on cut-off table
     * NMS: 0-25, PTS: 25.01-49.99, MP: 50-74.99, EHP: 75-100
     */
    private function categorizeGrade($grade) {
        if ($grade >= 75) {
            return 'EHP';
        } elseif ($grade >= 50) {
            return 'MP';
        } elseif ($grade >= 25.01) {
            return 'PTS';
        } else {
            return 'NMS';
        }
    }
    
    /**
     * Find or create subject by code or name
     */
    private function findOrCreateSubject($subjectCode, $subjectName) {
        $subjectId = null;
        
        // Try to find by code first
        if (!empty($subjectCode)) {
            $stmt = $this->conn->prepare("SELECT subject_id FROM subjects WHERE subject_code = ? LIMIT 1");
            $stmt->execute([$subjectCode]);
            $subjectId = $stmt->fetchColumn();
        }
        
        // Try to find by name if not found by code
        if (!$subjectId && !empty($subjectName)) {
            $stmt = $this->conn->prepare("SELECT subject_id FROM subjects WHERE subject_name = ? LIMIT 1");
            $stmt->execute([$subjectName]);
            $subjectId = $stmt->fetchColumn();
        }
        
        // Create new subject if not found
        if (!$subjectId) {
            $stmt = $this->conn->prepare("INSERT INTO subjects (subject_code, subject_name) VALUES (?, ?)");
            $stmt->execute([$subjectCode, $subjectName]);
            $subjectId = $this->conn->lastInsertId();
        }
        
        return $subjectId;
    }
    
    /**
     * Find or create year level from semester string
     * Handles formats: Y2S1, Year 2 Semester 1, 2nd Year, etc.
     * Always normalizes to "Year X" format to avoid duplicates
     */
    private function findOrCreateYearLevel($semester) {
        $yearLevelName = '';
        $yearNum = null;
        
        // Remove extra spaces and convert to uppercase for parsing
        $semesterUpper = strtoupper(trim($semester));
        
        // Pattern 1: Y2S1, Y2S2 format (most common in your data)
        if (preg_match('/Y(\d+)S\d+/i', $semesterUpper, $matches)) {
            $yearNum = $matches[1];
        }
        // Pattern 2: "Year 2, Semester 1" or "Year 2 Semester 1"
        elseif (preg_match('/YEAR\s*(\d+)/i', $semesterUpper, $matches)) {
            $yearNum = $matches[1];
        }
        // Pattern 3: "2nd Year", "3rd Year", "1st Year"
        elseif (preg_match('/(\d+)(?:st|nd|rd|th)?\s*YEAR/i', $semesterUpper, $matches)) {
            $yearNum = $matches[1];
        }
        // Pattern 4: Just a number "1", "2", "3"
        elseif (preg_match('/^(\d+)$/', $semesterUpper, $matches)) {
            $yearNum = $matches[1];
        }
        
        // Normalize to "Year X" format
        if ($yearNum) {
            $yearLevelName = "Year $yearNum";
        } else {
            // Fallback: use original semester string if we can't parse it
            $yearLevelName = $semester;
        }
        
        if (empty($yearLevelName)) {
            return null;
        }
        
        // Find or create year level with normalized name
        $stmt = $this->conn->prepare("SELECT year_level_id FROM year_levels WHERE year_level_name = ? LIMIT 1");
        $stmt->execute([$yearLevelName]);
        $yearLevelId = $stmt->fetchColumn();
        
        if (!$yearLevelId) {
            $stmt = $this->conn->prepare("INSERT INTO year_levels (year_level_name) VALUES (?)");
            $stmt->execute([$yearLevelName]);
            $yearLevelId = $this->conn->lastInsertId();
        }
        
        return ['id' => $yearLevelId, 'name' => $yearLevelName];
    }
    
    /**
     * Find or create period
     */
    private function findOrCreatePeriod($periodName) {
        $stmt = $this->conn->prepare("SELECT period_id FROM tbl_period WHERE period_name = ? LIMIT 1");
        $stmt->execute([$periodName]);
        $periodId = $stmt->fetchColumn();
        
        if (!$periodId) {
            $stmt = $this->conn->prepare("INSERT INTO tbl_period (period_name) VALUES (?)");
            $stmt->execute([$periodName]);
            $periodId = $this->conn->lastInsertId();
        }
        
        return $periodId;
    }
    
    /**
     * Process Subject Raw Sheet data
     * Main method that orchestrates the batch processing
     */
    public function processSubjectRawSheet($data) {
        $recordsProcessed = 0;
        $recordsSkipped = 0;
        $errors = [];
        
        // Array to store subject summaries by key
        $subjectSummaries = [];
        
        // Log available columns
        if (count($data) > 0) {
            $availableColumns = array_keys($data[0]);
            error_log("=== SUBJECT RAW SHEET - Processing " . count($data) . " rows ===");
            error_log("Columns: " . implode(", ", $availableColumns));
        }
        
        // STEP 1: Process each row and build summaries
        foreach ($data as $index => $row) {
            try {
                // Extract student and subject data
                $studentId = $this->getColumnValue($row, ['STUDENT ID', 'Student ID', 'StudentID', 'ID']);
                $studentName = $this->getColumnValue($row, ['NAME', 'Name', 'Student Name', 'STUDENT NAME']);
                $semester = $this->getColumnValue($row, ['SEMESTER', 'Semester']);
                $subjectCode = $this->getColumnValue($row, ['CODE', 'Code', 'SUBJECT CODE', 'Subject Code']);
                $subjectName = $this->getColumnValue($row, ['SUBJECT NAME', 'Subject Name', 'Subject', 'SUBJECT']);
                
                // Extract period grades (P1, P2, P3, etc.)
                $periodGrades = [];
                foreach ($row as $colName => $colValue) {
                    if (strpos($colName, '__EMPTY') !== false) continue;
                    if (in_array(strtoupper($colName), ['CATEGORIZATION', 'REMARKS', 'CATEGORY', 'STATUS'])) continue;
                    
                    if (preg_match('/^P\d+$/i', $colName)) {
                        $grade = floatval($colValue);
                        if ($grade > 0) {
                            $periodGrades[strtoupper($colName)] = $grade;
                        }
                    }
                }
                
                // Validate required fields
                if (empty($studentId) || empty($studentName)) {
                    $recordsSkipped++;
                    continue;
                }
                
                if (empty($subjectName) && empty($subjectCode)) {
                    $recordsSkipped++;
                    continue;
                }
                
                if (empty($periodGrades)) {
                    $recordsSkipped++;
                    continue;
                }
                
                // Find or create subject
                $subjectId = $this->findOrCreateSubject($subjectCode, $subjectName);
                
                // Find or create year level
                $yearLevel = $this->findOrCreateYearLevel($semester);
                if (!$yearLevel) {
                    throw new Exception("Failed to parse year level from: '$semester'");
                }
                
                // Process each period grade
                foreach ($periodGrades as $periodName => $gradeValue) {
                    $periodId = $this->findOrCreatePeriod($periodName);
                    $category = $this->categorizeGrade($gradeValue);
                    
                    // Build unique summary key
                    $summaryKey = "{$subjectId}|{$yearLevel['id']}|{$periodId}";
                    
                    // Initialize summary if not exists
                    if (!isset($subjectSummaries[$summaryKey])) {
                        $subjectSummaries[$summaryKey] = [
                            'subject_id' => $subjectId,
                            'subject_code' => $subjectCode,
                            'subject_name' => $subjectName,
                            'year_level_id' => $yearLevel['id'],
                            'year_level_name' => $yearLevel['name'],
                            'period_id' => $periodId,
                            'period_name' => $periodName,
                            'takers' => [], // Array of unique student IDs
                            'nms_count' => 0,
                            'pts_count' => 0,
                            'mp_count' => 0,
                            'ehp_count' => 0,
                            'total_grade' => 0,
                            'grade_count' => 0
                        ];
                    }
                    
                    // Track unique takers (by student ID)
                    if (!in_array($studentId, $subjectSummaries[$summaryKey]['takers'])) {
                        $subjectSummaries[$summaryKey]['takers'][] = $studentId;
                    }
                    
                    // Increment category count
                    switch ($category) {
                        case 'NMS':
                            $subjectSummaries[$summaryKey]['nms_count']++;
                            break;
                        case 'PTS':
                            $subjectSummaries[$summaryKey]['pts_count']++;
                            break;
                        case 'MP':
                            $subjectSummaries[$summaryKey]['mp_count']++;
                            break;
                        case 'EHP':
                            $subjectSummaries[$summaryKey]['ehp_count']++;
                            break;
                    }
                    
                    // Add to total grade for average calculation
                    $subjectSummaries[$summaryKey]['total_grade'] += $gradeValue;
                    $subjectSummaries[$summaryKey]['grade_count']++;
                }
                
                $recordsProcessed++;
                
            } catch (Exception $e) {
                if (count($errors) < 10) {
                    $errors[] = "Row " . ($index + 1) . ": " . $e->getMessage();
                }
                error_log("ERROR - Row " . ($index + 1) . ": " . $e->getMessage());
                $recordsSkipped++;
            }
        }
        
        // STEP 2: Insert summaries into database
        $summariesInserted = $this->insertSubjectSummaries($subjectSummaries);
        
        return [
            'records_processed' => $recordsProcessed,
            'records_skipped' => $recordsSkipped,
            'summaries_inserted' => $summariesInserted,
            'summary_stats' => $this->buildSummaryStats($subjectSummaries),
            'errors' => $errors
        ];
    }
    
    /**
     * Insert subject summaries into database
     */
    private function insertSubjectSummaries($subjectSummaries) {
        $summariesInserted = 0;
        
        foreach ($subjectSummaries as $summary) {
            $takerCount = count($summary['takers']);
            $totalGrades = $summary['nms_count'] + $summary['pts_count'] + $summary['mp_count'] + $summary['ehp_count'];
            
            // Calculate percentages
            $nmsPercentage = $totalGrades > 0 ? round(($summary['nms_count'] / $totalGrades) * 100, 2) : 0;
            $ptsPercentage = $totalGrades > 0 ? round(($summary['pts_count'] / $totalGrades) * 100, 2) : 0;
            $mpPercentage = $totalGrades > 0 ? round(($summary['mp_count'] / $totalGrades) * 100, 2) : 0;
            $ehpPercentage = $totalGrades > 0 ? round(($summary['ehp_count'] / $totalGrades) * 100, 2) : 0;
            $averageGrade = $summary['grade_count'] > 0 ? round($summary['total_grade'] / $summary['grade_count'], 2) : 0;
            
            // Calculate pass rate (MP + EHP)
            $passCount = $summary['mp_count'] + $summary['ehp_count'];
            $passRate = $totalGrades > 0 ? round(($passCount / $totalGrades) * 100, 2) : 0;
            
            // Determine performance status and color
            if ($passRate >= 75) {
                $performanceStatus = 'Excellent';
                $colorIndicator = 'green';
            } elseif ($passRate >= 50) {
                $performanceStatus = 'Good';
                $colorIndicator = 'blue';
            } elseif ($passRate >= 25) {
                $performanceStatus = 'Fair';
                $colorIndicator = 'yellow';
            } else {
                $performanceStatus = 'Poor';
                $colorIndicator = 'red';
            }
            
            // Insert or update subject_summaries
            $stmt = $this->conn->prepare("
                INSERT INTO subject_summaries (
                    subject_id,
                    period_id,
                    academic_session_id,
                    year_level_id,
                    total_takers,
                    nms_count,
                    nms_percentage,
                    pts_count,
                    pts_percentage,
                    mp_count,
                    mp_percentage,
                    ehp_count,
                    ehp_percentage,
                    pass_rate,
                    average_grade,
                    performance_status,
                    color_indicator
                )
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
                ON DUPLICATE KEY UPDATE
                    total_takers = VALUES(total_takers),
                    nms_count = VALUES(nms_count),
                    nms_percentage = VALUES(nms_percentage),
                    pts_count = VALUES(pts_count),
                    pts_percentage = VALUES(pts_percentage),
                    mp_count = VALUES(mp_count),
                    mp_percentage = VALUES(mp_percentage),
                    ehp_count = VALUES(ehp_count),
                    ehp_percentage = VALUES(ehp_percentage),
                    pass_rate = VALUES(pass_rate),
                    average_grade = VALUES(average_grade),
                    performance_status = VALUES(performance_status),
                    color_indicator = VALUES(color_indicator)
            ");
            
            $stmt->execute([
                $summary['subject_id'],
                $summary['period_id'],
                $this->academicSessionId,
                $summary['year_level_id'],
                $takerCount,
                $summary['nms_count'],
                $nmsPercentage,
                $summary['pts_count'],
                $ptsPercentage,
                $summary['mp_count'],
                $mpPercentage,
                $summary['ehp_count'],
                $ehpPercentage,
                $passRate,
                $averageGrade,
                $performanceStatus,
                $colorIndicator
            ]);
            
            $summariesInserted++;
        }
        
        return $summariesInserted;
    }
    
    /**
     * Build summary statistics for response
     */
    private function buildSummaryStats($subjectSummaries) {
        $stats = [];
        
        foreach ($subjectSummaries as $summary) {
            $takerCount = count($summary['takers']);
            $totalGrades = $summary['nms_count'] + $summary['pts_count'] + $summary['mp_count'] + $summary['ehp_count'];
            
            $averageGrade = $summary['grade_count'] > 0 ? round($summary['total_grade'] / $summary['grade_count'], 2) : 0;
            $passCount = $summary['mp_count'] + $summary['ehp_count'];
            $passRate = $totalGrades > 0 ? round(($passCount / $totalGrades) * 100, 2) : 0;
            
            $stats[] = [
                'subject_code' => $summary['subject_code'],
                'subject_name' => $summary['subject_name'],
                'year_level' => $summary['year_level_name'],
                'period' => $summary['period_name'],
                'takers' => $takerCount,
                'nms_count' => $summary['nms_count'],
                'pts_count' => $summary['pts_count'],
                'mp_count' => $summary['mp_count'],
                'ehp_count' => $summary['ehp_count'],
                'average_grade' => $averageGrade,
                'pass_rate' => $passRate
            ];
        }
        
        return $stats;
    }
}

try {
    if ($_SERVER['REQUEST_METHOD'] === 'GET') {
        $action = $_GET['action'] ?? '';
        switch ($action) {
            case 'getSchoolYears':
                $withGradesOnly = $_GET['withGradesOnly'] ?? 'false';
                if ($withGradesOnly === 'true') {
                    $stmt = $conn->prepare("SELECT DISTINCT sy.school_year_id, sy.school_year FROM school_years sy JOIN academic_sessions acad ON sy.school_year_id = acad.school_year_id JOIN subject_summaries ss ON acad.academic_session_id = ss.academic_session_id ORDER BY sy.school_year DESC");
                } else {
                    $stmt = $conn->prepare("SELECT school_year_id, school_year FROM school_years ORDER BY school_year DESC");
                }
                $stmt->execute();
                echo json_encode(['status' => 'success', 'data' => $stmt->fetchAll(PDO::FETCH_ASSOC)]);
                break;
            case 'getSemesters':
                $schoolYearId = $_GET['school_year_id'] ?? '';
                if (!empty($schoolYearId)) {
                    $stmt = $conn->prepare("SELECT DISTINCT s.semester_id, s.semester_name FROM semesters s JOIN academic_sessions acad ON s.semester_id = acad.semester_id JOIN subject_summaries ss ON acad.academic_session_id = ss.academic_session_id WHERE acad.school_year_id = ? ORDER BY s.semester_id");
                    $stmt->execute([$schoolYearId]);
                } else {
                    $stmt = $conn->prepare("SELECT semester_id, semester_name FROM semesters ORDER BY semester_id");
                    $stmt->execute();
                }
                echo json_encode(['status' => 'success', 'data' => $stmt->fetchAll(PDO::FETCH_ASSOC)]);
                break;
            case 'getYearLevels':
                $stmt = $conn->prepare("SELECT year_level_id, year_level_name FROM year_levels ORDER BY year_level_name");
                $stmt->execute();
                echo json_encode(['status' => 'success', 'data' => $stmt->fetchAll(PDO::FETCH_ASSOC)]);
                break;
            case 'getAcademicSession':
                $schoolYearId = $_GET['school_year_id'] ?? '';
                $semesterId = $_GET['semester_id'] ?? '';
                if (empty($schoolYearId) || empty($semesterId)) {
                    throw new Exception('School year ID and semester ID are required');
                }
                $stmt = $conn->prepare("SELECT acad.academic_session_id, sy.school_year, sem.semester_name, CONCAT(sy.school_year, ' - ', sem.semester_name) as session_display FROM academic_sessions acad JOIN school_years sy ON acad.school_year_id = sy.school_year_id JOIN semesters sem ON acad.semester_id = sem.semester_id WHERE acad.school_year_id = ? AND acad.semester_id = ?");
                $stmt->execute([$schoolYearId, $semesterId]);
                $session = $stmt->fetch(PDO::FETCH_ASSOC);
                if (!$session) {
                    throw new Exception('Academic session not found');
                }
                echo json_encode(['status' => 'success', 'data' => $session]);
                break;
            case 'getAllAcademicSessions':
                $stmt = $conn->prepare("SELECT acad.academic_session_id, acad.school_year_id, acad.semester_id, sy.school_year, sem.semester_name, CONCAT(sy.school_year, ' - ', sem.semester_name) as session_display FROM academic_sessions acad JOIN school_years sy ON acad.school_year_id = sy.school_year_id JOIN semesters sem ON acad.semester_id = sem.semester_id ORDER BY sy.school_year DESC, sem.semester_id");
                $stmt->execute();
                echo json_encode(['status' => 'success', 'data' => $stmt->fetchAll(PDO::FETCH_ASSOC)]);
                break;
            case 'getPeriods':
                $schoolYearId = $_GET['school_year_id'] ?? '';
                $semesterId = $_GET['semester_id'] ?? '';
                if (!empty($schoolYearId) && !empty($semesterId)) {
                    $stmt = $conn->prepare("SELECT DISTINCT p.period_id, p.period_name FROM tbl_period p JOIN subject_summaries ss ON p.period_id = ss.period_id JOIN academic_sessions acad ON ss.academic_session_id = acad.academic_session_id WHERE acad.school_year_id = ? AND acad.semester_id = ? ORDER BY p.period_name");
                    $stmt->execute([$schoolYearId, $semesterId]);
                } else {
                    $stmt = $conn->query("SELECT period_id, period_name, created_at, updated_at FROM tbl_period ORDER BY period_name");
                }
                echo json_encode(['status' => 'success', 'data' => $stmt->fetchAll(PDO::FETCH_ASSOC)]);
                break;
            case 'getSummaries':
                $schoolYearId = $_GET['school_year_id'] ?? '';
                $semesterId = $_GET['semester_id'] ?? '';
                $periodId = $_GET['period_id'] ?? '';
                $allPeriods = $_GET['all_periods'] ?? 'false';
                $sql = "SELECT ss.summary_id, sub.subject_id, sub.subject_name, sub.subject_code, yl.year_level_name, p.period_name, sem.semester_name, sy.school_year, CONCAT(sy.school_year, ' - ', sem.semester_name) as semester_code, ss.total_takers, ss.nms_count, ss.nms_percentage, ss.pts_count, ss.pts_percentage, ss.mp_count, ss.mp_percentage, ss.ehp_count, ss.ehp_percentage, ss.pass_rate, ss.average_grade, ss.performance_status, ss.color_indicator FROM subject_summaries ss JOIN subjects sub ON ss.subject_id = sub.subject_id JOIN academic_sessions acad ON ss.academic_session_id = acad.academic_session_id JOIN semesters sem ON acad.semester_id = sem.semester_id JOIN school_years sy ON acad.school_year_id = sy.school_year_id JOIN year_levels yl ON ss.year_level_id = yl.year_level_id LEFT JOIN tbl_period p ON ss.period_id = p.period_id WHERE 1=1";
                $params = [];
                if (!empty($schoolYearId)) { $sql .= " AND acad.school_year_id = ?"; $params[] = $schoolYearId; }
                if (!empty($semesterId)) { $sql .= " AND acad.semester_id = ?"; $params[] = $semesterId; }
                if ($allPeriods !== 'true' && !empty($periodId)) { $sql .= " AND ss.period_id = ?"; $params[] = $periodId; }
                $sql .= " ORDER BY sy.school_year, sem.semester_name, sub.subject_name, yl.year_level_name, p.period_name";
                $stmt = $conn->prepare($sql);
                $stmt->execute($params);
                echo json_encode(['status' => 'success', 'data' => $stmt->fetchAll(PDO::FETCH_ASSOC)]);
                break;
            case 'getOverviewStats':
                $schoolYearId = $_GET['school_year_id'] ?? '';
                $semesterId = $_GET['semester_id'] ?? '';
                $periodId = $_GET['period_id'] ?? '';
                $allPeriods = $_GET['all_periods'] ?? 'false';
                $sql = "SELECT COUNT(DISTINCT ss.subject_id) as total_subjects, COUNT(DISTINCT ss.academic_session_id) as total_semesters, COUNT(DISTINCT ss.year_level_id) as total_year_levels, SUM(ss.total_takers) as total_students, COUNT(ss.summary_id) as total_records, SUM(ss.nms_count) as total_nms, SUM(ss.pts_count) as total_pts, SUM(ss.mp_count) as total_mp, SUM(ss.ehp_count) as total_ehp, SUM(ss.mp_count + ss.ehp_count) as total_pass, SUM(ss.nms_count + ss.pts_count) as total_fail, AVG(ss.average_grade) as overall_average_grade FROM subject_summaries ss JOIN academic_sessions acad ON ss.academic_session_id = acad.academic_session_id WHERE 1=1";
                $params = [];
                if (!empty($schoolYearId)) { $sql .= " AND acad.school_year_id = ?"; $params[] = $schoolYearId; }
                if (!empty($semesterId)) { $sql .= " AND acad.semester_id = ?"; $params[] = $semesterId; }
                if ($allPeriods !== 'true' && !empty($periodId)) { $sql .= " AND ss.period_id = ?"; $params[] = $periodId; }
                $stmt = $conn->prepare($sql);
                $stmt->execute($params);
                $stats = $stmt->fetch(PDO::FETCH_ASSOC);
                $totalGrades = ($stats['total_nms'] + $stats['total_pts'] + $stats['total_mp'] + $stats['total_ehp']) ?? 0;
                if ($totalGrades > 0) {
                    $stats['pass_rate'] = round(($stats['total_pass'] / $totalGrades) * 100, 2);
                    $stats['fail_rate'] = round(($stats['total_fail'] / $totalGrades) * 100, 2);
                } else {
                    $stats['pass_rate'] = 0;
                    $stats['fail_rate'] = 0;
                }
                $stats['overall_average_grade'] = round($stats['overall_average_grade'], 2);
                echo json_encode(['status' => 'success', 'data' => $stats]);
                break;
            case 'getTopSubjects':
                $schoolYearId = $_GET['school_year_id'] ?? '';
                $semesterId = $_GET['semester_id'] ?? '';
                $periodId = $_GET['period_id'] ?? '';
                $allPeriods = $_GET['all_periods'] ?? 'false';
                $limit = intval($_GET['limit'] ?? 10);
                $sql = "SELECT sub.subject_name, sub.subject_code, yl.year_level_name, p.period_name, ss.total_takers, (ss.mp_count + ss.ehp_count) as pass_count, ss.pass_rate, ss.average_grade, CONCAT(sy.school_year, ' - ', sem.semester_name) as semester_code FROM subject_summaries ss JOIN subjects sub ON ss.subject_id = sub.subject_id JOIN year_levels yl ON ss.year_level_id = yl.year_level_id JOIN academic_sessions acad ON ss.academic_session_id = acad.academic_session_id JOIN semesters sem ON acad.semester_id = sem.semester_id JOIN school_years sy ON acad.school_year_id = sy.school_year_id LEFT JOIN tbl_period p ON ss.period_id = p.period_id WHERE 1=1";
                $params = [];
                if (!empty($schoolYearId)) { $sql .= " AND acad.school_year_id = ?"; $params[] = $schoolYearId; }
                if (!empty($semesterId)) { $sql .= " AND acad.semester_id = ?"; $params[] = $semesterId; }
                if ($allPeriods !== 'true' && !empty($periodId)) { $sql .= " AND ss.period_id = ?"; $params[] = $periodId; }
                $sql .= " AND ss.total_takers > 0 ORDER BY ss.pass_rate DESC, ss.average_grade DESC LIMIT ?";
                $params[] = $limit;
                $stmt = $conn->prepare($sql);
                $stmt->execute($params);
                echo json_encode(['status' => 'success', 'data' => $stmt->fetchAll(PDO::FETCH_ASSOC)]);
                break;
            case 'getCategoryDistribution':
                $schoolYearId = $_GET['school_year_id'] ?? '';
                $semesterId = $_GET['semester_id'] ?? '';
                $periodId = $_GET['period_id'] ?? '';
                $allPeriods = $_GET['all_periods'] ?? 'false';
                $sql = "SELECT SUM(ss.nms_count) as nms_count, SUM(ss.pts_count) as pts_count, SUM(ss.mp_count) as mp_count, SUM(ss.ehp_count) as ehp_count FROM subject_summaries ss JOIN academic_sessions acad ON ss.academic_session_id = acad.academic_session_id WHERE 1=1";
                $params = [];
                if (!empty($schoolYearId)) { $sql .= " AND acad.school_year_id = ?"; $params[] = $schoolYearId; }
                if (!empty($semesterId)) { $sql .= " AND acad.semester_id = ?"; $params[] = $semesterId; }
                if ($allPeriods !== 'true' && !empty($periodId)) { $sql .= " AND ss.period_id = ?"; $params[] = $periodId; }
                $stmt = $conn->prepare($sql);
                $stmt->execute($params);
                $counts = $stmt->fetch(PDO::FETCH_ASSOC);
                $results = [
                    ['category' => 'EHP', 'count' => intval($counts['ehp_count'] ?? 0)],
                    ['category' => 'MP', 'count' => intval($counts['mp_count'] ?? 0)],
                    ['category' => 'PTS', 'count' => intval($counts['pts_count'] ?? 0)],
                    ['category' => 'NMS', 'count' => intval($counts['nms_count'] ?? 0)]
                ];
                $total = array_sum(array_column($results, 'count'));
                foreach ($results as &$row) {
                    $row['percentage'] = $total > 0 ? round(($row['count'] / $total) * 100, 2) : 0;
                }
                echo json_encode(['status' => 'success', 'data' => $results, 'total' => $total]);
                break;
            default:
                throw new Exception('Invalid action specified');
        }
    } else {
        $operation = $_POST['operation'] ?? '';
        switch ($operation) {
            case 'processSubjectRawSheet':
                $json = $_POST['json'] ?? '';
                $academicSessionId = $_POST['academic_session_id'] ?? '';
                if (empty($json)) { throw new Exception('Missing required data'); }
                if (empty($academicSessionId)) { throw new Exception('Please select School Year and Semester before uploading'); }
                $data = json_decode($json, true);
                if (!is_array($data)) { throw new Exception('Invalid data format'); }
                $conn->beginTransaction();
                $processor = new SubjectProcessor($conn, $academicSessionId);
                $result = $processor->processSubjectRawSheet($data);
                $conn->commit();
                echo json_encode([
                    'status' => 'success',
                    'message' => "Subject raw sheet processed successfully. Inserted {$result['summaries_inserted']} subject summaries.",
                    'records_processed' => $result['records_processed'],
                    'records_skipped' => $result['records_skipped'],
                    'summaries_inserted' => $result['summaries_inserted'],
                    'summary_stats' => $result['summary_stats'],
                    'errors' => $result['errors'],
                    'debug' => count($result['errors']) > 0 || $result['records_skipped'] > 0
                ]);
                break;
            case 'saveStudentGrades':
                $json = $_POST['json'] ?? '';
                $academicSessionId = $_POST['academic_session_id'] ?? '';
                if (empty($json)) { throw new Exception('Missing required data'); }
                if (empty($academicSessionId)) { throw new Exception('Please select School Year and Semester before uploading'); }
                $data = json_decode($json, true);
                if (!is_array($data)) { throw new Exception('Invalid data format'); }
                $conn->beginTransaction();
                $recordsProcessed = 0; $recordsSkipped = 0; $errors = [];
                foreach ($data as $index => $row) {
                    try {
                        $studentId = getColumnValue($row, ['STUDENT ID', 'Student ID', 'StudentID', 'ID']);
                        $studentName = getColumnValue($row, ['NAME', 'Name', 'Student Name', 'STUDENT NAME']);
                        $college = getColumnValue($row, ['COLLEGE', 'College']);
                        $course = getColumnValue($row, ['COURSE', 'Course', 'Program', 'PROGRAM']);
                        $semester = getColumnValue($row, ['SEMESTER', 'Semester', 'SESSION', 'Session']);
                        $subjectCode = getColumnValue($row, ['CODE', 'Code', 'SUBJECT CODE', 'Subject Code']);
                        $subjectName = getColumnValue($row, ['SUBJECT NAME', 'Subject Name', 'Subject', 'SUBJECT']);
                        $periodGrades = [];
                        foreach ($row as $colName => $colValue) {
                            if (strpos($colName, '__EMPTY') !== false) continue;
                            if (in_array(strtoupper($colName), ['CATEGORIZATION', 'REMARKS', 'CATEGORY', 'STATUS'])) continue;
                            if (preg_match('/^P\d+$/i', $colName)) {
                                $grade = floatval($colValue);
                                if ($grade > 0) { $periodGrades[strtoupper($colName)] = $grade; }
                            }
                        }
                        if (empty($studentId) || empty($studentName)) { if (count($errors) < 10) { $errors[] = "Row " . ($index + 1) . ": Missing student ID or name"; } $recordsSkipped++; continue; }
                        if (empty($subjectName) && empty($subjectCode)) { if (count($errors) < 10) { $errors[] = "Row " . ($index + 1) . ": Missing subject information"; } $recordsSkipped++; continue; }
                        if (empty($periodGrades)) { $recordsSkipped++; continue; }
                        $stmt = $conn->prepare("INSERT INTO students (student_id, name, college, course) VALUES (?, ?, ?, ?) ON DUPLICATE KEY UPDATE name = VALUES(name), college = VALUES(college), course = VALUES(course)");
                        $stmt->execute([$studentId, $studentName, $college, $course]);
                        $subjectId = null;
                        if (!empty($subjectCode)) {
                            $stmt = $conn->prepare("SELECT subject_id FROM subjects WHERE subject_code = ? LIMIT 1");
                            $stmt->execute([$subjectCode]);
                            $subjectId = $stmt->fetchColumn();
                        }
                        if (!$subjectId && !empty($subjectName)) {
                            $stmt = $conn->prepare("SELECT subject_id FROM subjects WHERE subject_name = ? LIMIT 1");
                            $stmt->execute([$subjectName]);
                            $subjectId = $stmt->fetchColumn();
                        }
                        if (!$subjectId) {
                            $stmt = $conn->prepare("INSERT INTO subjects (subject_code, subject_name) VALUES (?, ?)");
                            $stmt->execute([$subjectCode, $subjectName]);
                            $subjectId = $conn->lastInsertId();
                        }
                        if (!$subjectId) { throw new Exception('Failed to get or create subject'); }
                        $yearLevelId = null; $yearLevelName = '';
                        if (preg_match('/(?:Year\s*)?(\d+)/i', $semester, $matches)) { $yearLevelName = "Year " . $matches[1]; } else { $yearLevelName = $semester; }
                        if (!empty($yearLevelName)) {
                            $stmt = $conn->prepare("SELECT year_level_id FROM year_levels WHERE year_level_name = ? LIMIT 1");
                            $stmt->execute([$yearLevelName]);
                            $yearLevelId = $stmt->fetchColumn();
                            if (!$yearLevelId) {
                                $stmt = $conn->prepare("INSERT INTO year_levels (year_level_name) VALUES (?)");
                                $stmt->execute([$yearLevelName]);
                                $yearLevelId = $conn->lastInsertId();
                            }
                        }
                        if (!$yearLevelId) { throw new Exception("Failed to get or create year level from: '$semester'"); }
                        foreach ($periodGrades as $periodName => $gradeValue) {
                            $stmt = $conn->prepare("SELECT period_id FROM tbl_period WHERE period_name = ? LIMIT 1");
                            $stmt->execute([$periodName]);
                            $periodId = $stmt->fetchColumn();
                            if (!$periodId) {
                                $stmt = $conn->prepare("INSERT INTO tbl_period (period_name) VALUES (?)");
                                $stmt->execute([$periodName]);
                                $periodId = $conn->lastInsertId();
                            }
                            $gradeInfo = getCategoryAndStatus($gradeValue);
                            $stmt = $conn->prepare("INSERT INTO grades (student_id, subject_id, academic_session_id, year_level_id, period_id, grade, category, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?) ON DUPLICATE KEY UPDATE grade = VALUES(grade), category = VALUES(category), status = VALUES(status)");
                            $stmt->execute([$studentId, $subjectId, $academicSessionId, $yearLevelId, $periodId, $gradeValue, $gradeInfo['category'], $gradeInfo['status']]);
                        }
                        $recordsProcessed++;
                    } catch (Exception $e) {
                        $errorMsg = "Row " . ($index + 1) . ": " . $e->getMessage();
                        if (count($errors) < 10) { $errors[] = $errorMsg; }
                        $recordsSkipped++;
                    }
                }
                $conn->commit();
                $columnInfo = [];
                if (count($data) > 0) { $columnInfo = array_keys($data[0]); }
                echo json_encode(['status' => 'success', 'message' => 'Student grades saved successfully', 'records_processed' => $recordsProcessed, 'records_skipped' => $recordsSkipped, 'errors' => $errors, 'columns_found' => $columnInfo, 'debug' => count($errors) > 0 || $recordsSkipped > 0]);
                break;
            case 'saveSubjectSummary':
                $json = $_POST['json'] ?? '';
                $academicSessionId = $_POST['academic_session_id'] ?? '';
                if (empty($json)) { throw new Exception('Missing required data'); }
                if (empty($academicSessionId)) { throw new Exception('Please select School Year and Semester before uploading'); }
                $data = json_decode($json, true);
                if (!is_array($data)) { throw new Exception('Invalid data format'); }
                $conn->beginTransaction();
                $recordsProcessed = 0; $recordsSkipped = 0; $errors = [];
                foreach ($data as $index => $row) {
                    try {
                        $subjectCode = getColumnValue($row, ['CODE', 'Code', 'SUBJECT CODE', 'Subject Code']);
                        $subjectName = getColumnValue($row, ['SUBJECT NAME', 'Subject Name', 'Subject', 'SUBJECT']);
                        $yearLevelName = getColumnValue($row, ['SEMESTER', 'Semester', 'Year Level', 'YEAR LEVEL', 'YearLevel']);
                        $takers = getColumnValue($row, ['Takers', 'TAKERS', 'Total Takers'], 'int');
                        $nmsCount = getColumnValue($row, ['NMS Count', 'NMS_Count', 'NMSCount'], 'int');
                        $nmsPercent = getColumnValue($row, ['%', 'NMS %', 'NMS Percentage'], 'float');
                        $ptsCount = getColumnValue($row, ['PTS Count', 'PTS_Count', 'PTSCount'], 'int');
                        $ptsPercent = getColumnValue($row, ['%_1', 'PTS %', 'PTS Percentage'], 'float');
                        $mpCount = getColumnValue($row, ['MP Count', 'MP_Count', 'MPCount'], 'int');
                        $mpPercent = getColumnValue($row, ['%_2', 'MP %', 'MP Percentage'], 'float');
                        $ehpCount = getColumnValue($row, ['E/HP Count', 'EH/P Count', 'EHP Count', 'EHP_Count', 'EHPCount'], 'int');
                        $ehpPercent = getColumnValue($row, ['%_3', 'EHP %', 'E/HP %', 'EH/P %', 'EHP Percentage'], 'float');
                        $passRate = getColumnValue($row, ['TOTAL', 'Total', 'PASS%', 'Pass%', 'P1', 'Pass Rate'], 'float');
                        $colorIndicator = getColumnValue($row, ['CATEGORIZATION', 'Categorization', 'YELLOW', 'Yellow', 'GREEN', 'Green', 'RED', 'Red']);
                        if (!empty($colorIndicator) && strpos(strtoupper($colorIndicator), '#') === 0) { $colorIndicator = ''; }
                        if ($takers == 0) { $takers = $nmsCount + $ptsCount + $mpCount + $ehpCount; }
                        if (empty($subjectName) || empty($yearLevelName)) { if (count($errors) < 10) { $errors[] = "Row " . ($index + 1) . ": Missing subject name or year level"; } $recordsSkipped++; continue; }
                        if (strlen($subjectName) < 5 && strtoupper($subjectName) === $subjectName && strpos($subjectName, ' ') === false) { if (count($errors) < 10) { $errors[] = "Row " . ($index + 1) . ": Subject name appears to be a code instead of a full name: '$subjectName'"; } $recordsSkipped++; continue; }
                        $stmt = $conn->prepare("SELECT year_level_id FROM year_levels WHERE year_level_name = ? LIMIT 1");
                        $stmt->execute([$yearLevelName]);
                        $yearLevelId = $stmt->fetchColumn();
                        if (!$yearLevelId) {
                            $stmt = $conn->prepare("INSERT INTO year_levels (year_level_name) VALUES (?)");
                            $stmt->execute([$yearLevelName]);
                            $yearLevelId = $conn->lastInsertId();
                        }
                        if (!$yearLevelId) { throw new Exception("Failed to get or create year level: '$yearLevelName'"); }
                        $subjectId = null;
                        if (!empty($subjectCode)) {
                            $stmt = $conn->prepare("SELECT subject_id, subject_name FROM subjects WHERE subject_code = ? LIMIT 1");
                            $stmt->execute([$subjectCode]);
                            $existingByCode = $stmt->fetch(PDO::FETCH_ASSOC);
                            if ($existingByCode) {
                                $subjectId = $existingByCode['subject_id'];
                                if (!empty($subjectName) && strlen($subjectName) > strlen($existingByCode['subject_name'])) {
                                    $stmt = $conn->prepare("UPDATE subjects SET subject_name = ? WHERE subject_id = ?");
                                    $stmt->execute([$subjectName, $subjectId]);
                                }
                            }
                        }
                        if (!$subjectId && !empty($subjectName)) {
                            $stmt = $conn->prepare("SELECT subject_id, subject_code FROM subjects WHERE subject_name = ? LIMIT 1");
                            $stmt->execute([$subjectName]);
                            $existingByName = $stmt->fetch(PDO::FETCH_ASSOC);
                            if ($existingByName) {
                                $subjectId = $existingByName['subject_id'];
                                if (!empty($subjectCode) && $existingByName['subject_code'] !== $subjectCode) {
                                    $stmt = $conn->prepare("UPDATE subjects SET subject_code = ? WHERE subject_id = ?");
                                    $stmt->execute([$subjectCode, $subjectId]);
                                }
                            }
                        }
                        if (!$subjectId) {
                            if (empty($subjectName)) { throw new Exception('Cannot create subject without name'); }
                            $stmt = $conn->prepare("INSERT INTO subjects (subject_name, subject_code) VALUES (?, ?)");
                            $stmt->execute([$subjectName, $subjectCode]);
                            $subjectId = $conn->lastInsertId();
                        }
                        if (!$subjectId) { throw new Exception("Failed to get or create subject for: '$subjectName' / '$subjectCode'"); }
                        $averageGrade = 0;
                        if ($takers > 0) {
                            $averageGrade = (($nmsCount * 12.5) + ($ptsCount * 37.5) + ($mpCount * 62.5) + ($ehpCount * 87.5)) / $takers;
                        }
                        $status = 'Poor';
                        if ($passRate >= 75) $status = 'Excellent';
                        elseif ($passRate >= 50) $status = 'Good';
                        elseif ($passRate >= 25) $status = 'Fair';
                        $stmt = $conn->prepare("INSERT INTO subject_summaries (subject_id, period_id, academic_session_id, year_level_id, total_takers, nms_count, nms_percentage, pts_count, pts_percentage, mp_count, mp_percentage, ehp_count, ehp_percentage, pass_rate, average_grade, performance_status, color_indicator) VALUES (?, NULL, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?) ON DUPLICATE KEY UPDATE total_takers = VALUES(total_takers), nms_count = VALUES(nms_count), nms_percentage = VALUES(nms_percentage), pts_count = VALUES(pts_count), pts_percentage = VALUES(pts_percentage), mp_count = VALUES(mp_count), mp_percentage = VALUES(mp_percentage), ehp_count = VALUES(ehp_count), ehp_percentage = VALUES(ehp_percentage), pass_rate = VALUES(pass_rate), average_grade = VALUES(average_grade), performance_status = VALUES(performance_status), color_indicator = VALUES(color_indicator)");
                        $stmt->execute([$subjectId, $academicSessionId, $yearLevelId, $takers, $nmsCount, $nmsPercent, $ptsCount, $ptsPercent, $mpCount, $mpPercent, $ehpCount, $ehpPercent, $passRate, $averageGrade, $status, $colorIndicator]);
                        $periodColumns = ['P1', 'P2', 'P3', 'P4', 'P5'];
                        foreach ($periodColumns as $periodCol) {
                            $periodGrade = getColumnValue($row, [$periodCol], 'float');
                            if ($periodGrade > 0) {
                                $stmt = $conn->prepare("SELECT period_id FROM tbl_period WHERE period_name = ? LIMIT 1");
                                $stmt->execute([$periodCol]);
                                $foundPeriodId = $stmt->fetchColumn();
                                if ($foundPeriodId) {
                                    $stmt = $conn->prepare("INSERT INTO subject_grades_per_period (academic_session_id, subject_id, period_id, subject_avg_grade) VALUES (?, ?, ?, ?) ON DUPLICATE KEY UPDATE subject_avg_grade = VALUES(subject_avg_grade)");
                                    $stmt->execute([$academicSessionId, $subjectId, $foundPeriodId, $periodGrade]);
                                }
                            }
                        }
                        $recordsProcessed++;
                    } catch (Exception $e) {
                        $errorMsg = "Row " . ($index + 1) . ": " . $e->getMessage();
                        if (count($errors) < 10) { $errors[] = $errorMsg; }
                        $recordsSkipped++;
                    }
                }
                $conn->commit();
                $columnInfo = [];
                if (count($data) > 0) { $columnInfo = array_keys($data[0]); }
                echo json_encode(['status' => 'success', 'message' => 'Subject summary data saved successfully', 'records_processed' => $recordsProcessed, 'records_skipped' => $recordsSkipped, 'errors' => $errors, 'columns_found' => $columnInfo, 'debug' => count($errors) > 0 || $recordsSkipped > 0]);
                break;
            default:
                throw new Exception('Invalid operation');
        }
    }
} catch (Exception $e) {
    if (isset($conn) && $conn->inTransaction()) { $conn->rollBack(); }
    echo json_encode(['status' => 'error', 'message' => $e->getMessage()]);
}
?>
