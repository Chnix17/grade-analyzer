<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    exit(0);
}

require_once 'connection-pdo.php';

function ensure_tables($conn) {
    $conn->exec("CREATE TABLE IF NOT EXISTS deliberation_uploads (
        upload_id INT AUTO_INCREMENT PRIMARY KEY,
        academic_session_id INT NOT NULL,
        period_id INT NULL,
        file_name VARCHAR(255) NOT NULL,
        uploaded_by VARCHAR(100) NULL,
        uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4");

    $conn->exec("CREATE TABLE IF NOT EXISTS subject_deliberations (
        deliberation_id INT AUTO_INCREMENT PRIMARY KEY,
        upload_id INT NOT NULL,
        academic_session_id INT NOT NULL,
        year_level_id INT NOT NULL,
        period_id INT NULL,
        subject_id INT NOT NULL,
        student_id VARCHAR(50) NOT NULL,
        raw_score DECIMAL(6,2) NULL,
        grade DECIMAL(5,2) NULL,
        categorization VARCHAR(255) NULL,
        status ENUM('PASS','FAIL') NULL,
        decision ENUM('PROMOTE','RETAIN','REMEDIATION') NULL,
        remarks VARCHAR(500) NULL,
        metadata JSON NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        UNIQUE KEY uniq_row (academic_session_id, subject_id, student_id, period_id)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4");
}

try {
    if (($_POST['operation'] ?? '') !== 'saveDeliberations') {
        throw new Exception('Invalid operation');
    }

    ensure_tables($conn);

    $json = $_POST['json'] ?? '';
    $filename = $_POST['filename'] ?? '';
    $academicSessionId = intval($_POST['academic_session_id'] ?? 0);
    $periodId = isset($_POST['period_id']) && $_POST['period_id'] !== '' ? intval($_POST['period_id']) : null;

    if (empty($json) || !$academicSessionId) {
        throw new Exception('Missing payload or academic_session_id');
    }

    $rows = json_decode($json, true);
    if (!is_array($rows)) {
        throw new Exception('Invalid JSON payload');
    }

    // Create upload batch
    $stmt = $conn->prepare("INSERT INTO deliberation_uploads (academic_session_id, period_id, file_name) VALUES (?, ?, ?)");
    $stmt->execute([$academicSessionId, $periodId, $filename]);
    $uploadId = intval($conn->lastInsertId());

    // Prepared statements
    $resolveSubjectStmt = $conn->prepare("SELECT subject_id FROM subjects WHERE subject_code = ? LIMIT 1");
    $createSubjectStmt = $conn->prepare("INSERT INTO subjects (subject_code, subject_name) VALUES (?, ?)");
    $resolveYearLevelStmt = $conn->prepare("SELECT year_level_id FROM year_levels WHERE year_level_id = ? OR year_level_name = ? LIMIT 1");

    $upsert = $conn->prepare("INSERT INTO subject_deliberations (
            upload_id, academic_session_id, year_level_id, period_id, subject_id, student_id, raw_score, grade, categorization, status, decision, remarks, metadata
        ) VALUES (
            :upload_id, :academic_session_id, :year_level_id, :period_id, :subject_id, :student_id, :raw_score, :grade, :categorization, :status, :decision, :remarks, :metadata
        ) ON DUPLICATE KEY UPDATE 
            upload_id = VALUES(upload_id),
            year_level_id = VALUES(year_level_id),
            raw_score = VALUES(raw_score),
            grade = VALUES(grade),
            categorization = VALUES(categorization),
            status = VALUES(status),
            decision = VALUES(decision),
            remarks = VALUES(remarks),
            metadata = VALUES(metadata)");

    $errors = [];
    $saved = 0;

    foreach ($rows as $index => $r) {
        $studentId = trim((string)($r['student_id'] ?? ''));
        $subjectKey = $r['subject_id'] ?? ($r['subject_code'] ?? null);
        $yearLevelKey = $r['year_level_id'] ?? ($r['year_level'] ?? null);

        if ($studentId === '' || $subjectKey === null || $yearLevelKey === null) {
            $errors[] = [ 'row' => $index, 'reason' => 'Missing required fields (student_id, subject, year_level)' ];
            continue;
        }

        // Extract year level from format like "Y3S1" -> "Y3"
        $yearLevelExtracted = $yearLevelKey;
        if (preg_match('/^(Y\d+)S\d+$/i', $yearLevelKey, $matches)) {
            $yearLevelExtracted = strtoupper($matches[1]);
        }

        // Resolve subject_id by subject_code (auto-create if not found)
        $resolveSubjectStmt->execute([$subjectKey]);
        $subject = $resolveSubjectStmt->fetch(PDO::FETCH_ASSOC);
        if (!$subject) {
            $placeholderName = "Subject: " . $subjectKey;
            $createSubjectStmt->execute([$subjectKey, $placeholderName]);
            $subjectId = intval($conn->lastInsertId());
        } else {
            $subjectId = intval($subject['subject_id']);
        }

        // Resolve year_level_id
        $resolveYearLevelStmt->execute([$yearLevelExtracted, $yearLevelExtracted]);
        $yl = $resolveYearLevelStmt->fetch(PDO::FETCH_ASSOC);
        if (!$yl) {
            $errors[] = [ 'row' => $index, 'reason' => 'Unknown year level', 'value' => $yearLevelExtracted ];
            continue;
        }
        $yearLevelId = intval($yl['year_level_id']);

        $rawScore = isset($r['raw_score']) && $r['raw_score'] !== '' ? $r['raw_score'] : null;
        $grade = isset($r['grade']) && $r['grade'] !== '' ? $r['grade'] : null;
        $categorization = isset($r['categorization']) && $r['categorization'] !== '' ? substr((string)$r['categorization'], 0, 255) : null;
        $status = isset($r['status']) && $r['status'] !== '' ? strtoupper($r['status']) : null;
        $decision = isset($r['decision']) && $r['decision'] !== '' ? strtoupper($r['decision']) : null;
        $remarks = isset($r['remarks']) ? substr((string)$r['remarks'], 0, 500) : null;
        $metadata = isset($r['metadata']) ? json_encode($r['metadata']) : null;

        // Use period_id from row data if present, otherwise use global periodId
        $rowPeriodId = isset($r['_period_id']) && $r['_period_id'] !== '' ? intval($r['_period_id']) : $periodId;

        // Normalize enums
        if ($status !== null && !in_array($status, ['PASS','FAIL'])) {
            $errors[] = [ 'row' => $index, 'reason' => 'Invalid status enum', 'value' => $status ];
            continue;
        }
        if ($decision !== null && !in_array($decision, ['PROMOTE','RETAIN','REMEDIATION'])) {
            $errors[] = [ 'row' => $index, 'reason' => 'Invalid decision enum', 'value' => $decision ];
            continue;
        }

        $upsert->execute([
            ':upload_id' => $uploadId,
            ':academic_session_id' => $academicSessionId,
            ':year_level_id' => $yearLevelId,
            ':period_id' => $rowPeriodId,
            ':subject_id' => $subjectId,
            ':student_id' => $studentId,
            ':raw_score' => $rawScore,
            ':grade' => $grade,
            ':categorization' => $categorization,
            ':status' => $status,
            ':decision' => $decision,
            ':remarks' => $remarks,
            ':metadata' => $metadata
        ]);

        $saved++;
    }

    echo json_encode([
        'status' => 'success',
        'upload_id' => $uploadId,
        'saved' => $saved,
        'errors' => $errors
    ]);
} catch (Exception $e) {
    echo json_encode(['status' => 'error', 'message' => $e->getMessage()]);
}
?>


