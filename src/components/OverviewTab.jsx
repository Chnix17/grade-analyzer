import React from "react"
import { 
  BarChart, Bar, PieChart, Pie, Cell,
  XAxis, YAxis, CartesianGrid, Tooltip, Legend, ResponsiveContainer 
} from "recharts"
import { Users, BookOpen, TrendingUp, BarChart3, Award } from "lucide-react"
import { COLORS, CHART_COLORS } from "../utils/gradeHelpers"

export default function OverviewTab({
  overviewStats,
  topPerformers,
  categoryDistribution
}) {
  if (!overviewStats) {
    return (
      <div className="text-center py-12">
        <p className="text-gray-600">No data available. Please upload a file first.</p>
      </div>
    )
  }

  return (
    <div className="space-y-6">
      {/* Metrics Cards */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
        <div className="bg-white rounded-lg shadow-md border border-gray-200 p-6 hover:shadow-lg transition">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-gray-600 text-sm font-medium">Total Students</p>
              <p className="text-3xl font-bold text-gray-900 mt-2">{overviewStats.total_students}</p>
            </div>
            <Users className="text-primary-500" size={32} />
          </div>
        </div>

        <div className="bg-white rounded-lg shadow-md border border-gray-200 p-6 hover:shadow-lg transition">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-gray-600 text-sm font-medium">Total Subjects</p>
              <p className="text-3xl font-bold text-gray-900 mt-2">{overviewStats.total_subjects}</p>
            </div>
            <BookOpen className="text-primary-500" size={32} />
          </div>
        </div>

        <div className="bg-white rounded-lg shadow-md border border-gray-200 p-6 hover:shadow-lg transition">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-gray-600 text-sm font-medium">Overall Pass Rate</p>
              <p className="text-3xl font-bold text-primary-600 mt-2">{overviewStats.pass_rate}%</p>
            </div>
            <TrendingUp className="text-primary-500" size={32} />
          </div>
        </div>

        <div className="bg-white rounded-lg shadow-md border border-gray-200 p-6 hover:shadow-lg transition">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-gray-600 text-sm font-medium">Average Grade</p>
              <p className="text-3xl font-bold text-primary-600 mt-2">{overviewStats.overall_average_grade || overviewStats.overall_average}</p>
            </div>
            <BarChart3 className="text-primary-500" size={32} />
          </div>
        </div>
      </div>

      {/* Charts Row */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        {/* Category Distribution Pie Chart */}
        {categoryDistribution && categoryDistribution.length > 0 && (
          <div className="bg-white rounded-lg shadow-md border border-gray-200 p-6">
            <h3 className="text-lg font-bold text-gray-900 mb-4">Grade Category Distribution</h3>
            <ResponsiveContainer width="100%" height={300}>
              <PieChart>
                <Pie
                  data={categoryDistribution}
                  cx="50%"
                  cy="50%"
                  labelLine={false}
                  label={entry => `${entry.category}: ${entry.percentage}%`}
                  outerRadius={100}
                  fill="#8884d8"
                  dataKey="count"
                  nameKey="category"
                >
                  {categoryDistribution.map((entry, index) => (
                    <Cell key={`cell-${index}`} fill={COLORS[entry.category] || CHART_COLORS[index]} />
                  ))}
                </Pie>
                <Tooltip />
                <Legend />
              </PieChart>
            </ResponsiveContainer>
          </div>
        )}

        {/* Pass/Fail Distribution */}
        <div className="bg-white rounded-lg shadow-md border border-gray-200 p-6">
          <h3 className="text-lg font-bold text-gray-900 mb-4">Pass/Fail Distribution</h3>
          <ResponsiveContainer width="100%" height={300}>
            <BarChart
              data={[
                { name: 'Pass', value: overviewStats.total_pass },
                { name: 'Fail', value: overviewStats.total_fail }
              ]}
            >
              <CartesianGrid strokeDasharray="3 3" />
              <XAxis dataKey="name" />
              <YAxis />
              <Tooltip />
              <Legend />
              <Bar dataKey="value" fill="#8884d8">
                <Cell fill={COLORS.pass} />
                <Cell fill={COLORS.fail} />
              </Bar>
            </BarChart>
          </ResponsiveContainer>
        </div>
      </div>

      {/* Top Performing Subjects */}
      {topPerformers && topPerformers.length > 0 && (
        <div className="bg-white rounded-lg shadow-md border border-gray-200 p-6">
          <div className="flex items-center gap-2 mb-4">
            <Award className="text-yellow-500" size={24} />
            <h3 className="text-lg font-bold text-gray-900">Top 10 Performing Subjects</h3>
          </div>
          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            {topPerformers.map((subject, idx) => (
              <div key={idx} className="flex items-center justify-between p-3 bg-gray-50 rounded-lg hover:bg-primary-50 transition">
                <div className="flex items-center gap-3">
                  <div className="w-8 h-8 rounded-full bg-primary-500 text-white flex items-center justify-center font-bold">
                    {idx + 1}
                  </div>
                  <div>
                    <div className="font-semibold text-gray-900">{subject.subject_name}</div>
                    <div className="text-xs text-gray-600">{subject.year_level_name}</div>
                  </div>
                </div>
                <div className="text-right">
                  <div className="text-lg font-bold text-primary-600">{subject.pass_rate}%</div>
                  <div className="text-xs text-gray-600">{subject.total_takers} takers</div>
                </div>
              </div>
            ))}
          </div>
        </div>
      )}

      {/* Additional Stats */}
      <div className="bg-white rounded-lg shadow-md border border-gray-200 p-6">
        <h3 className="text-lg font-bold text-gray-900 mb-4">Statistics Summary</h3>
        <div className="grid grid-cols-2 md:grid-cols-3 gap-4">
          <div className="text-center p-4 bg-gray-50 rounded-lg hover:shadow-md transition">
            <div className="text-2xl font-bold text-gray-900">{overviewStats.total_records}</div>
            <div className="text-sm text-gray-600 mt-1">Total Records</div>
          </div>
          <div className="text-center p-4 bg-primary-50 rounded-lg hover:shadow-md transition">
            <div className="text-2xl font-bold text-primary-700">{overviewStats.total_pass}</div>
            <div className="text-sm text-primary-600 mt-1">Passed</div>
          </div>
          <div className="text-center p-4 bg-red-50 rounded-lg hover:shadow-md transition">
            <div className="text-2xl font-bold text-red-700">{overviewStats.total_fail}</div>
            <div className="text-sm text-red-600 mt-1">Failed</div>
          </div>
        </div>
      </div>
    </div>
  )
}
