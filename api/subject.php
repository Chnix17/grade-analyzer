<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    exit(0);
}

require_once 'connection-pdo.php';

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

// API Endpoint Handler
try {
    $operation = $_POST['operation'] ?? '';
    
    if ($operation === 'processSubjectRawSheet') {
        $json = $_POST['json'] ?? '';
        $academicSessionId = $_POST['academic_session_id'] ?? '';
        
        if (empty($json)) {
            throw new Exception('Missing required data');
        }
        
        if (empty($academicSessionId)) {
            throw new Exception('Please select School Year and Semester before uploading');
        }
        
        $data = json_decode($json, true);
        if (!is_array($data)) {
            throw new Exception('Invalid data format');
        }
        
        // Use the SubjectProcessor class
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
    } else {
        throw new Exception('Invalid operation');
    }
    
} catch (Exception $e) {
    if (isset($conn) && $conn->inTransaction()) {
        $conn->rollBack();
    }
    echo json_encode([
        'status' => 'error',
        'message' => $e->getMessage()
    ]);
}
?>
