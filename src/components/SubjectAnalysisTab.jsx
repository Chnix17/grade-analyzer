import React, { useMemo } from "react"
import { AgGridReact } from "ag-grid-react"
import { themeQuartz } from "ag-grid-community"
import { BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip, Legend, ResponsiveContainer, Brush } from "recharts"
import { Search, Download } from "lucide-react"
import * as XLSX from "xlsx"

const agGridTheme = themeQuartz

export default function SubjectAnalysisTab({
  subjectAnalysis,
  subjectPerformance,
  searchTerm,
  setSearchTerm,
  selectedSemester,
  setSelectedSemester
}) {
  const filteredData = useMemo(() => {
    return subjectAnalysis
      .filter(item => {
        const matchesSearch = searchTerm === "" || 
          item.subject_name.toLowerCase().includes(searchTerm.toLowerCase()) ||
          (item.subject_code && item.subject_code.toLowerCase().includes(searchTerm.toLowerCase()))
        const matchesSemester = selectedSemester === "all" || 
          item.semester_code === selectedSemester
        return matchesSearch && matchesSemester
      })
      .map(item => ({
        ...item,
        combined_green_percentage: parseFloat(item.mp_percentage) + parseFloat(item.ehp_percentage)
      }))
  }, [subjectAnalysis, searchTerm, selectedSemester])

  const columnDefs = useMemo(() => [
    { headerName: "Code", field: "subject_code", flex: 0.8, sortable: true, filter: true, pinned: 'left' },
    { headerName: "Subject", field: "subject_name", flex: 1.5, sortable: true, filter: true, pinned: 'left' },
    { headerName: "Year Level", field: "year_level_name", flex: 0.8, sortable: true, filter: true },
    { headerName: "Semester", field: "semester_code", flex: 1, sortable: true, filter: true },
    { headerName: "Takers", field: "total_takers", flex: 0.7, sortable: true },
    { 
      headerName: "NMS Count", 
      field: "nms_count", 
      flex: 0.7,
      cellStyle: { backgroundColor: "#fee2e2", color: "#991b1b", fontWeight: "600" } 
    },
    { 
      headerName: "NMS %", 
      field: "nms_percentage", 
      flex: 0.7,
      valueFormatter: params => `${params.value}%`,
      cellStyle: { backgroundColor: "#fee2e2", color: "#991b1b" } 
    },
    { 
      headerName: "PTS Count", 
      field: "pts_count", 
      flex: 0.7,
      cellStyle: { backgroundColor: "#fef3c7", color: "#92400e", fontWeight: "600" } 
    },
    { 
      headerName: "PTS %", 
      field: "pts_percentage", 
      flex: 0.7,
      valueFormatter: params => `${params.value}%`,
      cellStyle: { backgroundColor: "#fef3c7", color: "#92400e" } 
    },
    { 
      headerName: "MP Count", 
      field: "mp_count", 
      flex: 0.7,
      cellStyle: { backgroundColor: "#dcfce7", color: "#166534", fontWeight: "600" } 
    },
    { 
      headerName: "MP %", 
      field: "mp_percentage", 
      flex: 0.7,
      valueFormatter: params => `${params.value}%`,
      cellStyle: { backgroundColor: "#dcfce7", color: "#166534" } 
    },
    { 
      headerName: "EHP Count", 
      field: "ehp_count", 
      flex: 0.7,
      cellStyle: { backgroundColor: "#d1fae5", color: "#065f46", fontWeight: "600" } 
    },
    { 
      headerName: "EHP %", 
      field: "ehp_percentage", 
      flex: 0.7,
      valueFormatter: params => `${params.value}%`,
      cellStyle: { backgroundColor: "#d1fae5", color: "#065f46" } 
    },
    {
      headerName: "Pass Rate",
      field: "pass_rate",
      flex: 0.8,
      sortable: true,
      valueFormatter: params => `${params.value}%`,
      cellStyle: params => {
        const val = params.value
        if (val >= 75) return { backgroundColor: "#dcfce7", color: "#166534", fontWeight: "600" }
        if (val >= 50) return { backgroundColor: "#d1fae5", color: "#065f46", fontWeight: "600" }
        if (val >= 25) return { backgroundColor: "#fef3c7", color: "#92400e", fontWeight: "600" }
        return { backgroundColor: "#fee2e2", color: "#991b1b", fontWeight: "600" }
      }
    },
    { 
      headerName: "Status", 
      field: "performance_status", 
      flex: 0.8,
      sortable: true,
      filter: true
    },
  ], [])

  const defaultColDef = useMemo(() => ({
    resizable: true,
    sortable: true,
    filter: true,
  }), [])

  const exportToExcel = () => {
    const ws = XLSX.utils.json_to_sheet(filteredData)
    const wb = XLSX.utils.book_new()
    XLSX.utils.book_append_sheet(wb, ws, "Subject Analysis")
    XLSX.writeFile(wb, "subject_analysis.xlsx")
  }

  const semesters = useMemo(() => {
    return Array.from(new Set(subjectAnalysis.map(s => s.semester_code)))
  }, [subjectAnalysis])

  return (
    <div className="space-y-6">
      {/* Filters */}
      <div className="bg-white rounded-lg shadow-md border border-gray-200 p-4">
        <div className="flex flex-wrap gap-4">
          <div className="flex-1 min-w-[250px]">
            <div className="relative">
              <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400" size={18} />
              <input
                type="text"
                placeholder="Search by code or subject name..."
                value={searchTerm}
                onChange={(e) => setSearchTerm(e.target.value)}
                className="w-full pl-10 pr-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary-500"
              />
            </div>
          </div>
          <select
            value={selectedSemester}
            onChange={(e) => setSelectedSemester(e.target.value)}
            className="px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary-500"
          >
            <option value="all">All Semesters</option>
            {semesters.map(sem => (
              <option key={sem} value={sem}>{sem}</option>
            ))}
          </select>
          <button
            onClick={exportToExcel}
            className="flex items-center gap-2 px-4 py-2 bg-primary-500 text-white rounded-lg hover:bg-primary-600 transition shadow-md"
          >
            <Download size={16} />
            Export
          </button>
        </div>
      </div>

      {/* Data Grid */}
      <div className="bg-white rounded-lg shadow-md border border-gray-200 p-6">
        <h2 className="text-xl font-bold text-gray-900 mb-4">
          Subject Performance Analysis ({filteredData.length} subjects)
        </h2>
        <div style={{ height: 600, width: "100%" }}>
          <AgGridReact
            theme={agGridTheme}
            rowData={filteredData}
            columnDefs={columnDefs}
            defaultColDef={defaultColDef}
            pagination={true}
            paginationPageSize={20}
          />
        </div>
      </div>

      {/* Performance Zone Chart with Brush */}
      {filteredData.length > 0 && (
        <div className="bg-white rounded-lg shadow-md border border-gray-200 p-6">
          <h3 className="text-lg font-bold text-gray-900 mb-4">Performance Zone Distribution by Subject</h3>
          <div className="mb-4 flex gap-4 text-sm">
            <div className="flex items-center gap-2">
              <div className="w-4 h-4 rounded" style={{ backgroundColor: "#ef4444" }}></div>
              <span className="font-semibold">RED Zone (NMS)</span>
            </div>
            <div className="flex items-center gap-2">
              <div className="w-4 h-4 rounded" style={{ backgroundColor: "#eab308" }}></div>
              <span className="font-semibold">YELLOW Zone (PTS)</span>
            </div>
            <div className="flex items-center gap-2">
              <div className="w-4 h-4 rounded" style={{ backgroundColor: "#22c55e" }}></div>
              <span className="font-semibold">GREEN Zone (M/P + E/HP)</span>
            </div>
          </div>
          <ResponsiveContainer width="100%" height={600}>
            <BarChart 
              data={filteredData}
              margin={{ top: 20, right: 30, left: 20, bottom: 100 }}
            >
              <CartesianGrid strokeDasharray="3 3" />
              <XAxis 
                dataKey="subject_code" 
                angle={-45}
                textAnchor="end"
                height={100}
                tick={{ fontSize: 11 }}
              />
              <YAxis 
                domain={[0, 100]} 
                label={{ value: 'Percentage (%)', angle: -90, position: 'insideLeft' }}
              />
              <Tooltip 
                formatter={(value) => `${value}%`}
                labelFormatter={(label) => {
                  const subject = filteredData.find(s => s.subject_code === label)
                  return subject ? `${subject.subject_code} - ${subject.subject_name}` : label
                }}
              />
              <Legend 
                wrapperStyle={{ paddingTop: '20px' }}
                iconType="square"
              />
              <Bar dataKey="nms_percentage" name="RED Zone (NMS)" stackId="a" fill="#ef4444" />
              <Bar dataKey="pts_percentage" name="YELLOW Zone (PTS)" stackId="a" fill="#eab308" />
              <Bar 
                dataKey="combined_green_percentage" 
                name="GREEN Zone (M/P + E/HP)" 
                stackId="a" 
                fill="#22c55e"
              />
              <Brush 
                dataKey="subject_code" 
                height={40} 
                stroke="#6366f1"
                travellerWidth={10}
                startIndex={0}
                endIndex={Math.min(19, filteredData.length - 1)}
              />
            </BarChart>
          </ResponsiveContainer>
          <p className="text-sm text-gray-500 mt-2">
            Use the brush control at the bottom to navigate through all subjects. Drag the handles to zoom in/out.
          </p>
        </div>
      )}
    </div>
  )
}
