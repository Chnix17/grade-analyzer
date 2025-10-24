import React, { useMemo } from "react"
import { AgGridReact } from "ag-grid-react"
import { themeQuartz } from "ag-grid-community"
import { Search, Download } from "lucide-react"
import * as XLSX from "xlsx"

const agGridTheme = themeQuartz

export default function StudentAnalysisTab({ studentAnalysis, searchTerm, setSearchTerm, selectedSemester, setSelectedSemester }) {
  const filteredData = useMemo(() => {
    return studentAnalysis.filter(item => {
      const matchesSearch = searchTerm === "" || 
        item.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
        item.student_id.toLowerCase().includes(searchTerm.toLowerCase())
      const matchesSemester = selectedSemester === "all" || item.semester_code === selectedSemester
      return matchesSearch && matchesSemester
    })
  }, [studentAnalysis, searchTerm, selectedSemester])

  const columnDefs = useMemo(() => [
    { headerName: "Student ID", field: "student_id", flex: 1, sortable: true, filter: true, pinned: 'left' },
    { headerName: "Name", field: "name", flex: 1.5, sortable: true, filter: true, pinned: 'left' },
    { headerName: "Semester", field: "semester_code", flex: 0.8, sortable: true },
    { headerName: "Subjects", field: "total_subjects", flex: 0.7, sortable: true },
    {
      headerName: "Avg Grade", field: "average_grade", flex: 0.8, sortable: true,
      cellStyle: params => {
        const val = params.value
        if (val >= 75) return { backgroundColor: "#dcfce7", color: "#166534", fontWeight: "600" }
        if (val >= 50) return { backgroundColor: "#d1fae5", color: "#065f46", fontWeight: "600" }
        return { backgroundColor: "#fef3c7", color: "#92400e", fontWeight: "600" }
      }
    },
    { headerName: "Pass Rate", field: "pass_rate", flex: 0.8, valueFormatter: params => `${params.value}%` },
    { headerName: "Pass", field: "pass_count", flex: 0.6, cellStyle: { color: "#166534", fontWeight: "600" } },
    { headerName: "Fail", field: "fail_count", flex: 0.6, cellStyle: { color: "#991b1b", fontWeight: "600" } },
  ], [])

  const defaultColDef = useMemo(() => ({ resizable: true, sortable: true, filter: true }), [])

  const exportToExcel = () => {
    const ws = XLSX.utils.json_to_sheet(filteredData)
    const wb = XLSX.utils.book_new()
    XLSX.utils.book_append_sheet(wb, ws, "Student Analysis")
    XLSX.writeFile(wb, "student_analysis.xlsx")
  }

  const semesters = useMemo(() => Array.from(new Set(studentAnalysis.map(s => s.semester_code))), [studentAnalysis])

  return (
    <div className="space-y-6">
      <div className="bg-white rounded-lg shadow-md border border-gray-200 p-4">
        <div className="flex flex-wrap gap-4">
          <div className="flex-1 min-w-[250px]">
            <div className="relative">
              <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400" size={18} />
              <input type="text" placeholder="Search students..." value={searchTerm} onChange={(e) => setSearchTerm(e.target.value)}
                className="w-full pl-10 pr-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary-500" />
            </div>
          </div>
          <select value={selectedSemester} onChange={(e) => setSelectedSemester(e.target.value)}
            className="px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary-500">
            <option value="all">All Semesters</option>
            {semesters.map(sem => <option key={sem} value={sem}>{sem}</option>)}
          </select>
          <button onClick={exportToExcel} className="flex items-center gap-2 px-4 py-2 bg-primary-500 text-white rounded-lg hover:bg-primary-600 transition shadow-md">
            <Download size={16} /> Export
          </button>
        </div>
      </div>

      <div className="bg-white rounded-lg shadow-md border border-gray-200 p-6">
        <h2 className="text-xl font-bold text-gray-900 mb-4">Student Performance Analysis ({filteredData.length} students)</h2>
        <div style={{ height: 600, width: "100%" }}>
          <AgGridReact theme={agGridTheme} rowData={filteredData} columnDefs={columnDefs} defaultColDef={defaultColDef} pagination={true} paginationPageSize={20} />
        </div>
      </div>
    </div>
  )
}
