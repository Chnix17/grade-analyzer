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
  filterPeriodId,
  schoolYears,
  semesters,
  periods,
  academicSessionId,
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
  }, [filterSchoolYearId, filterSemesterId, filterPeriodId])

  const fetchDeliberations = async () => {
    try {
      setIsLoading(true)
      const params = new URLSearchParams()
      if (filterSchoolYearId) params.append('school_year_id', filterSchoolYearId)
      if (filterSemesterId) params.append('semester_id', filterSemesterId)
      if (filterPeriodId === 'all') {
        params.append('all_periods', 'true')
      } else if (filterPeriodId) {
        params.append('period_id', filterPeriodId)
      }
      const queryString = params.toString() ? `&${params.toString()}` : ''
      
      const response = await fetch(`${API_BASE}/subject_deliberations.php?action=getRows${queryString}`)
      const result = await response.json()
      if (result.status === 'success') {
        setSavedRows(result.data)
      }
    } catch (error) {
      console.error('Error fetching deliberations:', error)
      if (addToast) addToast('Failed to fetch deliberations', 'error')
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
        }
        setRawData(results.data)
        autoMapColumns(results.data)
      },
      error: (error) => {
        console.error('CSV parse error:', error)
        if (addToast) addToast('Error parsing CSV file', 'error')
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
        setSheets(sheetNames)
        if (sheetNames.length > 0) {
          setSelectedSheet(sheetNames[0])
          processSheet(workbook.Sheets[sheetNames[0]])
        }
      } catch (error) {
        console.error('Error parsing XLSX:', error)
        if (addToast) addToast('Error parsing Excel file', 'error')
      }
    }
    reader.readAsArrayBuffer(file)
  }

  const processSheet = (worksheet) => {
    const jsonData = XLSX.utils.sheet_to_json(worksheet, {
      header: hasHeaderRow ? 1 : undefined,
      defval: '',
      raw: false
    })
    
    if (jsonData.length === 0) {
      if (addToast) addToast('No data found in sheet', 'warning')
      return
    }

    setRawData(jsonData)
    autoMapColumns(jsonData)
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
      
      // Try exact match
      let matched = fileCols.find(col => {
        const colLower = col.toLowerCase().trim()
        return colLower === fieldLower || 
               colLower.includes(fieldLower) ||
               colLower === labelLower.replace(/\([^)]*\)/g, '').trim() ||
               (fieldLower === 'student_id' && (colLower.includes('student') && colLower.includes('id'))) ||
               (fieldLower === 'subject_id' && (colLower.includes('subject') && (colLower.includes('id') || colLower.includes('code')))) ||
               (fieldLower === 'year_level' && (colLower.includes('year') && colLower.includes('level')))
      })
      
      if (matched) {
        mapping[field.key] = matched
      }
    })
    
    setColumnMapping(mapping)
    setShowMapping(true)
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

      // Check for duplicates
      if (row.student_id && row.subject_id) {
        const key = `${row.student_id}_${row.subject_id}_${filterPeriodId || 'none'}`
        if (seenKeys.has(key)) {
          errors.push({
            row: index + 1,
            field: 'duplicate',
            message: 'Duplicate student_id + subject_id combination'
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
      if (filterPeriodId && filterPeriodId !== 'all') {
        formData.append('period_id', filterPeriodId)
      }

      const response = await fetch(`${API_BASE}/save_subject_deliberations.php`, {
        method: 'POST',
        body: formData
      })

      const result = await response.json()
      if (result.status === 'success') {
        if (addToast) addToast(`Successfully saved ${result.saved} records!`, 'success')
        if (result.errors && result.errors.length > 0) {
          console.warn('Server validation errors:', result.errors)
          if (addToast) addToast(`${result.errors.length} rows had validation errors`, 'warning')
        }
        fetchDeliberations()
        fetchBatches()
        // Reset upload state
        setFile(null)
        setRawData([])
        setMappedData([])
        setColumnMapping({})
        setValidationErrors([])
        setShowMapping(false)
        if (fileInputRef.current) {
          fileInputRef.current.value = ''
        }
      } else {
        if (addToast) addToast(`Error: ${result.message}`, 'error')
      }
    } catch (error) {
      console.error('Error saving:', error)
      if (addToast) addToast('Failed to save data', 'error')
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
      return targetFields.map(field => ({
        headerName: field.label,
        field: field.key,
        flex: 1,
        sortable: true,
        filter: true,
        resizable: true,
        cellRenderer: (params) => {
          if (params.colDef.field === 'status' && params.value) {
            const status = params.value.toUpperCase()
            const color = status === 'PASS' ? 'text-green-600' : 'text-red-600'
            return <span className={color}>{status}</span>
          }
          return params.value ?? ''
        }
      }))
    } else if (savedRows.length > 0) {
      return [
        { headerName: 'Student ID', field: 'student_id', flex: 1, sortable: true, filter: true },
        { headerName: 'Subject Code', field: 'subject_code', flex: 1, sortable: true, filter: true },
        { headerName: 'Subject Name', field: 'subject_name', flex: 2, sortable: true, filter: true },
        { headerName: 'Year Level', field: 'year_level_name', flex: 1, sortable: true, filter: true },
        { headerName: 'Period', field: 'period_name', flex: 1, sortable: true, filter: true },
        { headerName: 'Raw Score', field: 'raw_score', flex: 1, sortable: true, filter: true },
        { headerName: 'Grade', field: 'grade', flex: 1, sortable: true, filter: true },
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

      {/* Validation Errors */}
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

