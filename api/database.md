# Grade Analyzer - Normalized Database Schema

## Overview
This document describes the normalized database structure for the Grade Analyzer system. The database is designed following normalization principles to eliminate data redundancy and ensure data integrity.

## Database Name
**grade_analyzer_db**

## Database Schema (Normalized)

### 1. **students** Table
Stores unique student information.

| Column | Type | Description | Constraints |
|--------|------|-------------|-------------|
| student_id | VARCHAR(50) | Unique student identifier | PRIMARY KEY |
| name | VARCHAR(255) | Student's full name | NOT NULL |
| created_at | TIMESTAMP | Record creation time | DEFAULT CURRENT_TIMESTAMP |
| updated_at | TIMESTAMP | Record last update time | ON UPDATE CURRENT_TIMESTAMP |

**Indexes:**
- PRIMARY KEY on `student_id`
- INDEX on `name`

---

### 2. **teachers** Table
Stores unique teacher information.

| Column | Type | Description | Constraints |
|--------|------|-------------|-------------|
| teacher_id | INT | Auto-incrementing teacher ID | PRIMARY KEY, AUTO_INCREMENT |
| teacher_name | VARCHAR(255) | Teacher's name | NOT NULL, UNIQUE |
| created_at | TIMESTAMP | Record creation time | DEFAULT CURRENT_TIMESTAMP |
| updated_at | TIMESTAMP | Record last update time | ON UPDATE CURRENT_TIMESTAMP |

**Indexes:**
- PRIMARY KEY on `teacher_id`
- UNIQUE KEY on `teacher_name`
- INDEX on `teacher_name`

---

### 3. **subjects** Table
Stores unique subject information.

| Column | Type | Description | Constraints |
|--------|------|-------------|-------------|
| subject_id | INT | Auto-incrementing subject ID | PRIMARY KEY, AUTO_INCREMENT |
| subject_name | VARCHAR(255) | Subject name | NOT NULL, UNIQUE |
| created_at | TIMESTAMP | Record creation time | DEFAULT CURRENT_TIMESTAMP |
| updated_at | TIMESTAMP | Record last update time | ON UPDATE CURRENT_TIMESTAMP |

**Indexes:**
- PRIMARY KEY on `subject_id`
- UNIQUE KEY on `subject_name`
- INDEX on `subject_name`

---

### 4. **year_levels** Table (Lookup Table)
Stores unique year level information.

| Column | Type | Description | Constraints |
|--------|------|-------------|-------------|
| year_level_id | INT | Auto-incrementing year level ID | PRIMARY KEY, AUTO_INCREMENT |
| year_level_name | VARCHAR(50) | Year level name (e.g., Year 7) | NOT NULL, UNIQUE |
| created_at | TIMESTAMP | Record creation time | DEFAULT CURRENT_TIMESTAMP |
| updated_at | TIMESTAMP | Record last update time | ON UPDATE CURRENT_TIMESTAMP |

**Indexes:**
- PRIMARY KEY on `year_level_id`
- UNIQUE KEY on `year_level_name`
- INDEX on `year_level_name`

---

### 5. **semesters** Table (Lookup Table)
Stores unique semester names only.

| Column | Type | Description | Constraints |
|--------|------|-------------|-------------|
| semester_id | INT | Auto-incrementing semester ID | PRIMARY KEY, AUTO_INCREMENT |
| semester_name | VARCHAR(50) | Semester name (e.g., 1st Semester, 2nd Semester) | NOT NULL, UNIQUE |
| created_at | TIMESTAMP | Record creation time | DEFAULT CURRENT_TIMESTAMP |
| updated_at | TIMESTAMP | Record last update time | ON UPDATE CURRENT_TIMESTAMP |

**Indexes:**
- PRIMARY KEY on `semester_id`
- UNIQUE KEY on `semester_name`
- INDEX on `semester_name`

---

### 6. **school_years** Table (Lookup Table)
Stores unique school year information.

| Column | Type | Description | Constraints |
|--------|------|-------------|-------------|
| school_year_id | INT | Auto-incrementing school year ID | PRIMARY KEY, AUTO_INCREMENT |
| school_year | VARCHAR(50) | School year (e.g., 2023-2024) | NOT NULL, UNIQUE |
| created_at | TIMESTAMP | Record creation time | DEFAULT CURRENT_TIMESTAMP |
| updated_at | TIMESTAMP | Record last update time | ON UPDATE CURRENT_TIMESTAMP |

**Indexes:**
- PRIMARY KEY on `school_year_id`
- UNIQUE KEY on `school_year`
- INDEX on `school_year`

---

### 7. **academic_sessions** Table
Combines school year and semester to form an academic session.

| Column | Type | Description | Constraints |
|--------|------|-------------|-------------|
| academic_session_id | INT | Auto-incrementing academic session ID | PRIMARY KEY, AUTO_INCREMENT |
| school_year_id | INT | Reference to school year | FOREIGN KEY → school_years(school_year_id) |
| semester_id | INT | Reference to semester | FOREIGN KEY → semesters(semester_id) |
| created_at | TIMESTAMP | Record creation time | DEFAULT CURRENT_TIMESTAMP |
| updated_at | TIMESTAMP | Record last update time | ON UPDATE CURRENT_TIMESTAMP |

**Indexes:**
- PRIMARY KEY on `academic_session_id`
- UNIQUE KEY on (`school_year_id`, `semester_id`)
- INDEX on `school_year_id`
- INDEX on `semester_id`

**Foreign Keys:**
- CASCADE on DELETE and UPDATE for all references

---

### 8. **grades** Table (Main Transaction Table)
Stores grade records linking all entities.

| Column | Type | Description | Constraints |
|--------|------|-------------|-------------|
| grade_id | INT | Auto-incrementing grade record ID | PRIMARY KEY, AUTO_INCREMENT |
| student_id | VARCHAR(50) | Reference to student | FOREIGN KEY → students(student_id) |
| subject_id | INT | Reference to subject | FOREIGN KEY → subjects(subject_id) |
| teacher_id | INT | Reference to teacher | FOREIGN KEY → teachers(teacher_id) |
| academic_session_id | INT | Reference to academic session | FOREIGN KEY → academic_sessions(academic_session_id) |
| year_level_id | INT | Reference to year level | FOREIGN KEY → year_levels(year_level_id) |
| grade | DECIMAL(5,2) | Numerical grade (0-100) | NOT NULL |
| category | ENUM | Grade category | 'NMS', 'PTS', 'MP', 'EHP' |
| status | ENUM | Pass/Fail status | 'PASS', 'FAIL' |
| created_at | TIMESTAMP | Record creation time | DEFAULT CURRENT_TIMESTAMP |
| updated_at | TIMESTAMP | Record last update time | ON UPDATE CURRENT_TIMESTAMP |

**Grade Categories:**
- **NMS** (Needs More Support): 0-25
- **PTS** (Progressing Towards Standard): 25-50
- **MP** (Meeting/Proficient): 50-75
- **EHP** (Exceeding/Highly Proficient): 75-100

**Indexes:**
- PRIMARY KEY on `grade_id`
- INDEX on `student_id`
- INDEX on `subject_id`
- INDEX on `teacher_id`
- INDEX on `academic_session_id`
- INDEX on `year_level_id`
- INDEX on `category`
- INDEX on `status`
- UNIQUE KEY on (`student_id`, `subject_id`, `academic_session_id`, `year_level_id`) to prevent duplicate grade entries

**Foreign Keys:**
- CASCADE on DELETE and UPDATE for all references

---

### 9. **upload_logs** Table
Tracks file upload history and statistics.

| Column | Type | Description | Constraints |
|--------|------|-------------|-------------|
| upload_id | INT | Auto-incrementing upload ID | PRIMARY KEY, AUTO_INCREMENT |
| filename | VARCHAR(255) | Name of uploaded file | NULL |
| records_count | INT | Number of records processed | DEFAULT 0 |
| upload_date | TIMESTAMP | Upload timestamp | DEFAULT CURRENT_TIMESTAMP |
| status | ENUM | Upload status | 'SUCCESS', 'FAILED' |
| notes | TEXT | Additional notes or error messages | NULL |

---

## Normalization Benefits

### 1st Normal Form (1NF)
✓ All columns contain atomic values
✓ Each column contains values of a single type
✓ Each column has a unique name
✓ Order of data storage doesn't matter

### 2nd Normal Form (2NF)
✓ Meets 1NF requirements
✓ All non-key attributes are fully dependent on the primary key
✓ No partial dependencies exist

### 3rd Normal Form (3NF)
✓ Meets 2NF requirements
✓ No transitive dependencies
✓ All non-key attributes are directly dependent only on the primary key

### Key Advantages:
1. **Eliminates Data Redundancy**: Student names, teacher names, and subject names are stored only once
2. **Ensures Data Integrity**: Foreign key constraints maintain referential integrity
3. **Easier Maintenance**: Updates to student/teacher/subject info only need to happen in one place
4. **Better Performance**: Proper indexing on foreign keys improves query performance
5. **Prevents Anomalies**: Eliminates insertion, update, and deletion anomalies

---

## API Endpoints

### Initialize Database
**Endpoint:** `backend/init_database.php`
**Method:** GET
**Description:** Creates the database and all required tables if they don't exist

**Response:**
```json
{
  "status": "success",
  "message": "All tables created successfully",
  "tables": ["students", "teachers", "subjects", "year_levels", "semesters", "school_years", "academic_sessions", "grades", "upload_logs"]
}
```

---

### Save Grades to Database
**Endpoint:** `backend/save_grades.php`
**Method:** POST
**Description:** Parses Excel data and saves it to the normalized database structure

**Parameters:**
- `operation`: "saveGrades"
- `json`: JSON string of grade data
- `filename`: Name of uploaded file

**Expected Semester Format:** `Y7-2023-2024-S1`
- `Y7`: Year level (e.g., Year 7)
- `2023-2024`: School year
- `S1`: Semester (1st Semester)

**Data Parsing:**
The system automatically parses the semester string and populates:
1. `year_levels` table with year level (e.g., "Year 7")
2. `school_years` table with school year (e.g., "2023-2024")
3. `semesters` table with semester name (e.g., "1st Semester")
4. `academic_sessions` table with the combination of school_year_id and semester_id

**Response:**
```json
{
  "status": "success",
  "message": "Data saved to database successfully",
  "upload_id": 1,
  "records_processed": 150,
  "records_skipped": 5,
  "errors": []
}
```

---

## Setup Instructions

1. **Ensure XAMPP is running** with Apache and MySQL services

2. **Database Configuration** (in `backend/db_config.php`):
   ```php
   DB_HOST: 'localhost'
   DB_USER: 'root'
   DB_PASS: ''
   DB_NAME: 'grade_analyzer_db'
   ```

3. **Initialize Database**:
   - The database is automatically initialized when you upload your first Excel file
   - Or manually access: `http://localhost/grade-analyzer/backend/init_database.php`

4. **Upload Excel File**:
   - Go to the Upload tab in the frontend
   - Select your Excel file
   - Data will be automatically parsed and saved to the normalized database

---

## Sample Queries

### Get all grades for a specific student
```sql
SELECT 
    s.name,
    sub.subject_name,
    t.teacher_name,
    yl.year_level_name,
    sy.school_year,
    sem.semester_name,
    CONCAT(sy.school_year, ' - ', sem.semester_name) as academic_session,
    g.grade,
    g.category,
    g.status
FROM grades g
JOIN students s ON g.student_id = s.student_id
JOIN subjects sub ON g.subject_id = sub.subject_id
JOIN teachers t ON g.teacher_id = t.teacher_id
JOIN year_levels yl ON g.year_level_id = yl.year_level_id
JOIN academic_sessions acad ON g.academic_session_id = acad.academic_session_id
JOIN semesters sem ON acad.semester_id = sem.semester_id
JOIN school_years sy ON acad.school_year_id = sy.school_year_id
WHERE s.student_id = 'STUDENT001';
```

### Get subject performance summary
```sql
SELECT 
    sub.subject_name,
    COUNT(*) as total_students,
    SUM(CASE WHEN g.status = 'PASS' THEN 1 ELSE 0 END) as passed,
    SUM(CASE WHEN g.status = 'FAIL' THEN 1 ELSE 0 END) as failed,
    AVG(g.grade) as average_grade
FROM grades g
JOIN subjects sub ON g.subject_id = sub.subject_id
GROUP BY sub.subject_id, sub.subject_name
ORDER BY average_grade DESC;
```

### Get teacher performance
```sql
SELECT 
    t.teacher_name,
    COUNT(DISTINCT g.student_id) as total_students,
    AVG(g.grade) as average_grade,
    SUM(CASE WHEN g.status = 'PASS' THEN 1 ELSE 0 END) as pass_count,
    SUM(CASE WHEN g.status = 'FAIL' THEN 1 ELSE 0 END) as fail_count
FROM grades g
JOIN teachers t ON g.teacher_id = t.teacher_id
GROUP BY t.teacher_id, t.teacher_name
ORDER BY average_grade DESC;
```

---

## Data Flow

1. **Upload Excel File** → Frontend reads Excel file
2. **Parse Data** → Convert Excel to JSON
3. **Initialize Database** → Call `init_database.php` (creates tables if needed)
4. **Save to Database** → Call `save_grades.php` with JSON data
5. **Parse Semester String** → Extract year level, school year, and semester components
6. **Normalize & Insert**:
   - Insert unique students into `students` table
   - Insert unique teachers into `teachers` table
   - Insert unique subjects into `subjects` table
   - Insert unique year levels into `year_levels` table (lookup)
   - Insert unique semesters into `semesters` table (lookup)
   - Insert unique school years into `school_years` table (lookup)
   - Insert academic sessions into `academic_sessions` table (combines school_year + semester)
   - Insert grade records into `grades` table with all foreign key references
7. **Log Upload** → Record upload metadata in `upload_logs` table

---

## Maintenance

### Backup Database
```bash
mysqldump -u root -p grade_analyzer_db > backup.sql
```

### Restore Database
```bash
mysql -u root -p grade_analyzer_db < backup.sql
```

### View Database Size
```sql
SELECT 
    table_name AS 'Table',
    ROUND(((data_length + index_length) / 1024 / 1024), 2) AS 'Size (MB)'
FROM information_schema.TABLES
WHERE table_schema = 'grade_analyzer_db'
ORDER BY (data_length + index_length) DESC;
```

---

## Support
For issues or questions about the database schema, please refer to the main README.md or contact the development team.
