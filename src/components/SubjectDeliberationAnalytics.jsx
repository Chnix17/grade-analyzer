import { useState, useEffect, useMemo } from "react"
import { AgGridReact } from "ag-grid-react"
import { themeQuartz } from "ag-grid-community"
import { BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip, Legend, ResponsiveContainer, Brush, PieChart, Pie, Cell, LineChart, Line } from "recharts"
import { TrendingUp, Users, BookOpen, Award, AlertCircle, Download, Search } from "lucide-react"
import * as XLSX from "xlsx"
import { API_BASE } from "../utils/gradeHelpers"

const agGridTheme = themeQuartz

const COLORS = {
  nms: '#ef4444',
  pts: '#eab308', 
  ms: '#22c55e',
  ehp: '#10b981'
}

export default function SubjectDeliberationAnalytics({
  filterSchoolYearId,
  filterSemesterId,
  schoolYears,
  semesters,
  addToast
}) {
  const [analyticsData, setAnalyticsData] = useState(null)
  const [isLoading, setIsLoading] = useState(false)
  const [searchTerm, setSearchTerm] = useState("")
  const [selectedYearLevel, setSelectedYearLevel] = useState("all")
  const [selectedPeriod, setSelectedPeriod] = useState("all")

  const fetchAnalytics = async () => {
    if (!filterSchoolYearId || !filterSemesterId) return

    try {
      setIsLoading(true)
      const params = new URLSearchParams()
      params.append('school_year_id', filterSchoolYearId)
      params.append('semester_id', filterSemesterId)
      params.append('all_periods', 'true')
      
      const response = await fetch(`${API_BASE}/subject_deliberations.php?action=getAnalytics&${params.toString()}`)
      const result = await response.json()
      
      if (result.status === 'success') {
        setAnalyticsData(result.data)
      } else {
        if (addToast) addToast(`Error: ${result.message}`, 'error')
      }
    } catch (error) {
      console.error('Error fetching analytics:', error)
      if (addToast) addToast('Failed to fetch analytics', 'error')
    } finally {
      setIsLoading(false)
    }
  }

  useEffect(() => {
    fetchAnalytics()
  }, [filterSchoolYearId, filterSemesterId])

  const filteredSubjectData = useMemo(() => {
    if (!analyticsData?.subject_analytics) return []
    
    return analyticsData.subject_analytics.filter(item => {
      const matchesSearch = searchTerm === "" || 
        item.subject_name.toLowerCase().includes(searchTerm.toLowerCase()) ||
        item.subject_code.toLowerCase().includes(searchTerm.toLowerCase())
      const matchesYearLevel = selectedYearLevel === "all" || 
        item.year_level_name === selectedYearLevel
      const matchesPeriod = selectedPeriod === "all" || 
        item.period_name === selectedPeriod
      return matchesSearch && matchesYearLevel && matchesPeriod
    })
  }, [analyticsData, searchTerm, selectedYearLevel, selectedPeriod])

  const yearLevels = useMemo(() => {
    if (!analyticsData?.subject_analytics) return []
    return [...new Set(analyticsData.subject_analytics.map(s => s.year_level_name))].sort()
  }, [analyticsData])

  const periods = useMemo(() => {
    if (!analyticsData?.subject_analytics) return []
    return [...new Set(analyticsData.subject_analytics.map(s => s.period_name))].filter(p => p).sort()
  }, [analyticsData])

  const yearLevelSummary = useMemo(() => {
    if (!analyticsData?.subject_analytics) return []
    
    const grouped = {}
    analyticsData.subject_analytics.forEach(item => {
      const key = item.year_level_name
      if (!grouped[key]) {
        grouped[key] = {
          year_level: key,
          total_takers: 0,
          pass_count: 0,
          fail_count: 0,
          nms_count: 0,
          pts_count: 0,
          ms_count: 0,
          ehp_count: 0
        }
      }
      grouped[key].total_takers += parseInt(item.total_takers)
      grouped[key].pass_count += parseInt(item.pass_count)
      grouped[key].fail_count += parseInt(item.fail_count)
      grouped[key].nms_count += parseInt(item.nms_count)
      grouped[key].pts_count += parseInt(item.pts_count)
      grouped[key].ms_count += parseInt(item.ms_count)
      grouped[key].ehp_count += parseInt(item.ehp_count)
    })

    return Object.values(grouped).map(item => ({
      ...item,
      pass_rate: ((item.pass_count / (item.pass_count + item.fail_count)) * 100).toFixed(2),
      nms_percentage: ((item.nms_count / item.total_takers) * 100).toFixed(2),
      pts_percentage: ((item.pts_count / item.total_takers) * 100).toFixed(2),
      ms_percentage: ((item.ms_count / item.total_takers) * 100).toFixed(2),
      ehp_percentage: ((item.ehp_count / item.total_takers) * 100).toFixed(2)
    }))
  }, [analyticsData])

  const periodComparison = useMemo(() => {
    if (!analyticsData?.subject_analytics) return []
    
    const grouped = {}
    analyticsData.subject_analytics.forEach(item => {
      const key = item.period_name
      if (!key) return
      
      if (!grouped[key]) {
        grouped[key] = {
          period: key,
          total_records: 0,
          pass_count: 0,
          fail_count: 0,
          average_grade: 0,
          grade_sum: 0,
          record_count: 0
        }
      }
      grouped[key].total_records += parseInt(item.total_takers)
      grouped[key].pass_count += parseInt(item.pass_count)
      grouped[key].fail_count += parseInt(item.fail_count)
      grouped[key].grade_sum += parseFloat(item.average_grade) * parseInt(item.total_takers)
      grouped[key].record_count += parseInt(item.total_takers)
    })

    return Object.values(grouped).map(item => ({
      ...item,
      pass_rate: ((item.pass_count / (item.pass_count + item.fail_count)) * 100).toFixed(2),
      average_grade: (item.grade_sum / item.record_count).toFixed(2)
    })).sort((a, b) => a.period.localeCompare(b.period))
  }, [analyticsData])

  const overallZoneDistribution = useMemo(() => {
    if (!analyticsData?.subject_analytics) return []
    
    let nms = 0, pts = 0, ms = 0, ehp = 0
    analyticsData.subject_analytics.forEach(item => {
      nms += parseInt(item.nms_count)
      pts += parseInt(item.pts_count)
      ms += parseInt(item.ms_count)
      ehp += parseInt(item.ehp_count)
    })
    
    const total = nms + pts + ms + ehp
    return [
      { name: 'Not Meeting Standards', value: nms, percentage: ((nms/total)*100).toFixed(2), color: COLORS.nms },
      { name: 'Progressing Towards Standards', value: pts, percentage: ((pts/total)*100).toFixed(2), color: COLORS.pts },
      { name: 'Meeting Standards', value: ms, percentage: ((ms/total)*100).toFixed(2), color: COLORS.ms },
      { name: 'Excellent/Highly Proficient', value: ehp, percentage: ((ehp/total)*100).toFixed(2), color: COLORS.ehp }
    ]
  }, [analyticsData])

  const columnDefs = useMemo(() => [
    { headerName: "Code", field: "subject_code", flex: 0.8, sortable: true, filter: true, pinned: 'left' },
    { headerName: "Subject", field: "subject_name", flex: 1.5, sortable: true, filter: true, pinned: 'left' },
    { headerName: "Year Level", field: "year_level_name", flex: 0.8, sortable: true, filter: true },
    { headerName: "Period", field: "period_name", flex: 0.7, sortable: true, filter: true },
    { headerName: "Takers", field: "total_takers", flex: 0.7, sortable: true },
    { 
      headerName: "NMS", 
      field: "nms_count", 
      flex: 0.6,
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
      headerName: "PTS", 
      field: "pts_count", 
      flex: 0.6,
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
      headerName: "MS", 
      field: "ms_count", 
      flex: 0.6,
      cellStyle: { backgroundColor: "#dcfce7", color: "#166534", fontWeight: "600" } 
    },
    { 
      headerName: "MS %", 
      field: "ms_percentage", 
      flex: 0.7,
      valueFormatter: params => `${params.value}%`,
      cellStyle: { backgroundColor: "#dcfce7", color: "#166534" } 
    },
    { 
      headerName: "EHP", 
      field: "ehp_count", 
      flex: 0.6,
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
        const val = parseFloat(params.value)
        if (val >= 75) return { backgroundColor: "#dcfce7", color: "#166534", fontWeight: "600" }
        if (val >= 50) return { backgroundColor: "#fef3c7", color: "#92400e", fontWeight: "600" }
        return { backgroundColor: "#fee2e2", color: "#991b1b", fontWeight: "600" }
      }
    },
    { 
      headerName: "Avg Grade", 
      field: "average_grade", 
      flex: 0.8,
      sortable: true,
      valueFormatter: params => parseFloat(params.value).toFixed(2)
    }
  ], [])

  const defaultColDef = useMemo(() => ({
    resizable: true,
    sortable: true,
    filter: true,
  }), [])

  const exportToExcel = () => {
    if (!filteredSubjectData.length) {
      if (addToast) addToast('No data to export', 'warning')
      return
    }

    const ws = XLSX.utils.json_to_sheet(filteredSubjectData)
    const wb = XLSX.utils.book_new()
    XLSX.utils.book_append_sheet(wb, ws, "Subject Analytics")
    
    const syName = schoolYears?.find(sy => sy.school_year_id == filterSchoolYearId)?.year_label || 'SY'
    const semName = semesters?.find(sem => sem.semester_id == filterSemesterId)?.semester_name || 'Sem'
    XLSX.writeFile(wb, `Subject_Deliberation_Analytics_${syName}_${semName}.xlsx`)
    
    if (addToast) addToast('Excel file exported successfully', 'success')
  }

  if (!filterSchoolYearId || !filterSemesterId) {
    return (
      <div className="bg-amber-50 border border-amber-200 rounded-lg p-8 text-center">
        <AlertCircle className="mx-auto mb-4 text-amber-600" size={48} />
        <p className="text-amber-700 font-medium">
          Please select School Year and Semester to view analytics
        </p>
      </div>
    )
  }

  if (isLoading) {
    return (
      <div className="bg-white rounded-lg shadow-md border border-gray-200 p-12 text-center">
        <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-primary-500 mx-auto"></div>
        <p className="mt-4 text-gray-600">Loading analytics...</p>
      </div>
    )
  }

  if (!analyticsData) {
    return (
      <div className="bg-gray-50 border border-gray-200 rounded-lg p-12 text-center">
        <BookOpen className="mx-auto mb-4 text-gray-400" size={48} />
        <p className="text-gray-600">No analytics data available</p>
      </div>
    )
  }

  const stats = analyticsData.overall_stats

  return (
    <div className="space-y-6">
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
        <div className="bg-gradient-to-br from-blue-500 to-blue-600 rounded-lg shadow-md p-6 text-white">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-blue-100 text-sm font-medium">Total Students</p>
              <p className="text-3xl font-bold mt-1">{stats.total_students?.toLocaleString()}</p>
            </div>
            <Users className="text-blue-200" size={40} />
          </div>
        </div>

        <div className="bg-gradient-to-br from-purple-500 to-purple-600 rounded-lg shadow-md p-6 text-white">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-purple-100 text-sm font-medium">Total Subjects</p>
              <p className="text-3xl font-bold mt-1">{stats.total_subjects}</p>
            </div>
            <BookOpen className="text-purple-200" size={40} />
          </div>
        </div>

        <div className="bg-gradient-to-br from-green-500 to-green-600 rounded-lg shadow-md p-6 text-white">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-green-100 text-sm font-medium">Pass Rate</p>
              <p className="text-3xl font-bold mt-1">{stats.overall_pass_rate}%</p>
              <p className="text-sm text-green-100 mt-1">{parseInt(stats.total_pass).toLocaleString()} passed</p>
            </div>
            <TrendingUp className="text-green-200" size={40} />
          </div>
        </div>

        <div className="bg-gradient-to-br from-orange-500 to-orange-600 rounded-lg shadow-md p-6 text-white">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-orange-100 text-sm font-medium">Average Grade</p>
              <p className="text-3xl font-bold mt-1">{parseFloat(stats.overall_average_grade).toFixed(2)}</p>
              <p className="text-sm text-orange-100 mt-1">{stats.total_records?.toLocaleString()} records</p>
            </div>
            <Award className="text-orange-200" size={40} />
          </div>
        </div>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        <div className="bg-white rounded-lg shadow-md border border-gray-200 p-6">
          <h3 className="text-lg font-bold text-gray-900 mb-4">Performance Zone Distribution</h3>
          <ResponsiveContainer width="100%" height={300}>
            <PieChart>
              <Pie
                data={overallZoneDistribution}
                cx="50%"
                cy="50%"
                labelLine={false}
                label={({ percentage }) => `${percentage}%`}
                outerRadius={100}
                fill="#8884d8"
                dataKey="value"
              >
                {overallZoneDistribution.map((entry, index) => (
                  <Cell key={`cell-${index}`} fill={entry.color} />
                ))}
              </Pie>
              <Tooltip formatter={(value, name, props) => [`${value} students (${props.payload.percentage}%)`, props.payload.name]} />
              <Legend />
            </PieChart>
          </ResponsiveContainer>
        </div>

        <div className="bg-white rounded-lg shadow-md border border-gray-200 p-6">
          <h3 className="text-lg font-bold text-gray-900 mb-4">Period Performance Comparison</h3>
          <ResponsiveContainer width="100%" height={300}>
            <LineChart data={periodComparison}>
              <CartesianGrid strokeDasharray="3 3" />
              <XAxis dataKey="period" />
              <YAxis yAxisId="left" domain={[0, 100]} label={{ value: 'Pass Rate (%)', angle: -90, position: 'insideLeft' }} />
              <YAxis yAxisId="right" orientation="right" domain={[0, 100]} label={{ value: 'Avg Grade', angle: 90, position: 'insideRight' }} />
              <Tooltip />
              <Legend />
              <Line yAxisId="left" type="monotone" dataKey="pass_rate" stroke="#22c55e" strokeWidth={2} name="Pass Rate (%)" />
              <Line yAxisId="right" type="monotone" dataKey="average_grade" stroke="#3b82f6" strokeWidth={2} name="Avg Grade" />
            </LineChart>
          </ResponsiveContainer>
        </div>
      </div>

      <div className="bg-white rounded-lg shadow-md border border-gray-200 p-6">
        <h3 className="text-lg font-bold text-gray-900 mb-4">Year Level Performance Breakdown</h3>
        <ResponsiveContainer width="100%" height={400}>
          <BarChart data={yearLevelSummary}>
            <CartesianGrid strokeDasharray="3 3" />
            <XAxis dataKey="year_level" />
            <YAxis domain={[0, 100]} label={{ value: 'Percentage (%)', angle: -90, position: 'insideLeft' }} />
            <Tooltip formatter={(value) => `${value}%`} />
            <Legend />
            <Bar dataKey="nms_percentage" name="NMS" stackId="a" fill={COLORS.nms} />
            <Bar dataKey="pts_percentage" name="PTS" stackId="a" fill={COLORS.pts} />
            <Bar dataKey="ms_percentage" name="MS" stackId="a" fill={COLORS.ms} />
            <Bar dataKey="ehp_percentage" name="EHP" stackId="a" fill={COLORS.ehp} />
          </BarChart>
        </ResponsiveContainer>
      </div>

      <div className="bg-white rounded-lg shadow-md border border-gray-200 p-4">
        <div className="flex flex-wrap gap-4 mb-4">
          <div className="flex-1 min-w-[250px]">
            <div className="relative">
              <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400" size={18} />
              <input
                type="text"
                placeholder="Search by subject code or name..."
                value={searchTerm}
                onChange={(e) => setSearchTerm(e.target.value)}
                className="w-full pl-10 pr-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary-500"
              />
            </div>
          </div>
          <select
            value={selectedYearLevel}
            onChange={(e) => setSelectedYearLevel(e.target.value)}
            className="px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary-500"
          >
            <option value="all">All Year Levels</option>
            {yearLevels.map(yl => (
              <option key={yl} value={yl}>{yl}</option>
            ))}
          </select>
          <select
            value={selectedPeriod}
            onChange={(e) => setSelectedPeriod(e.target.value)}
            className="px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary-500"
          >
            <option value="all">All Periods</option>
            {periods.map(p => (
              <option key={p} value={p}>{p}</option>
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

      <div className="bg-white rounded-lg shadow-md border border-gray-200 p-6">
        <h2 className="text-xl font-bold text-gray-900 mb-4">
          Subject Performance Analysis ({filteredSubjectData.length} records)
        </h2>
        <div style={{ height: 600, width: "100%" }}>
          <AgGridReact
            theme={agGridTheme}
            rowData={filteredSubjectData}
            columnDefs={columnDefs}
            defaultColDef={defaultColDef}
            pagination={true}
            paginationPageSize={20}
          />
        </div>
      </div>

      {filteredSubjectData.length > 0 && (
        <div className="bg-white rounded-lg shadow-md border border-gray-200 p-6">
          <h3 className="text-lg font-bold text-gray-900 mb-4">Performance Distribution by Subject</h3>
          <div className="mb-4 flex gap-4 text-sm">
            <div className="flex items-center gap-2">
              <div className="w-4 h-4 rounded" style={{ backgroundColor: COLORS.nms }}></div>
              <span className="font-semibold">NMS (Not Meeting Standards)</span>
            </div>
            <div className="flex items-center gap-2">
              <div className="w-4 h-4 rounded" style={{ backgroundColor: COLORS.pts }}></div>
              <span className="font-semibold">PTS (Progressing Towards Standards)</span>
            </div>
            <div className="flex items-center gap-2">
              <div className="w-4 h-4 rounded" style={{ backgroundColor: COLORS.ms }}></div>
              <span className="font-semibold">MS (Meeting Standards)</span>
            </div>
            <div className="flex items-center gap-2">
              <div className="w-4 h-4 rounded" style={{ backgroundColor: COLORS.ehp }}></div>
              <span className="font-semibold">EHP (Excellent/Highly Proficient)</span>
            </div>
          </div>
          <ResponsiveContainer width="100%" height={600}>
            <BarChart 
              data={filteredSubjectData}
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
                  const subject = filteredSubjectData.find(s => s.subject_code === label)
                  return subject ? `${subject.subject_code} - ${subject.subject_name} (${subject.period_name})` : label
                }}
              />
              <Legend wrapperStyle={{ paddingTop: '20px' }} iconType="square" />
              <Bar dataKey="nms_percentage" name="NMS" stackId="a" fill={COLORS.nms} />
              <Bar dataKey="pts_percentage" name="PTS" stackId="a" fill={COLORS.pts} />
              <Bar dataKey="ms_percentage" name="MS" stackId="a" fill={COLORS.ms} />
              <Bar dataKey="ehp_percentage" name="EHP" stackId="a" fill={COLORS.ehp} />
              <Brush 
                dataKey="subject_code" 
                height={40} 
                stroke="#6366f1"
                travellerWidth={10}
                startIndex={0}
                endIndex={Math.min(19, filteredSubjectData.length - 1)}
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
