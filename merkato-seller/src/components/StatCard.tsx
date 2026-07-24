import React from 'react'
import { LucideIcon } from 'lucide-react'

interface StatCardProps {
  title: string
  value: string | number
  icon: LucideIcon
  color: 'green' | 'blue' | 'purple' | 'amber' | 'yellow' | 'red' | 'indigo'
  trend?: string
}

const StatCard: React.FC<StatCardProps> = ({
  title,
  value,
  icon: Icon,
  color,
  trend,
}) => {
  const colorClasses = {
    green: 'bg-gradient-to-br from-green-100 to-emerald-100 text-green-700',
    blue: 'bg-gradient-to-br from-blue-100 to-sky-100 text-blue-700',
    purple: 'bg-gradient-to-br from-purple-100 to-violet-100 text-purple-700',
    amber: 'bg-gradient-to-br from-amber-100 to-yellow-100 text-amber-700',
    yellow: 'bg-gradient-to-br from-yellow-100 to-amber-100 text-yellow-700',
    red: 'bg-gradient-to-br from-red-100 to-rose-100 text-red-700',
    indigo: 'bg-gradient-to-br from-indigo-100 to-blue-100 text-indigo-700',
  }

  return (
    <div className="stat-card group hover:scale-[1.02] transition-transform">
      <div className="flex items-center justify-between">
        <div>
          <p className="text-sm text-gray-500 font-medium">{title}</p>
          <p className="text-3xl font-bold text-gray-900 mt-2">{value}</p>
          
          {trend && (
            <div className="flex items-center mt-2">
              <span className="text-sm font-medium text-green-600">
                {trend}
              </span>
            </div>
          )}
        </div>
        
        <div className={`p-3 rounded-xl ${colorClasses[color]}`}>
          <Icon size={24} />
        </div>
      </div>
      
      {/* Progress bar for visual effect */}
      <div className="mt-4 h-1 bg-gray-100 rounded-full overflow-hidden">
        <div className={`h-full w-3/4 bg-gradient-to-r ${getGradientClass(color)}`}></div>
      </div>
    </div>
  )
}

const getGradientClass = (color: string) => {
  switch (color) {
    case 'green': return 'from-green-400 to-emerald-500'
    case 'blue': return 'from-blue-400 to-sky-500'
    case 'purple': return 'from-purple-400 to-violet-500'
    case 'amber': return 'from-amber-400 to-yellow-500'
    case 'yellow': return 'from-yellow-400 to-amber-500'
    case 'red': return 'from-red-400 to-rose-500'
    case 'indigo': return 'from-indigo-400 to-blue-500'
    default: return 'from-gray-400 to-gray-500'
  }
}

export default StatCard