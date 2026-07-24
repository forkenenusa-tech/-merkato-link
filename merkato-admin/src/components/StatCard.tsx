import React from 'react'
import { LucideIcon } from 'lucide-react'

interface StatCardProps {
  title: string
  value: string | number
  icon: LucideIcon
  color: 'blue' | 'green' | 'yellow' | 'red' | 'purple' | 'indigo'
  change?: number
  changeLabel?: string
}

const StatCard: React.FC<StatCardProps> = ({
  title,
  value,
  icon: Icon,
  color,
  change,
  changeLabel,
}) => {
  const colorClasses = {
    blue: 'bg-blue-100 text-blue-600',
    green: 'bg-green-100 text-green-600',
    yellow: 'bg-yellow-100 text-yellow-600',
    red: 'bg-red-100 text-red-600',
    purple: 'bg-purple-100 text-purple-600',
    indigo: 'bg-indigo-100 text-indigo-600',
  }

  return (
    <div className="stat-card">
      <div className="flex items-center justify-between">
        <div>
          <p className="text-sm text-gray-500 font-medium">{title}</p>
          <p className="text-3xl font-bold text-gray-900 mt-2">{value}</p>
          
          {change !== undefined && (
            <div className="flex items-center mt-2">
              <span className={`text-sm font-medium ${
                change > 0 ? 'text-green-600' : 'text-red-600'
              }`}>
                {change > 0 ? '+' : ''}{change}
              </span>
              {changeLabel && (
                <span className="text-sm text-gray-500 ml-2">{changeLabel}</span>
              )}
            </div>
          )}
        </div>
        
        <div className={`p-3 rounded-full ${colorClasses[color]}`}>
          <Icon size={24} />
        </div>
      </div>
    </div>
  )
}

export default StatCard