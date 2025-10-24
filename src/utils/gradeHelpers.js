// Helper functions for grade calculations and formatting

export function getCategoryFromGrade(grade) {
  const g = parseFloat(grade)
  if (isNaN(g)) return null
  if (g >= 0 && g <= 25) return "NMS"
  if (g > 25 && g < 50) return "PTS"
  if (g >= 50 && g < 75) return "MP"
  if (g >= 75 && g <= 100) return "EHP"
  return null
}

export function extractYearLevel(semester) {
  if (!semester) return ""
  const s = String(semester).trim().toUpperCase()
  const match = s.match(/Y(\d+)/)
  if (match) return `Year ${match[1]}`
  return ""
}

export function pct(part, total) {
  if (!total) return "0.00%"
  return ((part / total) * 100).toFixed(2) + "%"
}

export const COLORS = {
  NMS: '#ef4444',
  PTS: '#f59e0b',
  MP: '#10b981',
  EHP: '#059669',
  pass: '#10b981',
  fail: '#ef4444'
}

export const CHART_COLORS = ['#3b82f6', '#10b981', '#f59e0b', '#ef4444', '#8b5cf6', '#ec4899']

export const API_BASE = "http://localhost/grade/api"
