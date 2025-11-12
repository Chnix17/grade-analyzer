import { useState, useEffect, useMemo } from "react"
import { AgGridReact } from "ag-grid-react"
import { themeQuartz } from "ag-grid-community"
import { RefreshCw, FileText, Download, BarChart3 } from "lucide-react"
import * as XLSX from "xlsx"
import { API_BASE } from "../utils/gradeHelpers"
import SubjectDeliberationAnalytics from "./SubjectDeliberationAnalytics"
import TabButton from "./TabButton"

const agGridTheme = themeQuartz

export default function SubjectDeliberationView({
  filterSchoolYearId,
  filterSemesterId,
  schoolYears,
  semesters,
  addToast
}) {
  const [deliberationData, setDeliberationData] = useState([])
  const [isLoading, setIsLoading] = useState(false)
  const [activeTab, setActiveTab] = useState("data")

  const fetchDeliberations = async () => {
    try {
      setIsLoading(true)
      const params = new URLSearchParams()
      if (filterSchoolYearId) params.append('school_year_id', filterSchoolYearId)
      if (filterSemesterId) params.append('semester_id', filterSemesterId)
      params.append('all_periods', 'true')
      const queryString = params.toString() ? `&${params.toString()}` : ''
      
      const response = await fetch(`${API_BASE}/subject_deliberations.php?action=getRows${queryString}`)
      const result = await response.json()
      
      if (result.status === 'success') {
        const transformedData = transformToExcelFormat(result.data)
        setDeliberationData(transformedData)
      } else {
        if (addToast) addToast(`Error: ${result.message}`, 'error')
      }
    } catch (error) {
      console.error('Error fetching deliberations:', error)
      if (addToast) addToast('Failed to fetch deliberations', 'error')
    } finally {
      setIsLoading(false)
    }
  }

  useEffect(() => {
    if (filterSchoolYearId && filterSemesterId) {
      fetchDeliberations()
    }
  }, [filterSchoolYearId, filterSemesterId])

  const transformToExcelFormat = (data) => {
    const grouped = {}
    
    data.forEach(row => {
      const key = `${row.student_id}_${row.subject_code}_${row.year_level_name}`
      
      if (!grouped[key]) {
        grouped[key] = {
          student_id: row.student_id,
          student_name: row.student_name || '',
          subject_code: row.subject_code,
          year_level: row.year_level_name,
          p1_grade: null,
          p1_categorization: null,
          p2_grade: null,
          p2_categorization: null,
          p3_grade: null,
          p3_categorization: null,
          fe_grade: null,
          fe_categorization: null,
          q1_grade: null,
          q1_categorization: null,
          q2_grade: null,
          q2_categorization: null,
          final_grade: null,
          final_categorization: null
        }
      }
      
      const periodName = row.period_name?.toLowerCase()
      
      if (periodName === 'q1' || periodName === 'p1') {
        grouped[key].p1_grade = row.grade
        grouped[key].p1_categorization = row.categorization
        grouped[key].q1_grade = row.grade
        grouped[key].q1_categorization = row.categorization
      } else if (periodName === 'q2' || periodName === 'p2') {
        grouped[key].p2_grade = row.grade
        grouped[key].p2_categorization = row.categorization
        grouped[key].q2_grade = row.grade
        grouped[key].q2_categorization = row.categorization
      } else if (periodName === 'p3') {
        grouped[key].p3_grade = row.grade
        grouped[key].p3_categorization = row.categorization
      } else if (periodName === 'fe') {
        grouped[key].fe_grade = row.grade
        grouped[key].fe_categorization = row.categorization
      } else if (periodName === 'final grade') {
        grouped[key].final_grade = row.grade
        grouped[key].final_categorization = row.categorization
      }
    })
    
    return Object.values(grouped)
  }

  const gridColumns = useMemo(() => [
    { 
      headerName: 'Students ID Number', 
      field: 'student_id', 
      flex: 1.2, 
      sortable: true, 
      filter: true,
      pinned: 'left',
      cellStyle: { fontWeight: '500' }
    },
    { 
      headerName: 'Students Name', 
      field: 'student_name', 
      flex: 2, 
      sortable: true, 
      filter: true,
      pinned: 'left',
      cellStyle: { fontWeight: '500' }
    },
    { 
      headerName: 'Subject Code', 
      field: 'subject_code', 
      flex: 1, 
      sortable: true, 
      filter: true,
      cellStyle: { fontWeight: '500' }
    },
    { 
      headerName: 'Year Level', 
      field: 'year_level', 
      flex: 0.8, 
      sortable: true, 
      filter: true
    },
    { 
      headerName: 'P1 Grade', 
      field: 'p1_grade', 
      flex: 0.8, 
      sortable: true, 
      filter: true,
      cellStyle: (params) => getGradeCellStyle(params.value)
    },
    { 
      headerName: 'P1 Categorization', 
      field: 'p1_categorization', 
      flex: 1.8, 
      sortable: true, 
      filter: true,
      cellStyle: { fontSize: '12px' }
    },
    { 
      headerName: 'P2 Grade', 
      field: 'p2_grade', 
      flex: 0.8, 
      sortable: true, 
      filter: true,
      cellStyle: (params) => getGradeCellStyle(params.value)
    },
    { 
      headerName: 'P2 Categorization', 
      field: 'p2_categorization', 
      flex: 1.8, 
      sortable: true, 
      filter: true,
      cellStyle: { fontSize: '12px' }
    },
    { 
      headerName: 'P3 Grade', 
      field: 'p3_grade', 
      flex: 0.8, 
      sortable: true, 
      filter: true,
      cellStyle: (params) => getGradeCellStyle(params.value)
    },
    { 
      headerName: 'P3 Categorization', 
      field: 'p3_categorization', 
      flex: 1.8, 
      sortable: true, 
      filter: true,
      cellStyle: { fontSize: '12px' }
    },
    { 
      headerName: 'FE Grade', 
      field: 'fe_grade', 
      flex: 0.8, 
      sortable: true, 
      filter: true,
      cellStyle: (params) => getGradeCellStyle(params.value)
    },
    { 
      headerName: 'FE Categorization', 
      field: 'fe_categorization', 
      flex: 1.8, 
      sortable: true, 
      filter: true,
      cellStyle: { fontSize: '12px' }
    },
    { 
      headerName: 'Q1 Grade', 
      field: 'q1_grade', 
      flex: 0.8, 
      sortable: true, 
      filter: true,
      cellStyle: (params) => getGradeCellStyle(params.value),
      hide: true
    },
    { 
      headerName: 'Q1 Categorization', 
      field: 'q1_categorization', 
      flex: 1.8, 
      sortable: true, 
      filter: true,
      cellStyle: { fontSize: '12px' },
      hide: true
    },
    { 
      headerName: 'Q2 Grade', 
      field: 'q2_grade', 
      flex: 0.8, 
      sortable: true, 
      filter: true,
      cellStyle: (params) => getGradeCellStyle(params.value),
      hide: true
    },
    { 
      headerName: 'Q2 Categorization', 
      field: 'q2_categorization', 
      flex: 1.8, 
      sortable: true, 
      filter: true,
      cellStyle: { fontSize: '12px' },
      hide: true
    },
    { 
      headerName: 'Final Grade', 
      field: 'final_grade', 
      flex: 0.8, 
      sortable: true, 
      filter: true,
      cellStyle: (params) => getGradeCellStyle(params.value, true)
    },
    { 
      headerName: 'Final Categorization', 
      field: 'final_categorization', 
      flex: 1.8, 
      sortable: true, 
      filter: true,
      cellStyle: { fontSize: '12px', fontWeight: '500' }
    }
  ], [])

  const getGradeCellStyle = (value, isFinal = false) => {
    if (!value || value === null) return { backgroundColor: '#f9fafb', color: '#9ca3af' }
    
    const grade = parseFloat(value)
    if (isNaN(grade)) return {}
    
    const baseStyle = isFinal ? { fontWeight: '600' } : { fontWeight: '500' }
    
    if (grade >= 75) return { ...baseStyle, backgroundColor: '#d1fae5', color: '#065f46' }
    if (grade >= 50) return { ...baseStyle, backgroundColor: '#fef3c7', color: '#92400e' }
    if (grade >= 25) return { ...baseStyle, backgroundColor: '#fed7aa', color: '#9a3412' }
    return { ...baseStyle, backgroundColor: '#fee2e2', color: '#991b1b' }
  }

  const defaultColDef = useMemo(() => ({
    resizable: true,
    sortable: true,
    filter: true
  }), [])

  const exportToExcel = () => {
    if (deliberationData.length === 0) {
      if (addToast) addToast('No data to export', 'warning')
      return
    }

    const exportData = deliberationData.map(row => ({
      'Students ID Number': row.student_id,
      'Students Name': row.student_name,
      'Subject Code': row.subject_code,
      'Year Level': row.year_level,
      'P1 Grade': row.p1_grade || '',
      'P1 Categorization': row.p1_categorization || '',
      'P2 Grade': row.p2_grade || '',
      'P2 Categorization': row.p2_categorization || '',
      'P3 Grade': row.p3_grade || '',
      'P3 Categorization': row.p3_categorization || '',
      'FE Grade': row.fe_grade || '',
      'FE Categorization': row.fe_categorization || '',
      'Q1 Grade': row.q1_grade || '',
      'Q1 Categorization': row.q1_categorization || '',
      'Q2 Grade': row.q2_grade || '',
      'Q2 Categorization': row.q2_categorization || '',
      'Final Grade': row.final_grade || '',
      'Final Categorization': row.final_categorization || ''
    }))

    const ws = XLSX.utils.json_to_sheet(exportData)
    const wb = XLSX.utils.book_new()
    XLSX.utils.book_append_sheet(wb, ws, 'Subject Deliberations')
    
    const syName = schoolYears?.find(sy => sy.school_year_id == filterSchoolYearId)?.year_label || 'SY'
    const semName = semesters?.find(sem => sem.semester_id == filterSemesterId)?.semester_name || 'Sem'
    const fileName = `Subject_Deliberation_Report_${syName}_${semName}_${Date.now()}.xlsx`
    
    XLSX.writeFile(wb, fileName)
    if (addToast) addToast('Excel file exported successfully', 'success')
  }

  const selectedSY = schoolYears?.find(sy => sy.school_year_id == filterSchoolYearId)
  const selectedSem = semesters?.find(sem => sem.semester_id == filterSemesterId)

  return (
    <div className="space-y-6">
      <div className="bg-white rounded-lg shadow-md border border-gray-200 p-6">
        <div className="flex items-center justify-between mb-4">
          <div>
            <h2 className="text-xl font-bold text-gray-900 flex items-center gap-2">
              <FileText className="text-primary-500" size={24} />
              Subject Level Deliberation Report
            </h2>
            {selectedSY && selectedSem && (
              <p className="text-sm text-gray-600 mt-1">
                School Year: <span className="font-semibold">{selectedSY.year_label}</span> | 
                Semester: <span className="font-semibold">{selectedSem.semester_name}</span>
              </p>
            )}
          </div>
          <div className="flex gap-2">
            <button
              onClick={fetchDeliberations}
              disabled={isLoading || !filterSchoolYearId || !filterSemesterId}
              className="px-4 py-2 bg-blue-500 text-white rounded-lg hover:bg-blue-600 font-semibold flex items-center gap-2 disabled:bg-gray-300 disabled:cursor-not-allowed"
            >
              <RefreshCw size={18} className={isLoading ? 'animate-spin' : ''} />
              Refresh
            </button>
            {activeTab === "data" && (
              <button
                onClick={exportToExcel}
                disabled={deliberationData.length === 0}
                className="px-4 py-2 bg-green-500 text-white rounded-lg hover:bg-green-600 font-semibold flex items-center gap-2 disabled:bg-gray-300 disabled:cursor-not-allowed"
              >
                <Download size={18} />
                Export Excel
              </button>
            )}
          </div>
        </div>

        <div className="flex gap-1 border-b border-gray-200 mb-6">
          <TabButton
            tab="data"
            label="Data View"
            icon={FileText}
            activeTab={activeTab}
            onClick={setActiveTab}
          />
          <TabButton
            tab="analytics"
            label="Analytics"
            icon={BarChart3}
            activeTab={activeTab}
            onClick={setActiveTab}
          />
        </div>

        {activeTab === "data" ? (
          <>
            {!filterSchoolYearId || !filterSemesterId ? (
              <div className="bg-amber-50 border border-amber-200 rounded-lg p-4 text-center">
                <p className="text-amber-700 font-medium">
                  Please select School Year and Semester from the filters above
                </p>
              </div>
            ) : deliberationData.length === 0 && !isLoading ? (
              <div className="bg-gray-50 border border-gray-200 rounded-lg p-12 text-center">
                <FileText className="mx-auto mb-4 text-gray-400" size={48} />
                <p className="text-gray-600">No deliberation records found for the selected filters</p>
              </div>
            ) : (
              <>
                <div className="mb-4 text-sm text-gray-600">
                  Showing <span className="font-semibold text-gray-900">{deliberationData.length}</span> student records
                </div>
                <div style={{ height: 700, width: '100%' }}>
                  <AgGridReact
                    theme={agGridTheme}
                    rowData={deliberationData}
                    columnDefs={gridColumns}
                    defaultColDef={defaultColDef}
                    pagination={true}
                    paginationPageSize={50}
                    rowSelection="multiple"
                    suppressRowClickSelection={true}
                    enableCellTextSelection={true}
                    loading={isLoading}
                  />
                </div>
              </>
            )}
          </>
        ) : (
          <SubjectDeliberationAnalytics
            filterSchoolYearId={filterSchoolYearId}
            filterSemesterId={filterSemesterId}
            schoolYears={schoolYears}
            semesters={semesters}
            addToast={addToast}
          />
        )}
      </div>
    </div>
  )
}
