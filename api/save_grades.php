<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    exit(0);
}

require_once 'connection-pdo.php';

function getCategoryFromGrade($grade) {
    $g = floatval($grade);
    if ($g >= 0 && $g <= 25) return 'NMS';
    if ($g > 25 && $g < 50) return 'PTS';
    if ($g >= 50 && $g < 75) return 'MP';
    if ($g >= 75 && $g <= 100) return 'EHP';
    return null;
}

function getStatusFromGrade($grade) {
    $g = floatval($grade);
    return ($g >= 50) ? 'PASS' : 'FAIL';
}

function parseSemesterString($semesterString) {
    // Expected format: Y7-2023-2024-S1
    // Returns: ['year_level' => 'Year 7', 'school_year' => '2023-2024', 'semester' => '1st Semester']
    if (empty($semesterString)) return null;
    
    $s = strtoupper(trim($semesterString));
    $result = [
        'year_level' => null,
        'school_year' => null,
        'semester' => null
    ];
    
    // Extract year level (Y7, Y8, etc.)
    if (preg_match('/Y(\d+)/', $s, $matches)) {
        $result['year_level'] = 'Year ' . $matches[1];
    }
    
    // Extract school year (2023-2024, etc.)
    if (preg_match('/(\d{4})-(\d{4})/', $s, $matches)) {
        $result['school_year'] = $matches[1] . '-' . $matches[2];
    }
    
    // Extract semester (S1, S2, etc.)
    if (preg_match('/S(\d+)/', $s, $matches)) {
        $semNum = $matches[1];
        $result['semester'] = $semNum . 'st Semester';
        if ($semNum == '2') $result['semester'] = '2nd Semester';
        else if ($semNum == '3') $result['semester'] = '3rd Semester';
        else if ($semNum > 3) $result['semester'] = $semNum . 'th Semester';
    }
    
    return $result;
}

try {
    $operation = $_POST['operation'] ?? '';
    
    if ($operation === 'saveGrades') {
        $jsonData = $_POST['json'] ?? '';
        $filename = $_POST['filename'] ?? 'unknown';
        $academicSessionId = $_POST['academic_session_id'] ?? '';
        
        if (empty($jsonData)) {
            throw new Exception('No data provided');
        }
        
        if (empty($academicSessionId)) {
            throw new Exception('Academic session must be selected');
        }
        
        // Verify academic session exists
        $stmt = $conn->prepare("SELECT academic_session_id FROM academic_sessions WHERE academic_session_id = ?");
        $stmt->execute([$academicSessionId]);
        if (!$stmt->fetch()) {
            throw new Exception('Invalid academic session');
        }
        
        $data = json_decode($jsonData, true);
        if (!$data || !is_array($data)) {
            throw new Exception('Invalid JSON data');
        }
        
        $conn->beginTransaction();
        
        $recordsProcessed = 0;
        $recordsSkipped = 0;
        $errors = [];
        
        foreach ($data as $index => $row) {
            try {
                // Extract and validate data
                $studentId = trim($row['STUDENT ID'] ?? '');
                $studentName = trim($row['NAME'] ?? '');
                $subjectName = trim($row['SUBJECT NAME'] ?? '');
                
                // Check if P1 column exists and get the grade
                $grade = 0;
                $periodId = null;
                if (isset($row['P1'])) {
                    $grade = floatval($row['P1']);
                    // Look up period_id for P1
                    $stmt = $conn->prepare("SELECT period_id FROM tbl_period WHERE period_name = ?");
                    $stmt->execute(['P1']);
                    $periodId = $stmt->fetchColumn();
                }
                
                // Try to get year level from YEAR LEVEL column or SEMESTER column
                $yearLevelName = trim($row['YEAR LEVEL'] ?? '');
                
                // If YEAR LEVEL is empty, try to extract from SEMESTER column (legacy format)
                if (empty($yearLevelName)) {
                    $semester = trim($row['SEMESTER'] ?? '');
                    if (!empty($semester)) {
                        // Extract year level from format like "Y7-2023-2024-S1"
                        if (preg_match('/Y(\d+)/', strtoupper($semester), $matches)) {
                            $yearLevelName = 'Year ' . $matches[1];
                        }
                    }
                }
                
                // Validate required fields
                if (empty($studentId) || empty($studentName) || empty($subjectName)) {
                    if (count($errors) < 10) {
                        $errors[] = "Row " . ($index + 1) . ": Missing required field (STUDENT ID, NAME, or SUBJECT NAME)";
                    }
                    $recordsSkipped++;
                    continue;
                }
                
                if (empty($yearLevelName)) {
                    if (count($errors) < 10) {
                        $errors[] = "Row " . ($index + 1) . ": Missing YEAR LEVEL (add YEAR LEVEL column or SEMESTER column)";
                    }
                    $recordsSkipped++;
                    continue;
                }
                
                // Insert or get year level
                $stmt = $conn->prepare("INSERT INTO year_levels (year_level_name) VALUES (?) ON DUPLICATE KEY UPDATE year_level_id = LAST_INSERT_ID(year_level_id)");
                $stmt->execute([$yearLevelName]);
                $yearLevelId = $conn->lastInsertId();
                if ($yearLevelId == 0) {
                    $stmt = $conn->prepare("SELECT year_level_id FROM year_levels WHERE year_level_name = ?");
                    $stmt->execute([$yearLevelName]);
                    $yearLevelId = $stmt->fetchColumn();
                }
                
                // Insert or get student
                $stmt = $conn->prepare("INSERT INTO students (student_id, name) VALUES (?, ?) ON DUPLICATE KEY UPDATE name = VALUES(name)");
                $stmt->execute([$studentId, $studentName]);
                
                // Insert or get subject
                $stmt = $conn->prepare("INSERT INTO subjects (subject_name) VALUES (?) ON DUPLICATE KEY UPDATE subject_id = LAST_INSERT_ID(subject_id)");
                $stmt->execute([$subjectName]);
                $subjectId = $conn->lastInsertId();
                if ($subjectId == 0) {
                    $stmt = $conn->prepare("SELECT subject_id FROM subjects WHERE subject_name = ?");
                    $stmt->execute([$subjectName]);
                    $subjectId = $stmt->fetchColumn();
                }
                
                // Calculate grade category and status
                $category = getCategoryFromGrade($grade);
                $status = getStatusFromGrade($grade);
                
                // Insert or update grade using the selected academic session and year level
                $stmt = $conn->prepare("
                    INSERT INTO grades (student_id, subject_id, academic_session_id, year_level_id, period_id, grade, category, status)
                    VALUES (?, ?, ?, ?, ?, ?, ?, ?)
                    ON DUPLICATE KEY UPDATE 
                        grade = VALUES(grade),
                        category = VALUES(category),
                        status = VALUES(status),
                        period_id = VALUES(period_id)
                ");
                $stmt->execute([$studentId, $subjectId, $academicSessionId, $yearLevelId, $periodId, $grade, $category, $status]);
                
                $recordsProcessed++;
                
            } catch (Exception $e) {
                if (count($errors) < 10) {
                    $errors[] = "Row " . ($index + 1) . ": " . $e->getMessage();
                }
                $recordsSkipped++;
            }
        }
        
        // Add summary if there are more errors
        if ($recordsSkipped > count($errors)) {
            $errors[] = "... and " . ($recordsSkipped - count($errors)) . " more errors. First 10 shown above.";
        }
        
        // Log upload
        $stmt = $conn->prepare("INSERT INTO upload_logs (filename, records_count, status, notes) VALUES (?, ?, 'SUCCESS', ?)");
        $stmt->execute([$filename, $recordsProcessed, "Processed: $recordsProcessed, Skipped: $recordsSkipped"]);
        $uploadId = $conn->lastInsertId();
        
        $conn->commit();
        
        // Build helpful message
        $message = 'Data saved to database successfully';
        if ($recordsSkipped > 0 && $recordsProcessed == 0) {
            $message = 'All records were skipped. Check errors below for details.';
        } elseif ($recordsSkipped > 0) {
            $message = "Partial success: $recordsProcessed records saved, $recordsSkipped skipped.";
        }
        
        echo json_encode([
            'status' => 'success',
            'message' => $message,
            'upload_id' => $uploadId,
            'records_processed' => $recordsProcessed,
            'records_skipped' => $recordsSkipped,
            'total_rows' => count($data),
            'errors' => $errors
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
