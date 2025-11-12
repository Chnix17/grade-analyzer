import React, { useState, useEffect, useMemo, useRef } from "react"
import { AgGridReact } from "ag-grid-react"
import { themeQuartz } from "ag-grid-community"
import * as XLSX from "xlsx"
import Papa from "papaparse"
import { Upload, Save, RefreshCw, FileText, AlertCircle, CheckCircle } from "lucide-react"
import { API_BASE } from "../utils/gradeHelpers"

const agGridTheme = themeQuartz

const REQUIRED_FIELDS = ['student_id', 'subject_id', 'year_level']
const STATUS_ENUMS = ['PASS', 'FAIL']
const DECISION_ENUMS = ['PROMOTE', 'RETAIN', 'REMEDIATION']

export default function SubjectDeliberationTab({
  filterSchoolYearId,
  filterSemesterId,
  addToast
}) {
  const [file, setFile] = useState(null)
  const [fileType, setFileType] = useState(null) // 'csv' or 'xlsx'
  const [sheets, setSheets] = useState([])
  const [selectedSheet, setSelectedSheet] = useState("")
  const [hasHeaderRow, setHasHeaderRow] = useState(true)
  const [rawData, setRawData] = useState([])
  const [columnMapping, setColumnMapping] = useState({})
  const [mappedData, setMappedData] = useState([])
  const [validationErrors, setValidationErrors] = useState([])
  const [isLoading, setIsLoading] = useState(false)
  const [isSaving, setIsSaving] = useState(false)
  const [savedRows, setSavedRows] = useState([])
  const [batches, setBatches] = useState([])
  const [showMapping, setShowMapping] = useState(false)
  const [computedAcademicSessionId, setComputedAcademicSessionId] = useState(null)
  const [serverErrors, setServerErrors] = useState([])
  const fileInputRef = useRef(null)

  // Compute academic session ID from filter values
  useEffect(() => {
    if (filterSchoolYearId && filterSemesterId) {
      fetch(`${API_BASE}/academic_sessions.php?action=getAcademicSession&school_year_id=${filterSchoolYearId}&semester_id=${filterSemesterId}`)
        .then(res => res.json())
        .then(result => {
          if (result.status === 'success') {
            setComputedAcademicSessionId(result.data.academic_session_id)
          }
        })
        .catch(err => {
          console.error('Error fetching academic session:', err)
          setComputedAcademicSessionId(null)
        })
    } else {
      setComputedAcademicSessionId(null)
    }
  }, [filterSchoolYearId, filterSemesterId])

  const fileColumns = useMemo(() => {
    if (rawData.length === 0) return []
    return Object.keys(rawData[0])
  }, [rawData])

  const targetFields = useMemo(() => [
    { key: 'student_id', label: 'Student ID', required: true },
    { key: 'student_name', label: 'Student Name', required: false },
    { key: 'subject_id', label: 'Subject ID/Code', required: true },
    { key: 'year_level', label: 'Year Level', required: true },
    { key: 'raw_score', label: 'Raw Score', required: false },
    { key: 'grade', label: 'Grade', required: false },
    { key: 'status', label: 'Status (PASS/FAIL)', required: false },
    { key: 'decision', label: 'Decision (PROMOTE/RETAIN/REMEDIATION)', required: false },
    { key: 'remarks', label: 'Remarks', required: false }
  ], [])

  useEffect(() => {
    if (filterSchoolYearId && filterSemesterId) {
      fetchDeliberations()
      fetchBatches()
    }
  }, [filterSchoolYearId, filterSemesterId])

  const fetchDeliberations = async () => {
    try {
      setIsLoading(true)
      const params = new URLSearchParams()
      if (filterSchoolYearId) params.append('school_year_id', filterSchoolYearId)
      if (filterSemesterId) params.append('semester_id', filterSemesterId)
      const queryString = params.toString() ? `&${params.toString()}` : ''
      
      const response = await fetch(`${API_BASE}/subject_deliberations.php?action=getRows${queryString}`)
      
      if (!response.ok) {
        throw new Error(`Server error: ${response.status} ${response.statusText}`)
      }
      
      const result = await response.json()
      if (result.status === 'success') {
        setSavedRows(result.data)
      } else {
        throw new Error(result.message || 'Unknown error')
      }
    } catch (error) {
      console.error('Error fetching deliberations:', error)
      if (addToast) addToast(`Failed to fetch deliberations: ${error.message}`, 'error')
    } finally {
      setIsLoading(false)
    }
  }

  const fetchBatches = async () => {
    try {
      const response = await fetch(`${API_BASE}/subject_deliberations.php?action=getBatches`)
      const result = await response.json()
      if (result.status === 'success') {
        setBatches(result.data)
      }
    } catch (error) {
      console.error('Error fetching batches:', error)
    }
  }

  const handleFileSelect = (e) => {
    const selectedFile = e.target.files?.[0]
    if (!selectedFile) return

    const fileName = selectedFile.name.toLowerCase()
    if (fileName.endsWith('.csv')) {
      setFileType('csv')
      setFile(selectedFile)
      parseCSV(selectedFile)
    } else if (fileName.endsWith('.xlsx') || fileName.endsWith('.xls')) {
      setFileType('xlsx')
      setFile(selectedFile)
      parseXLSX(selectedFile)
    } else {
      if (addToast) addToast('Please select a CSV or Excel file', 'error')
    }
  }

  const parseCSV = (file) => {
    Papa.parse(file, {
      header: hasHeaderRow,
      skipEmptyLines: true,
      complete: (results) => {
        if (results.errors.length > 0) {
          console.warn('CSV parsing errors:', results.errors)
          const errorMsg = results.errors.slice(0, 3).map(e => `Row ${e.row}: ${e.message}`).join(', ')
          if (addToast) addToast(`CSV parsing warnings: ${errorMsg}`, 'warning')
        }
        if (results.data && results.data.length > 0) {
          setRawData(results.data)
          autoMapColumns(results.data)
          if (addToast) addToast(`Loaded ${results.data.length} rows from CSV`, 'success')
        } else {
          if (addToast) addToast('CSV file appears to be empty', 'error')
        }
      },
      error: (error) => {
        console.error('CSV parse error:', error)
        if (addToast) addToast(`Error parsing CSV: ${error.message || 'Invalid file format'}`, 'error')
      }
    })
  }

  const parseXLSX = (file) => {
    const reader = new FileReader()
    reader.onload = (e) => {
      try {
        const data = new Uint8Array(e.target.result)
        const workbook = XLSX.read(data, { type: 'array' })
        const sheetNames = workbook.SheetNames
        
        if (sheetNames.length === 0) {
          if (addToast) addToast('No sheets found in Excel file', 'error')
          return
        }
        
        setSheets(sheetNames)
        setSelectedSheet(sheetNames[0])
        processSheet(workbook.Sheets[sheetNames[0]])
        
        if (sheetNames.length > 1 && addToast) {
          addToast(`Found ${sheetNames.length} sheets. Select sheet from dropdown if needed.`, 'info')
        }
      } catch (error) {
        console.error('Error parsing XLSX:', error)
        if (addToast) addToast(`Error parsing Excel file: ${error.message || 'Invalid file format'}`, 'error')
      }
    }
    reader.onerror = () => {
      if (addToast) addToast('Failed to read file. Please try again.', 'error')
    }
    reader.readAsArrayBuffer(file)
  }

  const processSheet = (worksheet) => {
    try {
      const jsonData = XLSX.utils.sheet_to_json(worksheet, {
        defval: '',
        raw: false
      })
      
      if (jsonData.length === 0) {
        if (addToast) addToast('No data found in selected sheet', 'warning')
        return
      }

      setRawData(jsonData)
      autoMapColumns(jsonData)
      if (addToast) addToast(`Loaded ${jsonData.length} rows from sheet`, 'success')
    } catch (error) {
      console.error('Error processing sheet:', error)
      if (addToast) addToast(`Error processing sheet: ${error.message}`, 'error')
    }
  }

  const handleSheetChange = (e) => {
    const sheetName = e.target.value
    setSelectedSheet(sheetName)
    if (file && fileType === 'xlsx') {
      const reader = new FileReader()
      reader.onload = (evt) => {
        const data = new Uint8Array(evt.target.result)
        const workbook = XLSX.read(data, { type: 'array' })
        processSheet(workbook.Sheets[sheetName])
      }
      reader.readAsArrayBuffer(file)
    }
  }

  const autoMapColumns = (data) => {
    if (data.length === 0) return
    
    const firstRow = data[0]
    const fileCols = Object.keys(firstRow)
    const mapping = {}
    
    targetFields.forEach(field => {
      const fieldLower = field.key.toLowerCase()
      const labelLower = field.label.toLowerCase()
      
      let matched = fileCols.find(col => {
        const colLower = col.toLowerCase().trim().replace(/\s+/g, ' ')
        const colNoSpace = colLower.replace(/\s/g, '')
        const fieldNoSpace = fieldLower.replace(/_/g, '')
        
        return colLower === fieldLower || 
               colNoSpace === fieldNoSpace ||
               colLower.includes(fieldLower) ||
               colLower === labelLower.replace(/\([^)]*\)/g, '').trim() ||
               (fieldLower === 'student_id' && (
                 colLower === 'students id number' ||
                 colLower === 'student id number' ||
                 (colLower.includes('student') && (colLower.includes('id') || colLower.includes('number')))
               )) ||
               (fieldLower === 'student_name' && (
                 colLower === 'students name' ||
                 colLower === 'student name' ||
                 (colLower.includes('student') && colLower.includes('name'))
               )) ||
               (fieldLower === 'subject_id' && (
                 colLower === 'subject code' ||
                 colLower === 'subject id' ||
                 (colLower.includes('subject') && (colLower.includes('id') || colLower.includes('code')))
               )) ||
               (fieldLower === 'year_level' && (
                 colLower === 'year level' ||
                 (colLower.includes('year') && colLower.includes('level'))
               ))
      })
      
      if (matched) {
        mapping[field.key] = matched
      }
    })
    
    // Detect period grade and categorization columns - prioritize actual grade columns over Q1/Q2 if both exist
    const periodGradeColumns = []
    const periodMap = new Map()
    const categorizationMap = new Map()
    
    fileCols.forEach(col => {
      const colLower = col.toLowerCase().trim()
      if (colLower === 'p1 grade') {
        periodMap.set(1, { period_id: 1, column: col, period_name: 'Q1', priority: 1 })
      } else if (colLower === 'p1 categorization') {
        categorizationMap.set(1, col)
      } else if (colLower === 'q1 grade' || colLower === 'q1') {
        if (!periodMap.has(1)) {
          periodMap.set(1, { period_id: 1, column: col, period_name: 'Q1', priority: 2 })
        }
      } else if (colLower === 'q1 categorization') {
        if (!categorizationMap.has(1)) {
          categorizationMap.set(1, col)
        }
      } else if (colLower === 'p2 grade') {
        periodMap.set(2, { period_id: 2, column: col, period_name: 'Q2', priority: 1 })
      } else if (colLower === 'p2 categorization') {
        categorizationMap.set(2, col)
      } else if (colLower === 'q2 grade' || colLower === 'q2') {
        if (!periodMap.has(2)) {
          periodMap.set(2, { period_id: 2, column: col, period_name: 'Q2', priority: 2 })
        }
      } else if (colLower === 'q2 categorization') {
        if (!categorizationMap.has(2)) {
          categorizationMap.set(2, col)
        }
      } else if (colLower === 'fe grade' || colLower === 'fe') {
        periodMap.set(63, { period_id: 63, column: col, period_name: 'FE', priority: 1 })
      } else if (colLower === 'fe categorization') {
        categorizationMap.set(63, col)
      } else if (colLower === 'final grade' || colLower === 'final') {
        periodMap.set(64, { period_id: 64, column: col, period_name: 'Final Grade', priority: 1 })
      } else if (colLower === 'final categorization') {
        categorizationMap.set(64, col)
      }
    })
    
    periodMap.forEach((value, periodId) => {
      const categorizationCol = categorizationMap.get(periodId)
      periodGradeColumns.push({ ...value, categorizationColumn: categorizationCol })
    })
    
    setColumnMapping({ ...mapping, _periodGrades: periodGradeColumns })
    
    const allRequiredMapped = REQUIRED_FIELDS.every(field => mapping[field])
    
    if (allRequiredMapped) {
      if (addToast) {
        const periodInfo = periodGradeColumns.length > 0 ? ` (${periodGradeColumns.length} period grades found)` : ''
        addToast(`✓ Auto-mapped ${Object.keys(mapping).length} columns${periodInfo}`, 'success')
      }
      
      // Create records for each period
      const mapped = []
      data.forEach((row, index) => {
        if (periodGradeColumns.length > 0) {
          // Create one record per period
          periodGradeColumns.forEach(periodInfo => {
            const gradeValue = row[periodInfo.column]
            const normalizedValue = typeof gradeValue === 'string' ? gradeValue.trim().toUpperCase() : gradeValue
            if (gradeValue && gradeValue !== '' && normalizedValue !== 'NA') {
              const mappedRow = { _rowIndex: index, _period_id: periodInfo.period_id, _period_name: periodInfo.period_name }
              targetFields.forEach(field => {
                const sourceCol = mapping[field.key]
                if (sourceCol && row[sourceCol] !== undefined) {
                  let value = row[sourceCol]
                  if (typeof value === 'string') {
                    value = value.trim()
                  }
                  mappedRow[field.key] = value || null
                } else {
                  mappedRow[field.key] = null
                }
              })
              
              // Set grade from period column
              mappedRow.grade = gradeValue
              
              // Set categorization from period categorization column
              if (periodInfo.categorizationColumn) {
                const categorizationValue = row[periodInfo.categorizationColumn]
                if (categorizationValue && categorizationValue !== '' && categorizationValue.toUpperCase() !== 'NA') {
                  mappedRow.categorization = categorizationValue
                }
              }
              
              // Infer status from grade
              const grade = parseFloat(gradeValue)
              if (!isNaN(grade)) {
                mappedRow.status = grade >= 75 ? 'PASS' : 'FAIL'
              }
              
              mapped.push(mappedRow)
            }
          })
        } else {
          // No period columns, single record
          const mappedRow = { _rowIndex: index }
          targetFields.forEach(field => {
            const sourceCol = mapping[field.key]
            if (sourceCol && row[sourceCol] !== undefined) {
              let value = row[sourceCol]
              if (typeof value === 'string') {
                value = value.trim()
              }
              mappedRow[field.key] = value || null
            } else {
              mappedRow[field.key] = null
            }
          })
          
          // Infer status from grade if not provided
          if (!mappedRow.status && mappedRow.grade !== null && mappedRow.grade !== '') {
            const grade = parseFloat(mappedRow.grade)
            if (!isNaN(grade)) {
              mappedRow.status = grade >= 75 ? 'PASS' : 'FAIL'
            }
          }
          
          mapped.push(mappedRow)
        }
      })

      setMappedData(mapped)
      validateData(mapped)
      setShowMapping(false)
    } else {
      // Show mapping UI for manual adjustment
      setShowMapping(true)
    }
  }

  const applyMapping = () => {
    if (rawData.length === 0) return

    const mapped = rawData.map((row, index) => {
      const mappedRow = { _rowIndex: index }
      targetFields.forEach(field => {
        const sourceCol = columnMapping[field.key]
        if (sourceCol && row[sourceCol] !== undefined) {
          let value = row[sourceCol]
          // Trim strings
          if (typeof value === 'string') {
            value = value.trim()
          }
          mappedRow[field.key] = value || null
        } else {
          mappedRow[field.key] = null
        }
      })
      return mappedRow
    })

    // Infer status from grade if not provided
    mapped.forEach(row => {
      if (!row.status && row.grade !== null && row.grade !== '') {
        const grade = parseFloat(row.grade)
        if (!isNaN(grade)) {
          row.status = grade >= 75 ? 'PASS' : 'FAIL'
        }
      }
    })

    setMappedData(mapped)
    validateData(mapped)
    setShowMapping(false)
  }

  const validateData = (data) => {
    const errors = []
    const seenKeys = new Set()

    data.forEach((row, index) => {
      // Check required fields
      REQUIRED_FIELDS.forEach(field => {
        if (!row[field] || row[field] === '' || row[field] === null) {
          errors.push({
            row: index + 1,
            field,
            message: `Missing required field: ${field}`
          })
        }
      })

      // Check status enum
      if (row.status && !STATUS_ENUMS.includes(row.status.toUpperCase())) {
        errors.push({
          row: index + 1,
          field: 'status',
          message: `Invalid status: ${row.status}. Must be PASS or FAIL`
        })
      }

      // Check decision enum
      if (row.decision && !DECISION_ENUMS.includes(row.decision.toUpperCase())) {
        errors.push({
          row: index + 1,
          field: 'decision',
          message: `Invalid decision: ${row.decision}. Must be PROMOTE, RETAIN, or REMEDIATION`
        })
      }

      // Check for true duplicates (same student+subject+period appearing twice)
      if (row.student_id && row.subject_id) {
        const periodKey = row._period_id || 'none'
        const key = `${row.student_id}_${row.subject_id}_${periodKey}`
        if (seenKeys.has(key)) {
          errors.push({
            row: index + 1,
            field: 'duplicate',
            message: `Duplicate: Student ${row.student_id} + Subject ${row.subject_id} + Period ${row._period_name || periodKey} already exists in this upload`
          })
        }
        seenKeys.add(key)
      }
    })

    setValidationErrors(errors)
    return errors.length === 0
  }

  const handleSave = async () => {
    if (!computedAcademicSessionId) {
      if (addToast) addToast('Please select school year and semester in the filters above', 'error')
      return
    }

    if (mappedData.length === 0) {
      if (addToast) addToast('No data to save', 'error')
      return
    }

    if (validationErrors.length > 0) {
      if (addToast) addToast(`Please fix ${validationErrors.length} validation errors before saving`, 'error')
      return
    }

    try {
      setIsSaving(true)
      const formData = new FormData()
      formData.append('operation', 'saveDeliberations')
      formData.append('json', JSON.stringify(mappedData))
      formData.append('filename', file?.name || 'upload.csv')
      formData.append('academic_session_id', computedAcademicSessionId)

      const response = await fetch(`${API_BASE}/save_subject_deliberations.php`, {
        method: 'POST',
        body: formData
      })

      if (!response.ok) {
        throw new Error(`Server error: ${response.status} ${response.statusText}`)
      }

      const result = await response.json()
      if (result.status === 'success') {
        const successMsg = result.saved > 0 
          ? `Successfully saved ${result.saved} record${result.saved > 1 ? 's' : ''}!` 
          : 'Upload completed'
        
        if (addToast) addToast(successMsg, 'success')
        
        if (result.errors && result.errors.length > 0) {
          console.warn('Server validation errors:', result.errors)
          setServerErrors(result.errors)
          
          const errorSummary = {}
          result.errors.forEach(err => {
            const reason = err.reason || 'Unknown error'
            errorSummary[reason] = (errorSummary[reason] || 0) + 1
          })
          
          const errorMessages = Object.entries(errorSummary).map(([reason, count]) => 
            `${count} row${count > 1 ? 's' : ''}: ${reason}`
          )
          
          if (addToast) {
            addToast(`Upload completed with ${result.errors.length} error${result.errors.length > 1 ? 's' : ''}`, 'warning')
            errorMessages.slice(0, 3).forEach(msg => addToast(msg, 'warning'))
            if (errorMessages.length > 3) {
              addToast(`+ ${errorMessages.length - 3} more error types`, 'warning')
            }
          }
        } else {
          setServerErrors([])
        }
        
        fetchDeliberations()
        fetchBatches()
        
        if (result.errors && result.errors.length === 0) {
          setFile(null)
          setRawData([])
          setMappedData([])
          setColumnMapping({})
          setValidationErrors([])
          setShowMapping(false)
          if (fileInputRef.current) {
            fileInputRef.current.value = ''
          }
        }
      } else {
        if (addToast) addToast(`Error: ${result.message || 'Unknown error occurred'}`, 'error')
      }
    } catch (error) {
      console.error('Error saving:', error)
      const errorMsg = error.message || 'Failed to save data. Please check your connection and try again.'
      if (addToast) addToast(errorMsg, 'error')
    } finally {
      setIsSaving(false)
    }
  }

  const exportToCSV = () => {
    if (savedRows.length === 0) return

    const headers = ['student_id', 'subject_code', 'subject_name', 'year_level_name', 'raw_score', 'grade', 'status', 'decision', 'remarks']
    const csvRows = [headers.join(',')]

    savedRows.forEach(row => {
      const values = headers.map(h => {
        const value = row[h] || ''
        return `"${String(value).replace(/"/g, '""')}"`
      })
      csvRows.push(values.join(','))
    })

    const blob = new Blob([csvRows.join('\n')], { type: 'text/csv' })
    const url = window.URL.createObjectURL(blob)
    const a = document.createElement('a')
    a.href = url
    a.download = `deliberations_${Date.now()}.csv`
    a.click()
    window.URL.revokeObjectURL(url)
  }

  const gridColumns = useMemo(() => {
    if (mappedData.length > 0) {
      // Show mapped columns with period indicator
      return [
        { headerName: 'Student ID', field: 'student_id', flex: 1, sortable: true, filter: true },
        { headerName: 'Student Name', field: 'student_name', flex: 1.5, sortable: true, filter: true },
        { headerName: 'Subject Code', field: 'subject_id', flex: 1, sortable: true, filter: true },
        { headerName: 'Year Level', field: 'year_level', flex: 1, sortable: true, filter: true },
        { 
          headerName: 'Period', 
          field: '_period_name', 
          flex: 1, 
          sortable: true, 
          filter: true,
          cellStyle: { backgroundColor: '#dbeafe', color: '#1e40af', fontWeight: '600' }
        },
        { 
          headerName: 'Grade', 
          field: 'grade', 
          flex: 1, 
          sortable: true, 
          filter: true,
          cellStyle: (params) => {
            if (!params.value) return {}
            const grade = parseFloat(params.value)
            if (isNaN(grade)) return {}
            
            if (grade >= 80) return { backgroundColor: '#d1fae5', color: '#065f46', fontWeight: '600' }
            if (grade >= 75) return { backgroundColor: '#dcfce7', color: '#166534', fontWeight: '600' }
            if (grade >= 60) return { backgroundColor: '#fef3c7', color: '#92400e', fontWeight: '600' }
            if (grade >= 50) return { backgroundColor: '#fed7aa', color: '#9a3412', fontWeight: '600' }
            return { backgroundColor: '#fee2e2', color: '#991b1b', fontWeight: '600' }
          }
        },
        { 
          headerName: 'Categorization', 
          field: 'categorization', 
          flex: 2, 
          sortable: true, 
          filter: true
        },
        { 
          headerName: 'Status', 
          field: 'status', 
          flex: 1, 
          sortable: true, 
          filter: true,
          cellRenderer: (params) => {
            if (!params.value) return ''
            const status = params.value.toUpperCase()
            const color = status === 'PASS' ? 'text-green-600 font-semibold' : 'text-red-600 font-semibold'
            return <span className={color}>{status}</span>
          }
        }
      ]
    } else if (savedRows.length > 0) {
      return [
        { headerName: 'Student ID', field: 'student_id', flex: 1, sortable: true, filter: true },
        { headerName: 'Subject Code', field: 'subject_code', flex: 1, sortable: true, filter: true },
        { headerName: 'Subject Name', field: 'subject_name', flex: 2, sortable: true, filter: true },
        { headerName: 'Year Level', field: 'year_level_name', flex: 1, sortable: true, filter: true },
        { headerName: 'Period', field: 'period_name', flex: 1, sortable: true, filter: true },
        { headerName: 'Raw Score', field: 'raw_score', flex: 1, sortable: true, filter: true },
        { headerName: 'Grade', field: 'grade', flex: 1, sortable: true, filter: true },
        { headerName: 'Categorization', field: 'categorization', flex: 2, sortable: true, filter: true },
        { 
          headerName: 'Status', 
          field: 'status', 
          flex: 1, 
          sortable: true, 
          filter: true,
          cellRenderer: (params) => {
            if (!params.value) return ''
            const status = params.value.toUpperCase()
            const color = status === 'PASS' ? 'text-green-600 font-semibold' : 'text-red-600 font-semibold'
            return <span className={color}>{status}</span>
          }
        },
        { headerName: 'Decision', field: 'decision', flex: 1, sortable: true, filter: true },
        { headerName: 'Remarks', field: 'remarks', flex: 2, sortable: true, filter: true }
      ]
    }
    return []
  }, [mappedData, savedRows, targetFields])

  const defaultColDef = useMemo(() => ({
    resizable: true,
    sortable: true,
    filter: true
  }), [])

  const displayData = mappedData.length > 0 ? mappedData : savedRows

  return (
    <div className="space-y-6">
      {/* Upload Section */}
      <div className="bg-white rounded-lg shadow-md border border-gray-200 p-6">
        <h2 className="text-xl font-bold text-gray-900 mb-4 flex items-center gap-2">
          <Upload className="text-primary-500" size={24} />
          Upload Deliberation Data
        </h2>

        <div className="space-y-4">
          <div className="flex items-center gap-4">
            <label className="inline-block">
              <input
                ref={fileInputRef}
                type="file"
                accept=".csv,.xlsx,.xls"
                onChange={handleFileSelect}
                className="hidden"
              />
              <span className="inline-block px-6 py-2 bg-primary-500 text-white rounded-lg hover:bg-primary-600 cursor-pointer font-semibold">
                Choose CSV/XLSX File
              </span>
            </label>

            {fileType === 'xlsx' && sheets.length > 1 && (
              <select
                value={selectedSheet}
                onChange={handleSheetChange}
                className="px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary-500"
              >
                {sheets.map(sheet => (
                  <option key={sheet} value={sheet}>{sheet}</option>
                ))}
              </select>
            )}

            <label className="flex items-center gap-2">
              <input
                type="checkbox"
                checked={hasHeaderRow}
                onChange={(e) => setHasHeaderRow(e.target.checked)}
                className="w-4 h-4"
              />
              <span className="text-sm text-gray-700">First row is headers</span>
            </label>
          </div>

            {!filterSchoolYearId || !filterSemesterId ? (
            <p className="text-sm text-amber-600 font-medium">
              Please select School Year and Semester in the filter above before uploading
            </p>
          ) : !computedAcademicSessionId ? (
            <p className="text-sm text-amber-600 font-medium">
              Academic session not available. Please check your filter selection.
            </p>
          ) : (
            <p className="text-sm text-green-600 font-medium">
              ✓ Ready to upload. Academic session ID: {computedAcademicSessionId}
            </p>
          )}
        </div>
      </div>

      {/* Column Mapping Section */}
      {showMapping && fileColumns.length > 0 && (
        <div className="bg-white rounded-lg shadow-md border border-gray-200 p-6">
          <h3 className="text-lg font-bold text-gray-900 mb-4">Column Mapping</h3>
          <div className="space-y-3">
            {targetFields.map(field => (
              <div key={field.key} className="flex items-center gap-4">
                <label className="w-48 text-sm font-medium text-gray-700">
                  {field.label} {field.required && <span className="text-red-500">*</span>}
                </label>
                <select
                  value={columnMapping[field.key] || ''}
                  onChange={(e) => setColumnMapping({ ...columnMapping, [field.key]: e.target.value })}
                  className="flex-1 px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary-500"
                >
                  <option value="">-- Select Column --</option>
                  {fileColumns.map(col => (
                    <option key={col} value={col}>{col}</option>
                  ))}
                </select>
              </div>
            ))}
            <div className="flex gap-2 mt-4">
              <button
                onClick={applyMapping}
                className="px-6 py-2 bg-primary-500 text-white rounded-lg hover:bg-primary-600 font-semibold"
              >
                Apply Mapping
              </button>
              <button
                onClick={() => setShowMapping(false)}
                className="px-6 py-2 bg-gray-300 text-gray-700 rounded-lg hover:bg-gray-400 font-semibold"
              >
                Cancel
              </button>
            </div>
          </div>
        </div>
      )}

      {/* Client-Side Validation Errors */}
      {validationErrors.length > 0 && (
        <div className="bg-red-50 border border-red-200 rounded-lg p-4">
          <div className="flex items-center gap-2 mb-2">
            <AlertCircle className="text-red-600" size={20} />
            <h3 className="text-lg font-bold text-red-900">
              Validation Errors ({validationErrors.length})
            </h3>
          </div>
          <div className="max-h-48 overflow-y-auto space-y-1">
            {validationErrors.slice(0, 20).map((error, idx) => (
              <div key={idx} className="text-sm text-red-700">
                Row {error.row}: {error.message}
              </div>
            ))}
            {validationErrors.length > 20 && (
              <div className="text-sm text-red-600 font-medium">
                ... and {validationErrors.length - 20} more errors
              </div>
            )}
          </div>
        </div>
      )}

      {/* Server-Side Errors */}
      {serverErrors.length > 0 && (
        <div className="bg-amber-50 border border-amber-200 rounded-lg p-4">
          <div className="flex items-center gap-2 mb-3">
            <AlertCircle className="text-amber-600" size={20} />
            <h3 className="text-lg font-bold text-amber-900">
              Server Validation Errors ({serverErrors.length})
            </h3>
          </div>
          
          <div className="mb-3">
            {(() => {
              const errorSummary = {}
              serverErrors.forEach(err => {
                const key = `${err.reason}${err.value ? `: ${err.value}` : ''}`
                errorSummary[key] = (errorSummary[key] || [])
                errorSummary[key].push(err.row)
              })
              
              return (
                <div className="space-y-2">
                  {Object.entries(errorSummary).slice(0, 5).map(([error, rows], idx) => (
                    <div key={idx} className="text-sm">
                      <span className="font-semibold text-amber-900">{error}</span>
                      <div className="text-amber-700 ml-4">
                        Affected rows: {rows.length <= 5 ? rows.join(', ') : `${rows.slice(0, 5).join(', ')} + ${rows.length - 5} more`}
                      </div>
                    </div>
                  ))}
                  {Object.keys(errorSummary).length > 5 && (
                    <div className="text-sm text-amber-600 font-medium">
                      ... and {Object.keys(errorSummary).length - 5} more error types
                    </div>
                  )}
                </div>
              )
            })()}
          </div>
          
          <button
            onClick={() => setServerErrors([])}
            className="text-sm text-amber-700 hover:text-amber-900 font-medium underline"
          >
            Dismiss
          </button>
        </div>
      )}

      {/* Action Buttons */}
      {mappedData.length > 0 && (
        <div className="bg-white rounded-lg shadow-md border border-gray-200 p-4">
          <div className="flex items-center justify-between">
            <div className="flex items-center gap-2">
              <CheckCircle className="text-green-500" size={20} />
              <span className="font-medium text-gray-700">
                {mappedData.length} rows mapped
                {validationErrors.length === 0 ? ' - Ready to save' : ` - ${validationErrors.length} errors to fix`}
              </span>
            </div>
            <div className="flex gap-2">
              <button
                onClick={handleSave}
                disabled={isSaving || validationErrors.length > 0 || !computedAcademicSessionId}
                className={`px-6 py-2 rounded-lg font-semibold flex items-center gap-2 ${
                  isSaving || validationErrors.length > 0 || !computedAcademicSessionId
                    ? 'bg-gray-300 text-gray-500 cursor-not-allowed'
                    : 'bg-green-500 text-white hover:bg-green-600'
                }`}
              >
                <Save size={18} />
                {isSaving ? 'Saving...' : 'Save to Database'}
              </button>
            </div>
          </div>
        </div>
      )}

      {/* Data Grid */}
      {displayData.length > 0 && (
        <div className="bg-white rounded-lg shadow-md border border-gray-200 p-6">
          <div className="flex items-center justify-between mb-4">
            <h3 className="text-lg font-bold text-gray-900">
              {mappedData.length > 0 ? 'Preview Data' : 'Saved Deliberations'} ({displayData.length} records)
            </h3>
            <div className="flex gap-2">
              {savedRows.length > 0 && (
                <>
                  <button
                    onClick={fetchDeliberations}
                    disabled={isLoading}
                    className="px-4 py-2 bg-blue-500 text-white rounded-lg hover:bg-blue-600 font-semibold flex items-center gap-2"
                  >
                    <RefreshCw size={18} className={isLoading ? 'animate-spin' : ''} />
                    Refresh
                  </button>
                  <button
                    onClick={exportToCSV}
                    className="px-4 py-2 bg-gray-500 text-white rounded-lg hover:bg-gray-600 font-semibold flex items-center gap-2"
                  >
                    <FileText size={18} />
                    Export CSV
                  </button>
                </>
              )}
            </div>
          </div>
          <div style={{ height: 600, width: '100%' }}>
            <AgGridReact
              theme={agGridTheme}
              rowData={displayData}
              columnDefs={gridColumns}
              defaultColDef={defaultColDef}
              pagination={true}
              paginationPageSize={20}
              rowSelection="multiple"
            />
          </div>
        </div>
      )}

      {/* Batch History */}
      {batches.length > 0 && (
        <div className="bg-white rounded-lg shadow-md border border-gray-200 p-6">
          <h3 className="text-lg font-bold text-gray-900 mb-4">Upload History</h3>
          <div className="overflow-x-auto">
            <table className="min-w-full divide-y divide-gray-200">
              <thead className="bg-gray-50">
                <tr>
                  <th className="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase">File Name</th>
                  <th className="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase">Rows</th>
                  <th className="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase">Uploaded At</th>
                </tr>
              </thead>
              <tbody className="bg-white divide-y divide-gray-200">
                {batches.slice(0, 10).map(batch => (
                  <tr key={batch.upload_id}>
                    <td className="px-4 py-3 text-sm text-gray-900">{batch.file_name}</td>
                    <td className="px-4 py-3 text-sm text-gray-600">{batch.row_count || 0}</td>
                    <td className="px-4 py-3 text-sm text-gray-600">
                      {new Date(batch.uploaded_at).toLocaleString()}
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>
      )}

      {!file && savedRows.length === 0 && (
        <div className="bg-white rounded-lg shadow-md border border-gray-200 p-12 text-center">
          <FileText className="mx-auto mb-4 text-gray-400" size={48} />
          <p className="text-gray-600">Upload a CSV or Excel file to get started</p>
        </div>
      )}
    </div>
  )
}

