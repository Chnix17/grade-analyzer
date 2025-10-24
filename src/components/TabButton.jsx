import React from "react"

export default function TabButton({ tab, label, icon: Icon, activeTab, onClick }) {
  return (
    <button
      onClick={() => onClick(tab)}
      className={`flex items-center gap-2 px-4 py-3 font-medium transition-all border-b-2 ${
        activeTab === tab
          ? "border-primary-500 text-primary-600 bg-primary-50"
          : "border-transparent text-gray-600 hover:text-primary-600 hover:bg-gray-50"
      }`}
    >
      <Icon size={18} />
      {label}
    </button>
  )
}
