import React, { useMemo } from "react"
import { AgGridReact } from "ag-grid-react"
import { themeQuartz } from "ag-grid-community"
import { BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip, Legend, ResponsiveContainer, Cell } from "recharts"
import { Download } from "lucide-react"
import * as XLSX from "xlsx"
import { API_BASE } from "../utils/gradeHelpers"

const agGridTheme = themeQuartz

export default function YearLevelSummaryTab({
  yearLevelData,
  filterSchoolYearId,
  filterSemesterId,
  filterPeriodId
}) {
  // Group data by period for display
  const groupedByPeriod = useMemo(() => {
    if (!yearLevelData || yearLevelData.length === 0) return {}
    
    const grouped = {}
    yearLevelData.forEach(item => {
      const periodName = item.period_name || 'No Period'
      if (!grouped[periodName]) {
        grouped[periodName] = []
      }
      grouped[periodName].push(item)
    })
    return grouped
  }, [yearLevelData])

  const columnDefs = useMemo(() => [
    { headerName: "Year Level", field: "year_level_name", flex: 1, sortable: true, filter: true, pinned: 'left' },
    { headerName: "Period", field: "period_name", flex: 0.8, sortable: true, filter: true },
    { headerName: "# of Subjects", field: "num_subjects", flex: 0.8, sortable: true },
    { 
      headerName: "# under Green Zone", 
      field: "green_zone_count", 
      flex: 1,
      cellStyle: { backgroundColor: "#dcfce7", color: "#166534", fontWeight: "600" } 
    },
    { 
      headerName: "% under Green Zone", 
      field: "green_zone_percentage", 
      flex: 1,
      valueFormatter: params => `${params.value}%`,
      cellStyle: { backgroundColor: "#dcfce7", color: "#166534" } 
    },
    { 
      headerName: "# under Yellow Zone", 
      field: "yellow_zone_count", 
      flex: 1,
      cellStyle: { backgroundColor: "#fef3c7", color: "#92400e", fontWeight: "600" } 
    },
    { 
      headerName: "% under Yellow Zone", 
      field: "yellow_zone_percentage", 
      flex: 1,
      valueFormatter: params => `${params.value}%`,
      cellStyle: { backgroundColor: "#fef3c7", color: "#92400e" } 
    },
    { 
      headerName: "# under Red Zone", 
      field: "red_zone_count", 
      flex: 1,
      cellStyle: { backgroundColor: "#fee2e2", color: "#991b1b", fontWeight: "600" } 
    },
    { 
      headerName: "% under Red Zone", 
      field: "red_zone_percentage", 
      flex: 1,
      valueFormatter: params => `${params.value}%`,
      cellStyle: { backgroundColor: "#fee2e2", color: "#991b1b" } 
    },
  ], [])

  const defaultColDef = useMemo(() => ({
    resizable: true,
    sortable: true,
    filter: true,
  }), [])

  const exportToExcel = () => {
    const ws = XLSX.utils.json_to_sheet(yearLevelData || [])
    const wb = XLSX.utils.book_new()
    XLSX.utils.book_append_sheet(wb, ws, "Year Level Summary")
    XLSX.writeFile(wb, "year_level_summary.xlsx")
  }

  if (!yearLevelData || yearLevelData.length === 0) {
    return (
      <div className="bg-white rounded-lg shadow-md border border-gray-200 p-12 text-center">
        <p className="text-gray-600 text-lg">No year level data available. Please select filters and load data.</p>
      </div>
    )
  }

  return (
    <div className="space-y-6">
      {/* Header with Export */}
      <div className="bg-white rounded-lg shadow-md border border-gray-200 p-4">
        <div className="flex items-center justify-between">
          <h2 className="text-xl font-bold text-gray-900">
            Year Level Summary ({yearLevelData.length} records)
          </h2>
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
        <div style={{ height: 600, width: "100%" }}>
          <AgGridReact
            theme={agGridTheme}
            rowData={yearLevelData}
            columnDefs={columnDefs}
            defaultColDef={defaultColDef}
            pagination={true}
            paginationPageSize={20}
          />
        </div>
      </div>

      {/* Charts by Period */}
      {Object.keys(groupedByPeriod).length > 0 && (
        <div className="space-y-6">
          {Object.keys(groupedByPeriod).sort().map(period => {
            const periodData = groupedByPeriod[period]
            const chartData = periodData.map(item => ({
              yearLevel: item.year_level_name,
              green: parseFloat(item.green_zone_percentage),
              yellow: parseFloat(item.yellow_zone_percentage),
              red: parseFloat(item.red_zone_percentage),
            }))

            return (
              <div key={period} className="bg-white rounded-lg shadow-md border border-gray-200 p-6">
                <h3 className="text-lg font-bold text-gray-900 mb-4">
                  {period} - Performance Zone Distribution by Year Level
                </h3>
                <div className="mb-4 flex gap-4 text-sm">
                  <div className="flex items-center gap-2">
                    <div className="w-4 h-4 rounded" style={{ backgroundColor: "#22c55e" }}></div>
                    <span className="font-semibold">Green Zone (MP + EHP)</span>
                  </div>
                  <div className="flex items-center gap-2">
                    <div className="w-4 h-4 rounded" style={{ backgroundColor: "#eab308" }}></div>
                    <span className="font-semibold">Yellow Zone (PTS)</span>
                  </div>
                  <div className="flex items-center gap-2">
                    <div className="w-4 h-4 rounded" style={{ backgroundColor: "#ef4444" }}></div>
                    <span className="font-semibold">Red Zone (NMS)</span>
                  </div>
                </div>
                <ResponsiveContainer width="100%" height={300}>
                  <BarChart data={chartData}>
                    <CartesianGrid strokeDasharray="3 3" />
                    <XAxis dataKey="yearLevel" />
                    <YAxis domain={[0, 100]} label={{ value: 'Percentage (%)', angle: -90, position: 'insideLeft' }} />
                    <Tooltip formatter={(value) => `${value}%`} />
                    <Legend />
                    <Bar dataKey="red" name="Red Zone (NMS)" stackId="a" fill="#ef4444" />
                    <Bar dataKey="yellow" name="Yellow Zone (PTS)" stackId="a" fill="#eab308" />
                    <Bar dataKey="green" name="Green Zone (MP + EHP)" stackId="a" fill="#22c55e" />
                  </BarChart>
                </ResponsiveContainer>
              </div>
            )
          })}
        </div>
      )}
    </div>
  )
}

