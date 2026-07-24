import React, { useState } from 'react'
import { Package, DollarSign, Clock, CheckCircle, Truck, Search, Filter, Eye, MapPin } from 'lucide-react'

const SellerOrders = () => {
  const [searchTerm, setSearchTerm] = useState('')
  const [filter, setFilter] = useState('all')

  const orders = [
    { id: '#ORD-001', customer: 'Abebe Kebede', date: 'Today, 10:30 AM', amount: 850, items: 3, status: 'processing', delivery: 'pickup' },
    { id: '#ORD-002', customer: 'Marta Samuel', date: 'Today, 9:15 AM', amount: 1200, items: 5, status: 'ready', delivery: 'delivery' },
    { id: '#ORD-003', customer: 'Yohannes Tekle', date: 'Yesterday, 4:45 PM', amount: 450, items: 2, status: 'shipped', delivery: 'delivery' },
    { id: '#ORD-004', customer: 'Selamawit Abebe', date: 'Yesterday, 2:30 PM', amount: 680, items: 4, status: 'delivered', delivery: 'pickup' },
    { id: '#ORD-005', customer: 'Tekalign Mulu', date: 'Dec 10, 2023', amount: 320, items: 1, status: 'cancelled', delivery: 'delivery' },
    { id: '#ORD-006', customer: 'Hirut Tadesse', date: 'Dec 10, 2023', amount: 940, items: 3, status: 'delivered', delivery: 'delivery' },
    { id: '#ORD-007', customer: 'Kaleb Solomon', date: 'Dec 9, 2023', amount: 1250, items: 6, status: 'shipped', delivery: 'delivery' },
    { id: '#ORD-008', customer: 'Mulugeta Worku', date: 'Dec 9, 2023', amount: 760, items: 4, status: 'processing', delivery: 'pickup' },
  ]

  const filteredOrders = orders.filter(order => {
    const matchesSearch = order.customer.toLowerCase().includes(searchTerm.toLowerCase()) ||
                         order.id.toLowerCase().includes(searchTerm.toLowerCase())
    const matchesFilter = filter === 'all' || order.status === filter
    return matchesSearch && matchesFilter
  })

  const stats = {
    totalOrders: orders.length,
    totalRevenue: orders.reduce((sum, o) => sum + o.amount, 0),
    pendingOrders: orders.filter(o => o.status === 'processing').length,
    avgOrderValue: Math.round(orders.reduce((sum, o) => sum + o.amount, 0) / orders.length),
  }

  const statusColors = {
    processing: 'bg-blue-100 text-blue-800',
    ready: 'bg-amber-100 text-amber-800',
    shipped: 'bg-purple-100 text-purple-800',
    delivered: 'bg-green-100 text-green-800',
    cancelled: 'bg-red-100 text-red-800',
  }

  const deliveryColors = {
    pickup: 'bg-indigo-100 text-indigo-800',
    delivery: 'bg-teal-100 text-teal-800',
  }

  return (
    <div className="space-y-8">
      {/* Header */}
      <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
        <div>
          <h1 className="text-3xl font-bold text-gray-900">Order Management</h1>
          <p className="text-gray-500">Track and manage customer orders</p>
        </div>
        <div className="flex items-center gap-3">
          <button className="flex items-center gap-2 px-4 py-2 bg-gradient-to-r from-green-500 to-emerald-600 text-white rounded-lg font-medium shadow-md hover:shadow-lg transition-all">
            <Truck size={18} />
            Bulk Actions
          </button>
        </div>
      </div>

      {/* Stats */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
        <div className="bg-white p-6 rounded-2xl shadow-sm border border-gray-100">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm text-gray-500 font-medium">Total Orders</p>
              <p className="text-3xl font-bold text-gray-900 mt-2">{stats.totalOrders}</p>
              <p className="text-sm text-green-600 mt-1">+8 this week</p>
            </div>
            <div className="p-3 bg-gradient-to-r from-green-100 to-emerald-100 text-green-700 rounded-xl">
              <Package size={24} />
            </div>
          </div>
        </div>

        <div className="bg-white p-6 rounded-2xl shadow-sm border border-gray-100">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm text-gray-500 font-medium">Total Revenue</p>
              <p className="text-3xl font-bold text-gray-900 mt-2">ETB {stats.totalRevenue.toLocaleString()}</p>
              <p className="text-sm text-green-600 mt-1">+22% growth</p>
            </div>
            <div className="p-3 bg-gradient-to-r from-blue-100 to-cyan-100 text-blue-700 rounded-xl">
              <DollarSign size={24} />
            </div>
          </div>
        </div>

        <div className="bg-white p-6 rounded-2xl shadow-sm border border-gray-100">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm text-gray-500 font-medium">Pending Orders</p>
              <p className="text-3xl font-bold text-gray-900 mt-2">{stats.pendingOrders}</p>
              <p className="text-sm text-amber-600 mt-1">Needs attention</p>
            </div>
            <div className="p-3 bg-gradient-to-r from-amber-100 to-yellow-100 text-amber-700 rounded-xl">
              <Clock size={24} />
            </div>
          </div>
        </div>

        <div className="bg-white p-6 rounded-2xl shadow-sm border border-gray-100">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm text-gray-500 font-medium">Avg Order Value</p>
              <p className="text-3xl font-bold text-gray-900 mt-2">ETB {stats.avgOrderValue}</p>
              <p className="text-sm text-green-600 mt-1">Increasing</p>
            </div>
            <div className="p-3 bg-gradient-to-r from-purple-100 to-violet-100 text-purple-700 rounded-xl">
              <CheckCircle size={24} />
            </div>
          </div>
        </div>
      </div>

      {/* Search & Filter */}
      <div className="bg-white rounded-2xl shadow-lg p-6">
        <div className="flex flex-col md:flex-row md:items-center justify-between gap-4 mb-6">
          <div className="relative flex-1">
            <div className="absolute left-3 top-1/2 transform -translate-y-1/2">
              <Search size={20} className="text-gray-400" />
            </div>
            <input
              type="text"
              value={searchTerm}
              onChange={(e) => setSearchTerm(e.target.value)}
              placeholder="Search orders by customer or order ID..."
              className="w-full pl-12 pr-4 py-3 border border-gray-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-green-500/50 focus:border-green-500"
            />
          </div>
          
          <div className="flex items-center gap-3">
            <div className="flex items-center gap-2 text-gray-500">
              <Filter size={18} />
              <span>Filter:</span>
            </div>
            <select
              value={filter}
              onChange={(e) => setFilter(e.target.value)}
              className="border border-gray-300 rounded-lg px-4 py-2 focus:outline-none focus:ring-2 focus:ring-green-500/50 focus:border-green-500"
            >
              <option value="all">All Orders</option>
              <option value="processing">Processing</option>
              <option value="ready">Ready</option>
              <option value="shipped">Shipped</option>
              <option value="delivered">Delivered</option>
              <option value="cancelled">Cancelled</option>
            </select>
          </div>
        </div>

        {/* Orders Table */}
        <div className="overflow-x-auto">
          <table className="w-full">
            <thead>
              <tr className="border-b border-gray-200">
                <th className="text-left py-4 px-2 text-sm font-medium text-gray-500">Order ID</th>
                <th className="text-left py-4 px-2 text-sm font-medium text-gray-500">Customer</th>
                <th className="text-left py-4 px-2 text-sm font-medium text-gray-500">Date</th>
                <th className="text-left py-4 px-2 text-sm font-medium text-gray-500">Amount</th>
                <th className="text-left py-4 px-2 text-sm font-medium text-gray-500">Items</th>
                <th className="text-left py-4 px-2 text-sm font-medium text-gray-500">Status</th>
                <th className="text-left py-4 px-2 text-sm font-medium text-gray-500">Delivery</th>
                <th className="text-left py-4 px-2 text-sm font-medium text-gray-500">Actions</th>
              </tr>
            </thead>
            <tbody>
              {filteredOrders.map((order) => (
                <tr key={order.id} className="border-b border-gray-100 hover:bg-gray-50 transition-colors">
                  <td className="py-4 px-2">
                    <p className="font-bold text-gray-900">{order.id}</p>
                  </td>
                  <td className="py-4 px-2">
                    <div className="flex items-center gap-3">
                      <div className="w-8 h-8 bg-gradient-to-r from-green-100 to-emerald-100 rounded-full flex items-center justify-center">
                        <span className="font-bold text-green-700 text-sm">
                          {order.customer.split(' ')[0][0]}
                        </span>
                      </div>
                      <p className="font-medium text-gray-900">{order.customer}</p>
                    </div>
                  </td>
                  <td className="py-4 px-2">
                    <div className="flex items-center gap-2">
                      <Clock size={16} className="text-gray-400" />
                      <span className="text-gray-700">{order.date}</span>
                    </div>
                  </td>
                  <td className="py-4 px-2">
                    <p className="font-bold text-lg text-gray-900">ETB {order.amount}</p>
                  </td>
                  <td className="py-4 px-2">
                    <div className="flex items-center gap-2">
                      <Package size={16} className="text-gray-400" />
                      <span className="text-gray-700">{order.items}</span>
                    </div>
                  </td>
                  <td className="py-4 px-2">
                    <span className={`px-3 py-1 rounded-full text-sm font-medium ${statusColors[order.status]}`}>
                      {order.status}
                    </span>
                  </td>
                  <td className="py-4 px-2">
                    <span className={`px-3 py-1 rounded-full text-sm font-medium ${deliveryColors[order.delivery]}`}>
                      {order.delivery}
                    </span>
                  </td>
                  <td className="py-4 px-2">
                    <div className="flex items-center gap-2">
                      <button className="flex items-center gap-1 px-3 py-1 bg-green-50 text-green-700 hover:bg-green-100 rounded-lg text-sm transition-colors">
                        <Eye size={14} />
                        View
                      </button>
                      {order.status === 'processing' && (
                        <button className="px-3 py-1 bg-gradient-to-r from-green-500 to-emerald-600 text-white hover:from-green-600 hover:to-emerald-700 rounded-lg text-sm transition-all">
                          Process
                        </button>
                      )}
                      {order.status === 'ready' && order.delivery === 'delivery' && (
                        <button className="flex items-center gap-1 px-3 py-1 bg-gradient-to-r from-blue-500 to-indigo-600 text-white hover:from-blue-600 hover:to-indigo-700 rounded-lg text-sm transition-all">
                          <Truck size={14} />
                          Ship
                        </button>
                      )}
                    </div>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>

        {/* Empty State */}
        {filteredOrders.length === 0 && (
          <div className="text-center py-12">
            <div className="inline-flex p-6 bg-gradient-to-r from-green-50 to-emerald-50 rounded-full mb-6">
              <Package size={48} className="text-green-600" />
            </div>
            <h3 className="text-2xl font-bold text-gray-900 mb-3">No orders found</h3>
            <p className="text-gray-500 mb-6">Try adjusting your search or filter criteria.</p>
            <button
              onClick={() => {
                setSearchTerm('')
                setFilter('all')
              }}
              className="px-6 py-3 bg-gradient-to-r from-green-500 to-emerald-600 text-white rounded-lg font-medium shadow-lg hover:shadow-xl transition-all"
            >
              Clear filters
            </button>
          </div>
        )}

        {/* Order Status Summary */}
        <div className="mt-8 p-6 bg-gradient-to-r from-green-50 to-emerald-50 rounded-xl">
          <h3 className="font-medium text-gray-900 mb-4">Order Status Summary</h3>
          <div className="grid grid-cols-2 md:grid-cols-5 gap-4">
            {Object.entries(statusColors).map(([status, colorClass]) => {
              const count = orders.filter(o => o.status === status).length
              const percentage = Math.round((count / orders.length) * 100)
              return (
                <div key={status} className="bg-white/80 backdrop-blur-sm p-4 rounded-lg">
                  <div className={`inline-flex px-3 py-1 rounded-full text-sm font-medium mb-2 ${colorClass}`}>
                    {status.charAt(0).toUpperCase() + status.slice(1)}
                  </div>
                  <p className="text-2xl font-bold text-gray-900">{count}</p>
                  <p className="text-sm text-gray-500">{percentage}% of total</p>
                </div>
              )
            })}
          </div>
        </div>
      </div>
    </div>
  )
}

export default SellerOrders