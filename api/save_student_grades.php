<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    exit(0);
}

require_once 'connection-pdo.php';

// Helper function to find column value with flexible matching
function getColumnValue($row, $possibleNames, $type = 'string') {
    foreach ($possibleNames as $name) {
        if (isset($row[$name]) && $row[$name] !== '') {
            $value = $row[$name];
            
            // Skip Excel error values
            if (is_string($value)) {
                $value = trim($value);
                // Check for common Excel errors
                if (in_array(strtoupper($value), ['#VALUE!', '#REF!', '#DIV/0!', '#N/A', '#NAME?', '#NULL!', '#NUM!'])) {
                    continue; // Skip this cell, try next possible name
                }
            }
            
            if ($type === 'int') return intval($value);
            if ($type === 'float') return floatval($value);
            return $value;
        }
    }
    return $type === 'int' ? 0 : ($type === 'float' ? 0.0 : '');
}

// Helper function to determine category and status from grade
function getCategoryAndStatus($grade) {
    $category = null;
    $status = 'FAIL';
    
    if ($grade >= 75) {
        $category = 'EHP'; // Exceeding/Highly Proficient
        $status = 'PASS';
    } elseif ($grade >= 50) {
        $category = 'MP'; // Meeting/Proficient
        $status = 'PASS';
    } elseif ($grade >= 25) {
        $category = 'PTS'; // Progressing Towards Standard
        $status = 'FAIL';
    } else {
        $category = 'NMS'; // Needs More Support
        $status = 'FAIL';
    }
    
    return ['category' => $category, 'status' => $status];
}

try {
    $operation = $_POST['operation'] ?? '';
    
    if ($operation === 'saveStudentGrades') {
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
        
        $conn->beginTransaction();
        
        $recordsProcessed = 0;
        $recordsSkipped = 0;
        $errors = [];
        
        // Log available columns from first row for debugging
        if (count($data) > 0) {
            $firstRow = $data[0];
            $availableColumns = array_keys($firstRow);
            error_log("=== STUDENT GRADES - Available columns ===");
            error_log(implode(", ", $availableColumns));
            error_log("Academic Session ID: $academicSessionId");
            error_log("Total rows to process: " . count($data));
        }
        
        foreach ($data as $index => $row) {
            try {
                // Extract data from Excel columns using flexible matching
                $studentId = getColumnValue($row, ['STUDENT ID', 'Student ID', 'StudentID', 'ID']);
                $studentName = getColumnValue($row, ['NAME', 'Name', 'Student Name', 'STUDENT NAME']);
                $college = getColumnValue($row, ['COLLEGE', 'College']);
                $course = getColumnValue($row, ['COURSE', 'Course', 'Program', 'PROGRAM']);
                $semester = getColumnValue($row, ['SEMESTER', 'Semester', 'SESSION', 'Session']);
                $subjectCode = getColumnValue($row, ['CODE', 'Code', 'SUBJECT CODE', 'Subject Code']);
                $subjectName = getColumnValue($row, ['SUBJECT NAME', 'Subject Name', 'Subject', 'SUBJECT']);
                
                // Get period grades (P1, P2, P3, P4, etc.) - check all possible period columns
                $periodGrades = [];
                foreach ($row as $colName => $colValue) {
                    // Skip empty columns and ignored columns
                    if (strpos($colName, '__EMPTY') !== false) continue;
                    if (in_array(strtoupper($colName), ['CATEGORIZATION', 'REMARKS', 'CATEGORY', 'STATUS'])) continue;
                    
                    // Check if column is a period column (P1, P2, P3, etc.)
                    if (preg_match('/^P\d+$/i', $colName)) {
                        $grade = floatval($colValue);
                        if ($grade > 0) {
                            $periodGrades[strtoupper($colName)] = $grade;
                        }
                    }
                }
                
                // Log extracted data for first few rows
                if ($index < 3) {
                    error_log("Row $index - Student: '$studentId' - '$studentName', College: '$college', Course: '$course'");
                    error_log("Row $index - Subject: '$subjectCode' - '$subjectName'");
                    error_log("Row $index - Semester: '$semester', Periods found: " . json_encode(array_keys($periodGrades)));
                }
                
                // Validate required fields
                if (empty($studentId) || empty($studentName)) {
                    if (count($errors) < 10) {
                        $errors[] = "Row " . ($index + 1) . ": Missing student ID or name";
                    }
                    $recordsSkipped++;
                    continue;
                }
                
                if (empty($subjectName) && empty($subjectCode)) {
                    if (count($errors) < 10) {
                        $errors[] = "Row " . ($index + 1) . ": Missing subject information";
                    }
                    $recordsSkipped++;
                    continue;
                }
                
                // Allow rows without period grades - skip silently (might be summary rows)
                if (empty($periodGrades)) {
                    $recordsSkipped++;
                    continue;
                }
                
                // STEP 1: Insert or update student
                $stmt = $conn->prepare("
                    INSERT INTO students (student_id, name, college, course)
                    VALUES (?, ?, ?, ?)
                    ON DUPLICATE KEY UPDATE
                        name = VALUES(name),
                        college = VALUES(college),
                        course = VALUES(course)
                ");
                $stmt->execute([$studentId, $studentName, $college, $course]);
                
                if ($index < 3) {
                    error_log("Row $index - ✓ Inserted/Updated student: $studentId");
                }
                
                // STEP 2: Find or create subject
                $subjectId = null;
                
                // Priority 1: Try to find by subject_code
                if (!empty($subjectCode)) {
                    $stmt = $conn->prepare("SELECT subject_id FROM subjects WHERE subject_code = ? LIMIT 1");
                    $stmt->execute([$subjectCode]);
                    $subjectId = $stmt->fetchColumn();
                    
                    if ($subjectId && $index < 3) {
                        error_log("Row $index - ✓ Found subject by CODE '$subjectCode' (ID: $subjectId)");
                    }
                }
                
                // Priority 2: Try to find by subject_name if not found by code
                if (!$subjectId && !empty($subjectName)) {
                    $stmt = $conn->prepare("SELECT subject_id FROM subjects WHERE subject_name = ? LIMIT 1");
                    $stmt->execute([$subjectName]);
                    $subjectId = $stmt->fetchColumn();
                    
                    if ($subjectId && $index < 3) {
                        error_log("Row $index - ✓ Found subject by NAME '$subjectName' (ID: $subjectId)");
                    }
                }
                
                // Priority 3: Create new subject if not found
                if (!$subjectId) {
                    $stmt = $conn->prepare("INSERT INTO subjects (subject_code, subject_name) VALUES (?, ?)");
                    $stmt->execute([$subjectCode, $subjectName]);
                    $subjectId = $conn->lastInsertId();
                    
                    if ($index < 3) {
                        error_log("Row $index - ⚠ Created NEW subject (ID: $subjectId) - Code: '$subjectCode', Name: '$subjectName'");
                    }
                }
                
                if (!$subjectId) {
                    throw new Exception("Failed to get or create subject");
                }
                
                // STEP 3: Extract year level from semester string
                // Expected formats: "Year 7", "Y7-2023-2024-S1", "7", etc.
                $yearLevelId = null;
                $yearLevelName = '';
                
                // Try to extract year level from semester
                if (preg_match('/(?:Year\s*)?(\d+)/i', $semester, $matches)) {
                    $yearNum = $matches[1];
                    $yearLevelName = "Year $yearNum";
                } else {
                    // Default to empty if can't parse
                    $yearLevelName = $semester;
                }
                
                // Find or create year level
                if (!empty($yearLevelName)) {
                    $stmt = $conn->prepare("SELECT year_level_id FROM year_levels WHERE year_level_name = ? LIMIT 1");
                    $stmt->execute([$yearLevelName]);
                    $yearLevelId = $stmt->fetchColumn();
                    
                    if (!$yearLevelId) {
                        $stmt = $conn->prepare("INSERT INTO year_levels (year_level_name) VALUES (?)");
                        $stmt->execute([$yearLevelName]);
                        $yearLevelId = $conn->lastInsertId();
                        
                        if ($index < 3) {
                            error_log("Row $index - ⚠ Created NEW year level '$yearLevelName' (ID: $yearLevelId)");
                        }
                    } else if ($index < 3) {
                        error_log("Row $index - ✓ Found year level '$yearLevelName' (ID: $yearLevelId)");
                    }
                }
                
                if (!$yearLevelId) {
                    throw new Exception("Failed to get or create year level from: '$semester'");
                }
                
                // STEP 4: Insert grades for each period
                foreach ($periodGrades as $periodName => $gradeValue) {
                    // Get period_id
                    $stmt = $conn->prepare("SELECT period_id FROM tbl_period WHERE period_name = ? LIMIT 1");
                    $stmt->execute([$periodName]);
                    $periodId = $stmt->fetchColumn();
                    
                    if (!$periodId) {
                        // Create period if not exists
                        $stmt = $conn->prepare("INSERT INTO tbl_period (period_name) VALUES (?)");
                        $stmt->execute([$periodName]);
                        $periodId = $conn->lastInsertId();
                    }
                    
                    // Calculate category and status
                    $gradeInfo = getCategoryAndStatus($gradeValue);
                    
                    // Insert or update grade
                    $stmt = $conn->prepare("
                        INSERT INTO grades (
                            student_id,
                            subject_id,
                            academic_session_id,
                            year_level_id,
                            period_id,
                            grade,
                            category,
                            status
                        )
                        VALUES (?, ?, ?, ?, ?, ?, ?, ?)
                        ON DUPLICATE KEY UPDATE
                            grade = VALUES(grade),
                            category = VALUES(category),
                            status = VALUES(status)
                    ");
                    
                    $stmt->execute([
                        $studentId,
                        $subjectId,
                        $academicSessionId,
                        $yearLevelId,
                        $periodId,
                        $gradeValue,
                        $gradeInfo['category'],
                        $gradeInfo['status']
                    ]);
                    
                    if ($index < 3) {
                        error_log("Row $index - ✓ Inserted grade: Student $studentId, Subject $subjectId, $periodName = $gradeValue ({$gradeInfo['category']}, {$gradeInfo['status']})");
                    }
                }
                
                $recordsProcessed++;
                
            } catch (Exception $e) {
                $errorMsg = "Row " . ($index + 1) . ": " . $e->getMessage();
                if (count($errors) < 10) {
                    $errors[] = $errorMsg;
                }
                error_log("ERROR - " . $errorMsg);
                if ($index < 3) {
                    error_log("ERROR - Row data: " . json_encode($row));
                }
                $recordsSkipped++;
            }
        }
        
        $conn->commit();
        
        // Get column info for response
        $columnInfo = [];
        if (count($data) > 0) {
            $columnInfo = array_keys($data[0]);
        }
        
        echo json_encode([
            'status' => 'success',
            'message' => 'Student grades saved successfully',
            'records_processed' => $recordsProcessed,
            'records_skipped' => $recordsSkipped,
            'errors' => $errors,
            'columns_found' => $columnInfo,
            'debug' => count($errors) > 0 || $recordsSkipped > 0
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
