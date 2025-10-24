import React, { useMemo, useState, useEffect } from "react"
import { AgGridReact } from "ag-grid-react"
import { themeQuartz } from "ag-grid-community"
import { Upload } from "lucide-react"

const agGridTheme = themeQuartz

export default function UploadTab({
  sheets,
  selectedSheet,
  uploadedRows,
  uploadCols,
  saveStatus,
  handleFileUpload,
  handleSheetChange,
  schoolYearId = "",
  setSchoolYearId = () => {},
  semesterId = "",
  setSemesterId = () => {}
}) {
  const [schoolYears, setSchoolYears] = useState([])
  const [semesters, setSemesters] = useState([])
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    fetchSchoolYears()
  }, [])
  
  // When school year changes, fetch semesters for that school year
  useEffect(() => {
    if (schoolYearId) {
      fetchSemesters(schoolYearId)
    } else {
      setSemesters([])
      setSemesterId("")
    }
  }, [schoolYearId, setSchoolYearId, setSemesterId])

  const fetchSchoolYears = async () => {
    try {
      setLoading(true)
      
      // Fetch all school years (not filtered, for upload)
      const syResponse = await fetch('http://localhost/grade/api/academic_sessions.php?action=getSchoolYears')
      const syData = await syResponse.json()
      if (syData.status === 'success') {
        setSchoolYears(syData.data)
      }
      
      setLoading(false)
    } catch (error) {
      console.error('Error fetching school years:', error)
      setLoading(false)
    }
  }
  
  const fetchSemesters = async (schoolYearId) => {
    try {
      // Fetch all semesters (not filtered, for upload)
      const semResponse = await fetch('http://localhost/grade/api/academic_sessions.php?action=getSemesters')
      const semData = await semResponse.json()
      if (semData.status === 'success') {
        setSemesters(semData.data)
      }
    } catch (error) {
      console.error('Error fetching semesters:', error)
    }
  }
  const activeRows = useMemo(() => {
    return uploadedRows.filter((r) => {
      const vals = Object.values(r)
      return vals.some((v) => String(v ?? "").trim() !== "")
    })
  }, [uploadedRows])

  const defaultColDef = useMemo(() => ({
    resizable: true,
    sortable: true,
    filter: true,
  }), [])

  return (
    <div className="space-y-6">
      <div className="bg-white rounded-lg shadow-md border border-gray-200 p-8">
        <div className="text-center">
          <Upload className="mx-auto mb-4 text-primary-500" size={48} />
          <h2 className="text-2xl font-bold text-gray-900 mb-2">Batch Upload Excel File</h2>
          <p className="text-gray-600 mb-6">Select academic session and upload your grade sheet</p>

          {/* Academic Session Selection */}
          <div className="max-w-xl mx-auto mb-8 space-y-4">
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              {/* School Year Dropdown */}
              <div className="text-left">
                <label className="block text-sm font-medium text-gray-700 mb-2">School Year *</label>
                <select
                  value={schoolYearId}
                  onChange={(e) => setSchoolYearId(e.target.value)}
                  disabled={loading}
                  className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary-500"
                >
                  <option value="">Select School Year</option>
                  {schoolYears.map((sy) => (
                    <option key={sy.school_year_id} value={sy.school_year_id}>
                      {sy.school_year}
                    </option>
                  ))}
                </select>
              </div>

              {/* Semester Dropdown */}
              <div className="text-left">
                <label className="block text-sm font-medium text-gray-700 mb-2">Semester *</label>
                <select
                  value={semesterId}
                  onChange={(e) => setSemesterId(e.target.value)}
                  disabled={loading}
                  className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary-500"
                >
                  <option value="">Select Semester</option>
                  {semesters.map((sem) => (
                    <option key={sem.semester_id} value={sem.semester_id}>
                      {sem.semester_name}
                    </option>
                  ))}
                </select>
              </div>
            </div>

            {!schoolYearId || !semesterId ? (
              <p className="text-sm text-amber-600 font-medium">
                Please select school year and semester before uploading
              </p>
            ) : (
              <p className="text-sm text-green-600 font-medium">
                ✓ Academic session selected. Excel file should include YEAR LEVEL column.
              </p>
            )}
          </div>

          <label className="inline-block">
            <input 
              type="file" 
              accept=".xlsx, .xls" 
              onChange={handleFileUpload} 
              className="hidden"
              disabled={!schoolYearId || !semesterId}
            />
            <span className={`inline-block px-8 py-3 font-semibold rounded-lg transition shadow-md ${
              !schoolYearId || !semesterId
                ? 'bg-gray-300 text-gray-500 cursor-not-allowed'
                : 'bg-primary-500 text-white hover:bg-primary-600 cursor-pointer'
            }`}>
              Choose File
            </span>
          </label>

          {saveStatus && (
            <div className="mt-6 space-y-2">
              {saveStatus && (
                <div className={`p-3 rounded-lg text-sm font-medium ${
                  saveStatus.includes("✓") 
                    ? "bg-primary-50 text-primary-800 border border-primary-200" 
                    : saveStatus.includes("✗")
                    ? "bg-red-50 text-red-800 border border-red-200"
                    : "bg-primary-50 text-primary-800 border border-primary-200"
                }`}>
                  {saveStatus}
                </div>
              )}
            </div>
          )}

          {sheets.length > 0 && (
            <div className="mt-8 pt-8 border-t border-gray-200">
              <div className="text-center">
                <p className="text-sm text-gray-600">
                  {sheets.length === 1 ? (
                    <>Processing sheet: <span className="font-semibold text-gray-900">{sheets[0]}</span></>
                  ) : (
                    <>All <span className="font-semibold text-gray-900">{sheets.length} sheets</span> processed automatically: {sheets.join(', ')}</>
                  )}
                </p>
              </div>
            </div>
          )}
        </div>
      </div>

      {uploadedRows.length > 0 && (
        <div className="bg-white rounded-lg shadow-md border border-gray-200 p-6">
          <h3 className="text-lg font-bold text-gray-900 mb-4">Data Preview ({activeRows.length} records)</h3>
          <div style={{ height: 400, width: "100%" }}>
            <AgGridReact
              theme={agGridTheme}
              rowData={activeRows}
              columnDefs={uploadCols}
              defaultColDef={defaultColDef}
              pagination={true}
              paginationPageSize={10}
            />
          </div>
        </div>
      )}
    </div>
  )
}
