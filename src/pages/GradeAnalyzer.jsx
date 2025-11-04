import React, { useState, useRef, useEffect } from "react"
import * as XLSX from "xlsx"
import { ModuleRegistry, AllCommunityModule } from "ag-grid-community"
import { Upload, Activity, BookOpen} from "lucide-react"
import TabButton from "../components/TabButton"
import UploadTab from "../components/UploadTab"
import OverviewTab from "../components/OverviewTab"
import SubjectAnalysisTab from "../components/SubjectAnalysisTab"
// import StudentAnalysisTab from "../components/StudentAnalysisTab"
// import PerformanceTab from "../components/PerformanceTab"
// import ComparisonTab from "../components/ComparisonTab"
import { ToastContainer } from "../components/Toast"
import { API_BASE } from "../utils/gradeHelpers"

ModuleRegistry.registerModules([AllCommunityModule])

export default function GradeAnalyzer() {
  const [sheets, setSheets] = useState([])
  const [selectedSheet, setSelectedSheet] = useState("")
  const [uploadedRows, setUploadedRows] = useState([])
  const [uploadCols, setUploadCols] = useState([])
  const [isLoading, setIsLoading] = useState(false)
  const fileInputRef = useRef(null)
  const [activeTab, setActiveTab] = useState("upload")
  const [saveStatus, setSaveStatus] = useState("")
  
  const [overviewStats, setOverviewStats] = useState(null)
  const [subjectAnalysis, setSubjectAnalysis] = useState([])

  const [topPerformers, setTopPerformers] = useState([])
  const [subjectPerformance, setSubjectPerformance] = useState([])
  const [categoryDistribution, setCategoryDistribution] = useState([])
  
  const [searchTerm, setSearchTerm] = useState("")
  const [selectedSemester, setSelectedSemester] = useState("all")
  
  // Academic session selection state
  const [schoolYearId, setSchoolYearId] = useState("")
  const [semesterId, setSemesterId] = useState("")
  const [academicSessionId, setAcademicSessionId] = useState("")
  
  // Filter state for data viewing
  const [filterSchoolYearId, setFilterSchoolYearId] = useState("")
  const [filterSemesterId, setFilterSemesterId] = useState("")
  const [filterPeriodId, setFilterPeriodId] = useState("")
  const [schoolYears, setSchoolYears] = useState([])
  const [semesters, setSemesters] = useState([])
  const [periods, setPeriods] = useState([])
  const [dataLoaded, setDataLoaded] = useState(false)
  
  // Toast notifications
  const [toasts, setToasts] = useState([])

  useEffect(() => {
    fetchSchoolYears() // Fetch only school years initially
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [])
  
  // Get academic session ID when school year and semester are selected
  useEffect(() => {
    if (schoolYearId && semesterId) {
      getAcademicSession(schoolYearId, semesterId)
    }
  }, [schoolYearId, semesterId])
  
  // When filter school year changes, fetch semesters for that school year
  useEffect(() => {
    if (filterSchoolYearId) {
      fetchSemesters(filterSchoolYearId)
      // Reset dependent dropdowns
      setFilterSemesterId("")
      setFilterPeriodId("")
      setPeriods([])
      setDataLoaded(false)
    } else {
      setSemesters([])
      setFilterSemesterId("")
      setFilterPeriodId("")
      setPeriods([])
    }
  }, [filterSchoolYearId])
  
  // When filter semester changes, fetch periods for that academic session
  useEffect(() => {
    if (filterSchoolYearId && filterSemesterId) {
      fetchPeriods(filterSchoolYearId, filterSemesterId)
      // Reset period selection
      setFilterPeriodId("")
      setDataLoaded(false)
    } else {
      setPeriods([])
      setFilterPeriodId("")
    }
  }, [filterSchoolYearId, filterSemesterId])
  
  const getAcademicSession = async (syId, semId) => {
    try {
      const response = await fetch(`${API_BASE}/subject.php?action=getAcademicSession&school_year_id=${syId}&semester_id=${semId}`)
      const result = await response.json()
      if (result.status === 'success') {
        setAcademicSessionId(result.data.academic_session_id)
      }
    } catch (error) {
      console.error('Error fetching academic session:', error)
    }
  }

  
  const fetchSchoolYears = async () => {
    try {
      // Fetch school years with grades
      const syResponse = await fetch(`${API_BASE}/subject.php?action=getSchoolYears&withGradesOnly=true`)
      const syData = await syResponse.json()
      if (syData.status === 'success') {
        setSchoolYears(syData.data)
      }
    } catch (error) {
      console.error('Error fetching school years:', error)
    }
  }
  
  const fetchSemesters = async (schoolYearId) => {
    try {
      // Fetch semesters filtered by school year
      const semResponse = await fetch(`${API_BASE}/subject.php?action=getSemesters&school_year_id=${schoolYearId}`)
      const semData = await semResponse.json()
      if (semData.status === 'success') {
        setSemesters(semData.data)
      }
    } catch (error) {
      console.error('Error fetching semesters:', error)
    }
  }
  
  const fetchPeriods = async (schoolYearId, semesterId) => {
    try {
      // Fetch periods filtered by school year and semester
      const periodResponse = await fetch(`${API_BASE}/subject.php?action=getPeriods&school_year_id=${schoolYearId}&semester_id=${semesterId}`)
      const periodData = await periodResponse.json()
      if (periodData.status === 'success') {
        setPeriods(periodData.data)
      }
    } catch (error) {
      console.error('Error fetching periods:', error)
    }
  }

  const addToast = (message, type = 'success', duration = 3000) => {
    const id = Date.now()
    setToasts(prev => [...prev, { id, message, type, duration }])
  }
  
  const removeToast = (id) => {
    setToasts(prev => prev.filter(toast => toast.id !== id))
  }
  
  const fetchAnalysisData = async () => {
    try {
      setIsLoading(true)
      
      // Build query params
      const params = new URLSearchParams()
      if (filterSchoolYearId) params.append('school_year_id', filterSchoolYearId)
      if (filterSemesterId) params.append('semester_id', filterSemesterId)
      if (filterPeriodId === 'all') {
        params.append('all_periods', 'true')
      } else if (filterPeriodId) {
        params.append('period_id', filterPeriodId)
      }
      const queryString = params.toString() ? `&${params.toString()}` : ''
      
      const [overview, subjects, topSubjects, categories] = await Promise.all([
        fetch(`${API_BASE}/subject.php?action=getOverviewStats${queryString}`).then(r => r.json()),
        fetch(`${API_BASE}/subject.php?action=getSummaries${queryString}`).then(r => r.json()),
        fetch(`${API_BASE}/subject.php?action=getTopSubjects&limit=10${queryString}`).then(r => r.json()),
        fetch(`${API_BASE}/subject.php?action=getCategoryDistribution${queryString}`).then(r => r.json())
      ])
      
      if (overview.status === 'success') setOverviewStats(overview.data)
      if (subjects.status === 'success') {
        setSubjectAnalysis(subjects.data)
        setSubjectPerformance(subjects.data)
      }
      if (topSubjects.status === 'success') setTopPerformers(topSubjects.data)
      
      // Set category distribution from grades table
      if (categories.status === 'success') {
        setCategoryDistribution(categories.data)
      }
      
      setIsLoading(false)
      setDataLoaded(true)
      
      // Show success toast
      const recordCount = overview.data?.total_records || 0
      addToast(`Data loaded successfully! ${recordCount} records found.`, 'success')
    } catch (error) {
      console.error("Error fetching analysis data:", error)
      setIsLoading(false)
      addToast('Failed to load data. Please try again.', 'error')
    }
  }
  
  const handleLoadData = () => {
    if (filterSchoolYearId && filterSemesterId) {
      fetchAnalysisData()
    }
  }

  const saveGradesToDatabase = async (data, filename) => {
    try {
      // Validate academic session selection
      if (!academicSessionId) {
        setSaveStatus("✗ Please select school year and semester")
        addToast("Please select school year and semester", "warning")
        return
      }
      
      setSaveStatus("Saving subject summaries to database...")
      const formData = new FormData()
      formData.append("operation", "saveSubjectSummary")
      formData.append("json", JSON.stringify(data))
      formData.append("filename", filename)
      formData.append("academic_session_id", academicSessionId)
      if (filterPeriodId) {
        formData.append("period_id", filterPeriodId)
      }

      const response = await fetch(`${API_BASE}/subject.php`, { method: "POST", body: formData })
      const result = await response.json()
      
      if (result.status === "success") {
        let message = `✓ Saved ${result.records_processed} subject summaries to database`
        if (result.records_skipped > 0) {
          message += ` (${result.records_skipped} skipped)`
        }
        setSaveStatus(message)
        addToast(`Successfully saved ${result.records_processed} subject summaries!`, "success")
        
        // Log debug info if available
        if (result.debug && result.errors && result.errors.length > 0) {
          console.log("Upload errors:", result.errors)
          console.log("Excel columns found:", result.columns_found)
        }
        
        setTimeout(() => setSaveStatus(""), 5000)
        fetchAnalysisData()
      } else {
        setSaveStatus(`✗ Error: ${result.message}`)
        addToast(`Error: ${result.message}`, "error", 5000)
      }
    } catch (error) {
      setSaveStatus("✗ Failed to save to database")
      addToast("Failed to save to database", "error")
    }
  }

  const handleFileUpload = (e) => {
    const file = e.target.files?.[0]
    if (!file) return
    fileInputRef.current = e.target

    const reader = new FileReader()
    reader.onload = (evt) => {
      try {
        const data = new Uint8Array(evt.target?.result)
        const workbook = XLSX.read(data, { type: "array" })
        const sheetNames = workbook.SheetNames
        setSheets(sheetNames)
        
        // Process ALL sheets automatically
        if (sheetNames.length > 0) {
          setSelectedSheet(sheetNames[0])
          processAllSheets(workbook, file.name)
        }
      } catch (error) {
        console.error("Error processing file:", error)
        alert("Error processing Excel file")
      }
    }
    reader.readAsArrayBuffer(file)
  }

  // Helper function to detect if a row is valid data (not header/title/error row)
  const isValidDataRow = (row) => {
    const excelErrors = ['#VALUE!', '#REF!', '#DIV/0!', '#N/A', '#NAME?', '#NULL!', '#NUM!']
    const values = Object.values(row)
    
    // Skip if all values are empty
    const nonEmptyValues = values.filter(v => v !== '' && v !== null && v !== undefined)
    if (nonEmptyValues.length === 0) return false
    
    // Skip if all non-empty values are Excel errors
    const allErrors = nonEmptyValues.every(v => 
      typeof v === 'string' && excelErrors.includes(v.toUpperCase().trim())
    )
    if (allErrors) return false
    
    // Skip if row looks like a title row (has "Program:", "Department:", etc.)
    const titleKeywords = ['Program:', 'Department:', 'School:', 'College:', 'Semester:', 'Year:']
    const hasTitle = Object.keys(row).some(key => titleKeywords.includes(key))
    if (hasTitle) return false
    
    return true
  }

  // Helper function to clean Excel errors from data
  const cleanExcelErrors = (data) => {
    const excelErrors = ['#VALUE!', '#REF!', '#DIV/0!', '#N/A', '#NAME?', '#NULL!', '#NUM!']
    const originalCount = data.length
    
    const cleaned = data
      .filter(row => isValidDataRow(row)) // Filter out invalid rows
      .map(row => {
        const cleanedRow = {}
        for (const [key, value] of Object.entries(row)) {
          // Skip columns that are Excel errors
          if (typeof value === 'string' && excelErrors.includes(value.toUpperCase().trim())) {
            cleanedRow[key] = '' // Replace with empty string
          } else {
            cleanedRow[key] = value
          }
        }
        return cleanedRow
      })
    
    const filteredCount = originalCount - cleaned.length
    if (filteredCount > 0) {
      console.log(`Filtered out ${filteredCount} invalid/error rows (${cleaned.length} valid rows remaining)`)
    }
    
    return cleaned
  }

  // Helper function to find actual data table in sheet (skip title rows)
  const findDataTable = (worksheet) => {
    // Expected column keywords for student grade data
    const studentGradeColumns = ['student', 'id', 'name', 'college', 'course', 'semester', 'code', 'subject', 'p1', 'p2', 'p3']
    // Expected column keywords for subject summary data
    const subjectSummaryColumns = ['subject', 'year', 'level', 'code', 'takers', 'nms', 'pts', 'mp', 'ehp', 'total']
    
    // Try reading with different starting rows
    for (let startRow = 0; startRow < 10; startRow++) {
      try {
        const range = XLSX.utils.decode_range(worksheet['!ref'])
        range.s.r = startRow // Start from this row
        
        const testData = XLSX.utils.sheet_to_json(worksheet, { 
          range: startRow,
          defval: "",
          raw: false 
        })
        
        if (testData.length === 0) continue
        
        // Check if this looks like actual data
        const firstRow = testData[0]
        const columns = Object.keys(firstRow).map(k => k.toLowerCase())
        
        // Count how many expected columns we found for each type
        const studentMatchCount = studentGradeColumns.filter(expected => 
          columns.some(col => col.includes(expected))
        ).length
        
        const summaryMatchCount = subjectSummaryColumns.filter(expected => 
          columns.some(col => col.includes(expected))
        ).length
        
        // If we found at least 3 expected columns, this is probably the data table
        if (studentMatchCount >= 3 || summaryMatchCount >= 3) {
          console.log(`Found data table starting at row ${startRow + 1}`)
          console.log(`Columns:`, Object.keys(firstRow))
          return testData
        }
      } catch (e) {
        continue
      }
    }
    
    // Fallback: use default reading
    console.warn("Could not find data table, using default reading")
    return XLSX.utils.sheet_to_json(worksheet, { defval: "" })
  }

  const processAllSheets = async (workbook, filename) => {
    try {
      setSaveStatus("Processing all sheets...")
      const sheetNames = workbook.SheetNames
      
      let subjectRawData = []
      let subjectLevelData = []
      // let totalRecords = 0
      
      // Process sheets based on their names
      for (const sheetName of sheetNames) {
        const worksheet = workbook.Sheets[sheetName]
        
        // Smart detection: find actual data table
        let jsonData = findDataTable(worksheet)
        console.log(`Sheet "${sheetName}": Initial read returned ${jsonData.length} rows`)
        
        // Clean Excel errors from data
        const cleanedData = cleanExcelErrors(jsonData)
        console.log(`Sheet "${sheetName}": After cleaning: ${cleanedData.length} valid rows`)
        
        if (cleanedData.length > 0) {
          const normalizedName = sheetName.toUpperCase().trim()
          
          // Detect sheet type by analyzing columns
          const firstRow = cleanedData[0]
          const columns = Object.keys(firstRow).map(k => k.toUpperCase())
          
          console.log(`Sheet "${sheetName}" - Columns detected:`, columns)
          
          // Check if this is the SUBJECT RAW sheet (Priority)
          if (normalizedName.includes('SUBJECT') && normalizedName.includes('RAW')) {
            subjectRawData = cleanedData
            console.log(`✓ Found SUBJECT RAW sheet: "${sheetName}" with ${cleanedData.length} valid records`)
          }
          // Check if this is the SUBJECT LEVEL DATA sheet (Fallback)
          else if (normalizedName.includes('SUBJECT') && normalizedName.includes('LEVEL')) {
            subjectLevelData = cleanedData
            console.log(`✓ Found SUBJECT LEVEL DATA sheet: "${sheetName}" with ${cleanedData.length} valid records`)
          }
          
          // totalRecords += cleanedData.length
        } else {
          console.warn(`⚠ Sheet "${sheetName}": No valid data found after cleaning`)
        }
      }
      
      // Set preview data (prioritize subject raw, then subject level data)
      const previewData = subjectRawData.length > 0 ? subjectRawData : subjectLevelData
      if (previewData.length > 0) {
        setUploadedRows(previewData)
        const firstRow = previewData[0]
        const allColumns = Object.keys(firstRow)
        
        // Filter columns: stop at CATEGORIZATION and exclude empty columns
        const filteredColumns = []
        for (const key of allColumns) {
          // Stop if we reach CATEGORIZATION
          if (key.toUpperCase() === 'CATEGORIZATION' || key.toUpperCase() === 'REMARKS') {
            break
          }
          // Skip empty columns
          if (key.includes('__EMPTY')) {
            continue
          }
          filteredColumns.push(key)
        }
        
        const cols = filteredColumns.map((key) => ({
          headerName: key, field: key, flex: 1, sortable: true, filter: true, resizable: true
        }))
        setUploadCols(cols)
      }
      
      let successCount = 0
      let errors = []
      
      // Step 1: Upload SUBJECT RAW data if exists (with grade categorization)
      if (subjectRawData.length > 0) {
        // Check academic session before processing
        if (!academicSessionId) {
          const msg = 'Please select School Year and Semester to upload Subject Raw Sheet'
          setSaveStatus(`⚠ ${msg}`)
          errors.push(msg)
          addToast(msg, "warning")
        } else {
          setSaveStatus(`Processing ${subjectRawData.length} subject raw records...`)
          const result = await saveSubjectRaw(subjectRawData, filename)
          if (result.status === 'success') {
            successCount += result.records_processed
            const msg = `✓ Processed ${result.records_processed} records`
            addToast(msg, "success")
            
            // Show summary statistics
            if (result.summaries_inserted > 0) {
              addToast(`📊 Inserted ${result.summaries_inserted} subject summaries into database`, "success")
            }
            
            if (result.summary_stats && result.summary_stats.length > 0) {
              console.log("Subject Summary Statistics:", result.summary_stats)
            }
            
            if (result.records_skipped > 0) {
              addToast(`⚠ ${result.records_skipped} rows skipped`, "warning")
            }
          } else {
            const errorMsg = `Subject Raw: ${result.message}`
            errors.push(errorMsg)
            addToast(errorMsg, "error")
          }
        }
      }
      
      // Step 2: Upload SUBJECT LEVEL DATA if exists (OLD FORMAT - fallback)
      if (subjectLevelData.length > 0 && subjectRawData.length === 0) {
        // Check academic session before processing
        if (!academicSessionId) {
          const msg = 'Please select School Year and Semester to upload Subject Level Data'
          setSaveStatus(`⚠ ${msg}`)
          errors.push(msg)
          addToast(msg, "warning")
        } else {
          setSaveStatus(`Processing ${subjectLevelData.length} subject summaries with academic session ${academicSessionId}...`)
          const result = await saveSubjectSummaries(subjectLevelData, filename)
          if (result.status === 'success') {
            successCount += result.records_processed
            const msg = `✓ Saved ${result.records_processed} subject summaries`
            addToast(msg, "success")
            if (result.records_skipped > 0) {
              addToast(`⚠ ${result.records_skipped} rows skipped`, "warning")
            }
          } else {
            const errorMsg = `Subject Level Data: ${result.message}`
            errors.push(errorMsg)
            addToast(errorMsg, "error")
          }
        }
      }
      
      if (successCount > 0) {
        setSaveStatus(`✓ Successfully processed ${successCount} total records`)
        setTimeout(() => setSaveStatus(""), 5000)
        fetchAnalysisData()
      } else if (errors.length > 0) {
        setSaveStatus(`✗ Errors: ${errors.join(', ')}`)
        addToast("Upload completed with errors", "error")
      } else {
        setSaveStatus("⚠ No recognized sheets found. Looking for SUBJECT RAW SHEET with columns: STUDENT ID, NAME, CODE, SUBJECT NAME, SEMESTER, and at least one period (P1, P2, or P3)")
        addToast("Please ensure your Excel has a 'Subject Raw Sheet' tab with required columns", "warning")
      }
      
    } catch (error) {
      console.error("Error processing sheets:", error)
      setSaveStatus("✗ Error processing Excel sheets")
      addToast("Error processing Excel file", "error")
    }
  }
  
  const saveSubjectRaw = async (data, filename) => {
    try {
      console.log("saveSubjectRaw called with:", {
        dataLength: data.length,
        academicSessionId,
        schoolYearId,
        semesterId
      })
      
      if (!academicSessionId) {
        const errorMsg = 'Academic session not set. Please select school year and semester.'
        addToast(errorMsg, "error")
        return { status: 'error', message: errorMsg }
      }
      
      const formData = new FormData()
      formData.append("operation", "processSubjectRawSheet")
      formData.append("json", JSON.stringify(data))
      formData.append("academic_session_id", academicSessionId)
      
      console.log("Sending subject raw data to server...", {
        operation: "processSubjectRawSheet",
        rowCount: data.length,
        academic_session_id: academicSessionId
      })
      
      const response = await fetch(`${API_BASE}/subject.php`, { method: "POST", body: formData })
      const result = await response.json()
      
      console.log("Subject raw response:", result)
      
      // Log debug info if available
      if (result.errors && result.errors.length > 0) {
        console.error("Upload errors:", result.errors)
      }
      if (result.summary_stats) {
        console.log("Summary statistics:", result.summary_stats)
      }
      
      return result
    } catch (error) {
      console.error("saveSubjectRaw error:", error)
      return { status: 'error', message: error.message }
    }
  }
  
  // const saveStudentGrades = async (data, filename) => {
  //   try {
  //     console.log("saveStudentGrades called with:", {
  //       dataLength: data.length,
  //       academicSessionId,
  //       schoolYearId,
  //       semesterId
  //     })
      
  //     if (!academicSessionId) {
  //       const errorMsg = 'Academic session not set. Please select school year and semester.'
  //       addToast(errorMsg, "error")
  //       return { status: 'error', message: errorMsg }
  //     }
      
  //     const formData = new FormData()
  //     formData.append("operation", "saveStudentGrades")
  //     formData.append("json", JSON.stringify(data))
  //     formData.append("academic_session_id", academicSessionId)
      
  //     console.log("Sending student grades to server...", {
  //       operation: "saveStudentGrades",
  //       rowCount: data.length,
  //       academic_session_id: academicSessionId
  //     })
      
  //     const response = await fetch(`${API_BASE}/subject.php`, { method: "POST", body: formData })
  //     const result = await response.json()
      
  //     console.log("Student grades response:", result)
      
  //     // Log debug info if available
  //     if (result.errors && result.errors.length > 0) {
  //       console.error("Upload errors:", result.errors)
  //     }
  //     if (result.columns_found) {
  //       console.log("Excel columns found:", result.columns_found)
  //     }
      
  //     return result
  //   } catch (error) {
  //     console.error("saveStudentGrades error:", error)
  //     return { status: 'error', message: error.message }
  //   }
  // }
  
  const saveSubjectSummaries = async (data, filename) => {
    try {
      console.log("saveSubjectSummaries called with:", {
        dataLength: data.length,
        academicSessionId,
        schoolYearId,
        semesterId
      })
      
      if (!academicSessionId) {
        const errorMsg = 'Academic session not set. Please select school year and semester.'
        addToast(errorMsg, "error")
        return { status: 'error', message: errorMsg }
      }
      
      const formData = new FormData()
      formData.append("operation", "saveSubjectSummary")
      formData.append("json", JSON.stringify(data))
      formData.append("filename", filename)
      formData.append("academic_session_id", academicSessionId)
      
      console.log("Sending subject summaries to server...", {
        operation: "saveSubjectSummary",
        rowCount: data.length,
        academic_session_id: academicSessionId
      })
      
      const response = await fetch(`${API_BASE}/save_subject_summary.php`, { method: "POST", body: formData })
      const result = await response.json()
      
      console.log("Subject summaries response:", result)
      
      // Log debug info if available
      if (result.errors && result.errors.length > 0) {
        console.error("Upload errors:", result.errors)
      }
      if (result.columns_found) {
        console.log("Excel columns found:", result.columns_found)
      }
      
      return result
    } catch (error) {
      console.error("saveSubjectSummaries error:", error)
      return { status: 'error', message: error.message }
    }
  }

  const processSheet = (sheetName, workbook, filename) => {
    const worksheet = workbook.Sheets[sheetName]
    const jsonData = XLSX.utils.sheet_to_json(worksheet, { defval: "" })
    setUploadedRows(jsonData)

    if (jsonData.length > 0) {
      const firstRow = jsonData[0]
      const cols = Object.keys(firstRow).map((key) => ({
        headerName: key, field: key, flex: 1, sortable: true, filter: true, resizable: true
      }))
      setUploadCols(cols)
      saveGradesToDatabase(jsonData, filename || sheetName)
    }
  }

  const handleSheetChange = (e) => {
    const sheetName = e.target.value
    setSelectedSheet(sheetName)
    if (fileInputRef.current?.files?.[0]) {
      const file = fileInputRef.current.files[0]
      const reader = new FileReader()
      reader.onload = (evt) => {
        try {
          const data = new Uint8Array(evt.target?.result)
          const workbook = XLSX.read(data, { type: "array" })
          processSheet(sheetName, workbook, file.name)
        } catch (error) {
          console.error("Error processing file:", error)
        }
      }
      reader.readAsArrayBuffer(file)
    }
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-gray-50 to-white">
      <ToastContainer toasts={toasts} removeToast={removeToast} />
      <div className="bg-primary-500 border-b border-primary-600 shadow-lg">
        <div className="px-4 py-6">
          <div className="flex items-center justify-between">
            <div>
              <h1 className="text-3xl font-bold text-white">Grade Analyzer System</h1>
              <p className="text-primary-50 text-sm mt-1">Comprehensive batch upload and descriptive analytics</p>
            </div>
            {overviewStats && (
              <div className="text-right">
                <div className="text-3xl font-bold text-white">{overviewStats.total_students}</div>
                <div className="text-sm text-primary-100">Students</div>
              </div>
            )}
          </div>
          
          {/* Data Filter Controls */}
          <div className="mt-6 bg-white/10 backdrop-blur-sm rounded-lg p-4">
            <div className="flex flex-wrap items-end gap-4">
              <div className="flex-1 min-w-[200px]">
                <label className="block text-sm font-medium text-white mb-2">School Year</label>
                <select
                  value={filterSchoolYearId}
                  onChange={(e) => setFilterSchoolYearId(e.target.value)}
                  className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-white"
                >
                  <option value="">All School Years</option>
                  {schoolYears.map((sy) => (
                    <option key={sy.school_year_id} value={sy.school_year_id}>
                      {sy.school_year}
                    </option>
                  ))}
                </select>
              </div>
              
              <div className="flex-1 min-w-[200px]">
                <label className="block text-sm font-medium text-white mb-2">Semester</label>
                <select
                  value={filterSemesterId}
                  onChange={(e) => setFilterSemesterId(e.target.value)}
                  className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-white"
                >
                  <option value="">All Semesters</option>
                  {semesters.map((sem) => (
                    <option key={sem.semester_id} value={sem.semester_id}>
                      {sem.semester_name}
                    </option>
                  ))}
                </select>
              </div>
              
              <div className="flex-1 min-w-[200px]">
                <label className="block text-sm font-medium text-white mb-2">Period</label>
                <select
                  value={filterPeriodId}
                  onChange={(e) => setFilterPeriodId(e.target.value)}
                  className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-white"
                >
                  <option value="">Select Period</option>
                  <option value="all">All Periods</option>
                  {periods.map((period) => (
                    <option key={period.period_id} value={period.period_id}>
                      {period.period_name}
                    </option>
                  ))}
                </select>
              </div>
              
              <div>
                <button
                  onClick={handleLoadData}
                  disabled={!filterSchoolYearId || !filterSemesterId || isLoading}
                  className={`px-6 py-2 rounded-lg font-semibold transition ${
                    !filterSchoolYearId || !filterSemesterId || isLoading
                      ? 'bg-gray-300 text-gray-500 cursor-not-allowed'
                      : 'bg-white text-primary-600 hover:bg-primary-50'
                  }`}
                >
                  {isLoading ? 'Loading...' : 'Load Data'}
                </button>
              </div>
            </div>
            
            {!filterSchoolYearId || !filterSemesterId ? (
              <p className="mt-3 text-sm text-yellow-200 font-medium">
                ⚠ Please select School Year and Semester, then choose a Period
              </p>
            ) : !dataLoaded && !isLoading ? (
              <p className="mt-3 text-sm text-yellow-200 font-medium">
                👆 Click "Load Data" to view analytics {filterPeriodId === 'all' ? '(All Periods)' : filterPeriodId ? `(${periods.find(p => p.period_id === filterPeriodId)?.period_name})` : ''}
              </p>
            ) : null}
          </div>
        </div>
      </div>

      <div className="bg-white border-b border-gray-200 sticky top-0 z-10 shadow-sm">
        <div className="px-4 flex gap-1 overflow-x-auto">
          <TabButton tab="upload" label="Batch Upload" icon={Upload} activeTab={activeTab} onClick={setActiveTab} />
          <TabButton tab="overview" label="Overview" icon={Activity} activeTab={activeTab} onClick={setActiveTab} />
          <TabButton tab="subjects" label="Subject Analysis" icon={BookOpen} activeTab={activeTab} onClick={setActiveTab} />
          {/* <TabButton tab="students" label="Student Analysis" icon={Users} activeTab={activeTab} onClick={setActiveTab} />
          <TabButton tab="performance" label="Performance" icon={TrendingUp} activeTab={activeTab} onClick={setActiveTab} />
          <TabButton tab="comparison" label="Comparison" icon={BarChart3} activeTab={activeTab} onClick={setActiveTab} /> */}
        </div>
      </div>

      <div className="px-4 py-8">
        {isLoading && (
          <div className="bg-white rounded-lg shadow-md border border-gray-200 p-12 text-center">
            <div className="inline-block animate-spin rounded-full h-12 w-12 border-b-2 border-primary-500 mb-4"></div>
            <p className="text-gray-600 font-medium">Loading data...</p>
          </div>
        )}
        
        {!isLoading && !dataLoaded && activeTab !== "upload" && (
          <div className="bg-white rounded-lg shadow-md border border-gray-200 p-12 text-center">
            <p className="text-gray-600 text-lg">Please select school year and semester, then click "Load Data" to view analytics.</p>
          </div>
        )}
        
        {activeTab === "upload" && (
          <UploadTab 
            sheets={sheets} 
            selectedSheet={selectedSheet} 
            uploadedRows={uploadedRows} 
            uploadCols={uploadCols}
 
            saveStatus={saveStatus} 
            handleFileUpload={handleFileUpload} 
            handleSheetChange={handleSheetChange}
            schoolYearId={schoolYearId}
            setSchoolYearId={setSchoolYearId}
            semesterId={semesterId}
            setSemesterId={setSemesterId}
          />
        )}
        {!isLoading && dataLoaded && activeTab === "overview" && (
          <OverviewTab overviewStats={overviewStats} topPerformers={topPerformers} categoryDistribution={categoryDistribution} />
        )}
        {!isLoading && dataLoaded && activeTab === "subjects" && (
          <SubjectAnalysisTab subjectAnalysis={subjectAnalysis} subjectPerformance={subjectPerformance}
            searchTerm={searchTerm} setSearchTerm={setSearchTerm} selectedSemester={selectedSemester} setSelectedSemester={setSelectedSemester} />
        )}
        {/* 
        {!isLoading && dataLoaded && activeTab === "students" && (
          <StudentAnalysisTab studentAnalysis={studentAnalysis} searchTerm={searchTerm} setSearchTerm={setSearchTerm}
            selectedSemester={selectedSemester} setSelectedSemester={setSelectedSemester} />
        )}
        {!isLoading && dataLoaded && activeTab === "performance" && (
          <PerformanceTab subjectPerformance={subjectPerformance} semesterComparison={semesterComparison} />
        )}
        {!isLoading && dataLoaded && activeTab === "comparison" && (
          <ComparisonTab semesterComparison={semesterComparison} />
        )}
        */}
      </div>
    </div>
  )
}
