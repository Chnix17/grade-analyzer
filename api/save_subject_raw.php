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
    
    if ($operation === 'saveSubjectRaw') {
        $json = $_POST['json'] ?? '';
        
        if (empty($json)) {
            throw new Exception('Missing required data');
        }
        
        $data = json_decode($json, true);
        if (!is_array($data)) {
            throw new Exception('Invalid data format');
        }
        
        $conn->beginTransaction();
        
        $recordsProcessed = 0;
        $recordsSkipped = 0;
        $errors = [];
        
        // Log available columns from first row
        if (count($data) > 0) {
            $firstRow = $data[0];
            $availableColumns = array_keys($firstRow);
            error_log("SUBJECT RAW - Available columns: " . implode(", ", $availableColumns));
        }
        
        foreach ($data as $index => $row) {
            try {
                // Extract subject code and name
                $subjectCode = getColumnValue($row, ['subject_code', 'SUBJECT CODE', 'Subject Code', 'CODE', 'Code']);
                $subjectName = getColumnValue($row, ['subject_name', 'SUBJECT NAME', 'Subject Name', 'SUBJECT', 'Subject']);
                
                // Validate required fields
                if (empty($subjectCode) && empty($subjectName)) {
                    $recordsSkipped++;
                    continue;
                }
                
                // Skip if subject_name looks like a code
                if (!empty($subjectName) && strlen($subjectName) < 5 && strtoupper($subjectName) === $subjectName && strpos($subjectName, ' ') === false) {
                    if (count($errors) < 10) {
                        $errors[] = "Row " . ($index + 1) . ": Subject name appears to be a code: '$subjectName'";
                    }
                    $recordsSkipped++;
                    continue;
                }
                
                // Check if subject exists by code or name
                $subjectId = null;
                
                if (!empty($subjectName)) {
                    $stmt = $conn->prepare("SELECT subject_id, subject_code FROM subjects WHERE subject_name = ? LIMIT 1");
                    $stmt->execute([$subjectName]);
                    $existing = $stmt->fetch(PDO::FETCH_ASSOC);
                    
                    if ($existing) {
                        $subjectId = $existing['subject_id'];
                        // Update code if different
                        if (!empty($subjectCode) && $existing['subject_code'] !== $subjectCode) {
                            $stmt = $conn->prepare("UPDATE subjects SET subject_code = ? WHERE subject_id = ?");
                            $stmt->execute([$subjectCode, $subjectId]);
                        }
                    }
                }
                
                if (!$subjectId && !empty($subjectCode)) {
                    $stmt = $conn->prepare("SELECT subject_id, subject_name FROM subjects WHERE subject_code = ? LIMIT 1");
                    $stmt->execute([$subjectCode]);
                    $existing = $stmt->fetch(PDO::FETCH_ASSOC);
                    
                    if ($existing) {
                        $subjectId = $existing['subject_id'];
                        // Update name if new one is longer
                        if (!empty($subjectName) && strlen($subjectName) > strlen($existing['subject_name'])) {
                            $stmt = $conn->prepare("UPDATE subjects SET subject_name = ? WHERE subject_id = ?");
                            $stmt->execute([$subjectName, $subjectId]);
                        }
                    }
                }
                
                // Insert new subject if not found
                if (!$subjectId) {
                    $stmt = $conn->prepare("INSERT INTO subjects (subject_name, subject_code) VALUES (?, ?)");
                    $stmt->execute([$subjectName, $subjectCode]);
                    $subjectId = $conn->lastInsertId();
                }
                
                $recordsProcessed++;
                
            } catch (Exception $e) {
                if (count($errors) < 10) {
                    $errors[] = "Row " . ($index + 1) . ": " . $e->getMessage();
                }
                $recordsSkipped++;
            }
        }
        
        $conn->commit();
        
        echo json_encode([
            'status' => 'success',
            'message' => 'Subject raw data saved successfully',
            'records_processed' => $recordsProcessed,
            'records_skipped' => $recordsSkipped,
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
