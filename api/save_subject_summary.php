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

try {
    $operation = $_POST['operation'] ?? '';
    
    if ($operation === 'saveSubjectSummary') {
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
            error_log("=== SUBJECT LEVEL DATA - Available columns ===");
            error_log(implode(", ", $availableColumns));
            error_log("Academic Session ID: $academicSessionId");
            error_log("Total rows to process: " . count($data));
        }
        
        foreach ($data as $index => $row) {
            try {
                // Extract data from Excel columns using flexible matching
                $subjectCode = getColumnValue($row, ['CODE', 'Code', 'SUBJECT CODE', 'Subject Code']);
                $subjectName = getColumnValue($row, ['SUBJECT NAME', 'Subject Name', 'Subject', 'SUBJECT']);
                $yearLevelName = getColumnValue($row, ['SEMESTER', 'Semester', 'Year Level', 'YEAR LEVEL', 'YearLevel']);
                $takers = getColumnValue($row, ['Takers', 'TAKERS', 'Total Takers'], 'int');
                
                // NMS data - try different column name patterns
                $nmsCount = getColumnValue($row, ['NMS Count', 'NMS_Count', 'NMSCount'], 'int');
                $nmsPercent = getColumnValue($row, ['%', 'NMS %', 'NMS Percentage'], 'float');
                
                // PTS data
                $ptsCount = getColumnValue($row, ['PTS Count', 'PTS_Count', 'PTSCount'], 'int');
                $ptsPercent = getColumnValue($row, ['%_1', 'PTS %', 'PTS Percentage'], 'float');
                
                // MP data  
                $mpCount = getColumnValue($row, ['MP Count', 'MP_Count', 'MPCount'], 'int');
                $mpPercent = getColumnValue($row, ['%_2', 'MP %', 'MP Percentage'], 'float');
                
                // EHP data - handle multiple variations including E/HP, EH/P
                $ehpCount = getColumnValue($row, ['E/HP Count', 'EH/P Count', 'EHP Count', 'EHP_Count', 'EHPCount'], 'int');
                $ehpPercent = getColumnValue($row, ['%_3', 'EHP %', 'E/HP %', 'EH/P %', 'EHP Percentage'], 'float');
                
                // Pass percentage - try TOTAL, PASS%, P1
                $passRate = getColumnValue($row, ['TOTAL', 'Total', 'PASS%', 'Pass%', 'P1', 'Pass Rate'], 'float');
                
                // Categorization/Color indicator (often contains #VALUE! in Excel)
                $colorIndicator = getColumnValue($row, ['CATEGORIZATION', 'Categorization', 'YELLOW', 'Yellow', 'GREEN', 'Green', 'RED', 'Red']);
                
                // Clean color indicator - remove Excel errors if any
                if (!empty($colorIndicator) && strpos(strtoupper($colorIndicator), '#') === 0) {
                    $colorIndicator = ''; // Clear if it's an Excel error
                }
                
                // Calculate takers if not provided (sum of all categories)
                if ($takers == 0) {
                    $takers = $nmsCount + $ptsCount + $mpCount + $ehpCount;
                }
                
                // Log extracted data for first few rows
                if ($index < 3) {
                    error_log("Row $index - Code: '$subjectCode', Name: '$subjectName', Year: '$yearLevelName'");
                    error_log("Row $index - NMS: $nmsCount ($nmsPercent%), PTS: $ptsCount ($ptsPercent%), MP: $mpCount ($mpPercent%), EHP: $ehpCount ($ehpPercent%), Pass: $passRate%, Takers: $takers");
                }
                
                // Validate required fields
                if (empty($subjectName) || empty($yearLevelName)) {
                    if (count($errors) < 10) {
                        $errors[] = "Row " . ($index + 1) . ": Missing subject name or year level";
                    }
                    $recordsSkipped++;
                    continue;
                }
                
                // Make sure subject_name is not actually a code (avoid inserting code as name)
                // If subject_name looks like a code (short, no spaces, mostly uppercase), skip it
                if (strlen($subjectName) < 5 && strtoupper($subjectName) === $subjectName && strpos($subjectName, ' ') === false) {
                    if (count($errors) < 10) {
                        $errors[] = "Row " . ($index + 1) . ": Subject name appears to be a code instead of a full name: '$subjectName'";
                    }
                    $recordsSkipped++;
                    continue;
                }
                
                // STEP 1: Find or create year level
                $yearLevelId = null;
                
                // Try to find existing year level first
                $stmt = $conn->prepare("SELECT year_level_id FROM year_levels WHERE year_level_name = ? LIMIT 1");
                $stmt->execute([$yearLevelName]);
                $yearLevelId = $stmt->fetchColumn();
                
                if ($yearLevelId) {
                    if ($index < 3) {
                        error_log("Row $index - ✓ Found year level '$yearLevelName' (ID: $yearLevelId)");
                    }
                } else {
                    // Create new year level if not found
                    $stmt = $conn->prepare("INSERT INTO year_levels (year_level_name) VALUES (?)");
                    $stmt->execute([$yearLevelName]);
                    $yearLevelId = $conn->lastInsertId();
                    if ($index < 3) {
                        error_log("Row $index - ⚠ Created NEW year level '$yearLevelName' (ID: $yearLevelId)");
                    }
                }
                
                // Verify year_level_id obtained
                if (!$yearLevelId) {
                    throw new Exception("Failed to get or create year level: '$yearLevelName'");
                }
                
                // STEP 2: Find or verify subject exists
                $subjectId = null;
                
                // Priority 1: Try to find by subject_code (most reliable)
                if (!empty($subjectCode)) {
                    $stmt = $conn->prepare("SELECT subject_id, subject_name FROM subjects WHERE subject_code = ? LIMIT 1");
                    $stmt->execute([$subjectCode]);
                    $existingByCode = $stmt->fetch(PDO::FETCH_ASSOC);
                    
                    if ($existingByCode) {
                        $subjectId = $existingByCode['subject_id'];
                        if ($index < 3) {
                            error_log("Row $index - ✓ Found subject by CODE '$subjectCode' (ID: $subjectId, Name: '{$existingByCode['subject_name']}')");
                        }
                        
                        // Update name if current one is better (longer, more descriptive)
                        if (!empty($subjectName) && strlen($subjectName) > strlen($existingByCode['subject_name'])) {
                            $stmt = $conn->prepare("UPDATE subjects SET subject_name = ? WHERE subject_id = ?");
                            $stmt->execute([$subjectName, $subjectId]);
                            if ($index < 3) {
                                error_log("Row $index - Updated subject name to: '$subjectName'");
                            }
                        }
                    }
                }
                
                // Priority 2: Try to find by subject_name if not found by code
                if (!$subjectId && !empty($subjectName)) {
                    $stmt = $conn->prepare("SELECT subject_id, subject_code FROM subjects WHERE subject_name = ? LIMIT 1");
                    $stmt->execute([$subjectName]);
                    $existingByName = $stmt->fetch(PDO::FETCH_ASSOC);
                    
                    if ($existingByName) {
                        $subjectId = $existingByName['subject_id'];
                        if ($index < 3) {
                            error_log("Row $index - ✓ Found subject by NAME '$subjectName' (ID: $subjectId, Code: '{$existingByName['subject_code']}')");
                        }
                        
                        // Update code if provided and different
                        if (!empty($subjectCode) && $existingByName['subject_code'] !== $subjectCode) {
                            $stmt = $conn->prepare("UPDATE subjects SET subject_code = ? WHERE subject_id = ?");
                            $stmt->execute([$subjectCode, $subjectId]);
                            if ($index < 3) {
                                error_log("Row $index - Updated subject code to: '$subjectCode'");
                            }
                        }
                    }
                }
                
                // Priority 3: Create new subject if not found
                if (!$subjectId) {
                    if (empty($subjectName)) {
                        throw new Exception("Cannot create subject without name");
                    }
                    
                    $stmt = $conn->prepare("INSERT INTO subjects (subject_name, subject_code) VALUES (?, ?)");
                    $stmt->execute([$subjectName, $subjectCode]);
                    $subjectId = $conn->lastInsertId();
                    if ($index < 3) {
                        error_log("Row $index - ⚠ Created NEW subject (ID: $subjectId) - Name: '$subjectName', Code: '$subjectCode'");
                    }
                }
                
                // Verify subject_id obtained
                if (!$subjectId) {
                    throw new Exception("Failed to get or create subject for: '$subjectName' / '$subjectCode'");
                }
                
                // Calculate average grade based on category distribution
                $averageGrade = 0;
                if ($takers > 0) {
                    $averageGrade = (
                        ($nmsCount * 12.5) + // NMS = 0-25, avg 12.5
                        ($ptsCount * 37.5) + // PTS = 25-50, avg 37.5
                        ($mpCount * 62.5) +  // MP = 50-75, avg 62.5
                        ($ehpCount * 87.5)   // EHP = 75-100, avg 87.5
                    ) / $takers;
                }
                
                // Determine performance status based on pass rate
                $status = 'Poor';
                if ($passRate >= 75) $status = 'Excellent';
                elseif ($passRate >= 50) $status = 'Good';
                elseif ($passRate >= 25) $status = 'Fair';
                
                // Insert or update subject summary (period_id set to NULL for subject-level aggregates)
                $stmt = $conn->prepare("
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
                    VALUES (?, NULL, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
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
                    $subjectId,
                    $academicSessionId,
                    $yearLevelId,
                    $takers,
                    $nmsCount,
                    $nmsPercent,
                    $ptsCount,
                    $ptsPercent,
                    $mpCount,
                    $mpPercent,
                    $ehpCount,
                    $ehpPercent,
                    $passRate,
                    $averageGrade,
                    $status,
                    $colorIndicator
                ]);
                
                // Confirm success
                if ($index < 3) {
                    error_log("Row $index - ✓ SUCCESS: Inserted/Updated subject_summaries");
                    error_log("Row $index -   Subject ID: $subjectId, Year Level ID: $yearLevelId");
                    error_log("Row $index -   Takers: $takers, Pass Rate: $passRate%, Status: $status");
                }
                
                // Handle multiple period columns (P1, P2, P3, P4, etc.)
                // Check for period grade columns in the Excel data
                $periodColumns = ['P1', 'P2', 'P3', 'P4', 'P5'];
                
                foreach ($periodColumns as $periodCol) {
                    $periodGrade = getColumnValue($row, [$periodCol], 'float');
                    
                    if ($periodGrade > 0) {
                        // Get period_id from tbl_period based on period name
                        $stmt = $conn->prepare("SELECT period_id FROM tbl_period WHERE period_name = ? LIMIT 1");
                        $stmt->execute([$periodCol]);
                        $foundPeriodId = $stmt->fetchColumn();
                        
                        if ($foundPeriodId) {
                            // Insert or update period grade
                            $stmt = $conn->prepare("
                                INSERT INTO subject_grades_per_period (
                                    academic_session_id,
                                    subject_id,
                                    period_id,
                                    subject_avg_grade
                                )
                                VALUES (?, ?, ?, ?)
                                ON DUPLICATE KEY UPDATE
                                    subject_avg_grade = VALUES(subject_avg_grade)
                            ");
                            $stmt->execute([
                                $academicSessionId,
                                $subjectId,
                                $foundPeriodId,
                                $periodGrade
                            ]);
                        }
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
            'message' => 'Subject summary data saved successfully',
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
