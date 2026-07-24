import React from 'react'
import { Clock, CheckCircle, Package, Truck } from 'lucide-react'

interface Order {
  id: string
  customer: string
  amount: number
  status: 'pending' | 'accepted' | 'prepared' | 'delivered'
  date: string
}

interface RecentOrdersProps {
  orders: Order[]
}

const RecentOrders: React.FC<RecentOrdersProps> = ({ orders }) => {
  const getStatusIcon = (status: string) => {
    switch (status) {
      case 'pending': return <Clock size={16} className="text-amber-500" />
      case 'accepted': return <CheckCircle size={16} className="text-blue-500" />
      case 'prepared': return <Package size={16} className="text-purple-500" />
      case 'delivered': return <Truck size={16} className="text-green-500" />
      default: return <Clock size={16} className="text-gray-500" />
    }
  }

  const getStatusClass = (status: string) => {
    switch (status) {
      case 'pending': return 'status-pending'
      case 'accepted': return 'status-accepted'
      case 'prepared': return 'status-prepared'
      case 'delivered': return 'status-delivered'
      default: return 'bg-gray-100 text-gray-800'
    }
  }

  return (
    <div className="space-y-4">
      {orders.map((order) => (
        <div key={order.id} className="flex items-center justify-between p-4 hover:bg-gray-50 rounded-xl transition-colors group">
          <div className="flex items-center gap-4">
            <div className="p-2 bg-gray-100 rounded-lg group-hover:bg-white transition-colors">
              {getStatusIcon(order.status)}
            </div>
            <div>
              <p className="font-medium text-gray-900">{order.id}</p>
              <p className="text-sm text-gray-500">{order.customer}</p>
            </div>
          </div>
          
          <div className="flex items-center gap-6">
            <div className="text-right">
              <p className="font-bold text-lg text-gray-900">ETB {order.amount.toLocaleString()}</p>
              <div className="flex items-center gap-1 text-sm text-gray-500">
                <Clock size={12} />
                <span>{order.date}</span>
              </div>
            </div>
            
            <span className={`status-badge ${getStatusClass(order.status)}`}>
              {order.status.charAt(0).toUpperCase() + order.status.slice(1)}
            </span>
            
            <button className="p-2 text-gray-400 hover:text-green-600 hover:bg-green-50 rounded-lg transition-colors">
              <span className="sr-only">View</span>
              <div className="w-6 h-6 flex items-center justify-center">
                →
              </div>
            </button>
          </div>
        </div>
      ))}
      
      {orders.length === 0 && (
        <div className="text-center py-8">
          <div className="inline-flex p-4 bg-gray-100 rounded-full mb-4">
            <Package size={24} className="text-gray-400" />
          </div>
          <p className="text-gray-500">No recent orders</p>
        </div>
      )}
    </div>
  )
}

export default RecentOrders