import React from "react"
import { LineChart, Line, BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip, Legend, ResponsiveContainer } from "recharts"

export default function ComparisonTab({ semesterComparison }) {
  if (!semesterComparison || semesterComparison.length === 0) {
    return (
      <div className="text-center py-12">
        <p className="text-gray-600">No semester data available.</p>
      </div>
    )
  }

  return (
    <div className="space-y-6">
      <div className="bg-white rounded-lg shadow-md border border-gray-200 p-6">
        <h3 className="text-lg font-bold text-gray-900 mb-4">Semester Performance Trends</h3>
        <ResponsiveContainer width="100%" height={400}>
          <LineChart data={semesterComparison}>
            <CartesianGrid strokeDasharray="3 3" />
            <XAxis dataKey="semester_code" />
            <YAxis />
            <Tooltip />
            <Legend />
            <Line type="monotone" dataKey="average_grade" stroke="#3A6F43" name="Avg Grade" strokeWidth={2} />
            <Line type="monotone" dataKey="pass_rate" stroke="#5daf82" name="Pass Rate %" strokeWidth={2} />
          </LineChart>
        </ResponsiveContainer>
      </div>

      <div className="bg-white rounded-lg shadow-md border border-gray-200 p-6">
        <h3 className="text-lg font-bold text-gray-900 mb-4">Pass vs Fail Comparison</h3>
        <ResponsiveContainer width="100%" height={400}>
          <BarChart data={semesterComparison}>
            <CartesianGrid strokeDasharray="3 3" />
            <XAxis dataKey="semester_code" />
            <YAxis />
            <Tooltip />
            <Legend />
            <Bar dataKey="pass_count" fill="#3A6F43" name="Passed" />
            <Bar dataKey="fail_count" fill="#ef4444" name="Failed" />
          </BarChart>
        </ResponsiveContainer>
      </div>

      <div className="bg-white rounded-lg shadow-md border border-gray-200 p-6">
        <h3 className="text-lg font-bold text-gray-900 mb-4">Semester Statistics</h3>
        <div className="overflow-x-auto">
          <table className="w-full text-sm">
            <thead className="bg-gray-50">
              <tr>
                <th className="px-4 py-3 text-left font-semibold text-gray-700">Semester</th>
                <th className="px-4 py-3 text-right font-semibold text-gray-700">Students</th>
                <th className="px-4 py-3 text-right font-semibold text-gray-700">Total Grades</th>
                <th className="px-4 py-3 text-right font-semibold text-gray-700">Avg Grade</th>
                <th className="px-4 py-3 text-right font-semibold text-gray-700">Pass Rate</th>
                <th className="px-4 py-3 text-right font-semibold text-gray-700">Passed</th>
                <th className="px-4 py-3 text-right font-semibold text-gray-700">Failed</th>
              </tr>
            </thead>
            <tbody>
              {semesterComparison.map((sem, idx) => (
                <tr key={idx} className="border-t border-gray-200 hover:bg-gray-50 transition">
                  <td className="px-4 py-3 font-medium text-gray-900">{sem.semester_code}</td>
                  <td className="px-4 py-3 text-right text-gray-700">{sem.unique_students}</td>
                  <td className="px-4 py-3 text-right text-gray-700">{sem.total_grades}</td>
                  <td className="px-4 py-3 text-right font-semibold text-gray-900">{sem.average_grade}</td>
                  <td className="px-4 py-3 text-right font-semibold text-primary-600">{sem.pass_rate}%</td>
                  <td className="px-4 py-3 text-right text-primary-600">{sem.pass_count}</td>
                  <td className="px-4 py-3 text-right text-red-600">{sem.fail_count}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>
    </div>
  )
}
