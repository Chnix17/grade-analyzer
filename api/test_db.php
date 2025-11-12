<?php
require_once 'connection-pdo.php';

echo "=== Testing Database ===\n\n";

// Check school_years
$stmt = $conn->query("SELECT * FROM school_years");
$schoolYears = $stmt->fetchAll(PDO::FETCH_ASSOC);
echo "School Years: " . count($schoolYears) . " rows\n";
print_r($schoolYears);

echo "\n";

// Check semesters
$stmt = $conn->query("SELECT * FROM semesters");
$semesters = $stmt->fetchAll(PDO::FETCH_ASSOC);
echo "Semesters: " . count($semesters) . " rows\n";
print_r($semesters);

echo "\n";

// Check academic_sessions
$stmt = $conn->query("SELECT * FROM academic_sessions");
$sessions = $stmt->fetchAll(PDO::FETCH_ASSOC);
echo "Academic Sessions: " . count($sessions) . " rows\n";
print_r($sessions);

echo "\n";

// Check subject_summaries
$stmt = $conn->query("SELECT COUNT(*) as count FROM subject_summaries");
$count = $stmt->fetch(PDO::FETCH_ASSOC);
echo "Subject Summaries: " . $count['count'] . " rows\n";
?>
