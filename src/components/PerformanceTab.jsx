import React from "react"
import { BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip, Legend, ResponsiveContainer, Cell } from "recharts"

const getColorByPassRate = (passRate) => {
  if (passRate >= 75) return "#166534" // Dark Green - Excellent/Highly Proficient
  if (passRate >= 50) return "#065f46" // Green - Meeting the Standards
  if (passRate >= 25) return "#92400e" // Yellow/Brown - Progressing Towards Standards
  return "#991b1b" // Red - Not Meeting Standards
}

export default function PerformanceTab({ subjectPerformance, semesterComparison }) {
  return (
    <div className="space-y-6">
      {subjectPerformance && subjectPerformance.length > 0 && (
        <div className="bg-white rounded-lg shadow-md border border-gray-200 p-6">
          <h3 className="text-lg font-bold text-gray-900 mb-4">Subject Performance Ranking (Top 15)</h3>
          
          {/* Legend */}
          <div className="mb-4 p-4 bg-gray-50 rounded-lg">
            <h4 className="text-sm font-semibold text-gray-700 mb-2">Pass Rate Categories:</h4>
            <div className="flex flex-wrap gap-4 text-sm">
              <div className="flex items-center gap-2">
                <div className="w-4 h-4 rounded" style={{ backgroundColor: "#991b1b" }}></div>
                <span>Not Meeting Standards (0-25%)</span>
              </div>
              <div className="flex items-center gap-2">
                <div className="w-4 h-4 rounded" style={{ backgroundColor: "#92400e" }}></div>
                <span>Progressing (25-50%)</span>
              </div>
              <div className="flex items-center gap-2">
                <div className="w-4 h-4 rounded" style={{ backgroundColor: "#065f46" }}></div>
                <span>Meeting Standards (50-75%)</span>
              </div>
              <div className="flex items-center gap-2">
                <div className="w-4 h-4 rounded" style={{ backgroundColor: "#166534" }}></div>
                <span>Excellent (75-100%)</span>
              </div>
            </div>
          </div>

          <ResponsiveContainer width="100%" height={500}>
            <BarChart data={subjectPerformance.slice(0, 15)}>
              <CartesianGrid strokeDasharray="3 3" />
              <XAxis dataKey="subject_name" angle={-45} textAnchor="end" height={120} />
              <YAxis domain={[0, 100]} label={{ value: 'Pass Rate (%)', angle: -90, position: 'insideLeft' }} />
              <Tooltip />
              <Legend />
              <Bar dataKey="pass_rate" name="Pass Rate %">
                {subjectPerformance.slice(0, 15).map((entry, index) => (
                  <Cell key={`cell-${index}`} fill={getColorByPassRate(entry.pass_rate)} />
                ))}
              </Bar>
            </BarChart>
          </ResponsiveContainer>
        </div>
      )}

    </div>
  )
}
