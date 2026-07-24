import React, { useState } from 'react'
import { Package, DollarSign, Clock, CheckCircle, Truck, Search, Filter, Eye, MapPin, AlertCircle } from 'lucide-react'

const StaffOrders = () => {
  const [searchTerm, setSearchTerm] = useState('')
  const [filter, setFilter] = useState('all')

  const orders = [
    { 
      id: '#ORD-001', 
      customer: 'Abebe Kebede', 
      seller: 'Ethiopian Crafts Store',
      date: 'Today, 10:30 AM', 
      amount: 850, 
      items: 3, 
      status: 'processing', 
      delivery: 'pickup',
      issues: 0,
      priority: 'normal'
    },
    { 
      id: '#ORD-002', 
      customer: 'Marta Samuel', 
      seller: 'Fresh Spices Co.',
      date: 'Today, 9:15 AM', 
      amount: 1200, 
      items: 5, 
      status: 'delayed', 
      delivery: 'delivery',
      issues: 2,
      priority: 'high'
    },
    { 
      id: '#ORD-003', 
      customer: 'Yohannes Tekle', 
      seller: 'Coffee Beans Export',
      date: 'Yesterday, 4:45 PM', 
      amount: 450, 
      items: 2, 
      status: 'shipped', 
      delivery: 'delivery',
      issues: 0,
      priority: 'normal'
    },
    { 
      id: '#ORD-004', 
      customer: 'Selamawit Abebe', 
      seller: 'Handmade Crafts',
      date: 'Yesterday, 2:30 PM', 
      amount: 680, 
      items: 4, 
      status: 'delivered', 
      delivery: 'pickup',
      issues: 0,
      priority: 'normal'
    },
    { 
      id: '#ORD-005', 
      customer: 'Tekalign Mulu', 
      seller: 'Traditional Foods',
      date: 'Dec 10, 2023', 
      amount: 320, 
      items: 1, 
      status: 'cancelled', 
      delivery: 'delivery',
      issues: 1,
      priority: 'low'
    },
    { 
      id: '#ORD-006', 
      customer: 'Hirut Tadesse', 
      seller: 'Clothing Store',
      date: 'Dec 10, 2023', 
      amount: 940, 
      items: 3, 
      status: 'disputed', 
      delivery: 'delivery',
      issues: 3,
      priority: 'high'
    },
    { 
      id: '#ORD-007', 
      customer: 'Kaleb Solomon', 
      seller: 'Electronics Shop',
      date: 'Dec 9, 2023', 
      amount: 1250, 
      items: 6, 
      status: 'shipped', 
      delivery: 'delivery',
      issues: 0,
      priority: 'normal'
    },
    { 
      id: '#ORD-008', 
      customer: 'Mulugeta Worku', 
      seller: 'Home Goods',
      date: 'Dec 9, 2023', 
      amount: 760, 
      items: 4, 
      status: 'processing', 
      delivery: 'pickup',
      issues: 0,
      priority: 'normal'
    },
  ]

  const filteredOrders = orders.filter(order => {
    const matchesSearch = order.customer.toLowerCase().includes(searchTerm.toLowerCase()) ||
                         order.seller.toLowerCase().includes(searchTerm.toLowerCase()) ||
                         order.id.toLowerCase().includes(searchTerm.toLowerCase())
    const matchesFilter = filter === 'all' || order.status === filter
    return matchesSearch && matchesFilter
  })

  const stats = {
    totalOrders: orders.length,
    totalRevenue: orders.reduce((sum, o) => sum + o.amount, 0),
    issuesCount: orders.reduce((sum, o) => sum + o.issues, 0),
    highPriority: orders.filter(o => o.priority === 'high').length,
  }

  const statusColors = {
    processing: 'bg-blue-100 text-blue-800',
    delayed: 'bg-amber-100 text-amber-800',
    shipped: 'bg-purple-100 text-purple-800',
    delivered: 'bg-green-100 text-green-800',
    cancelled: 'bg-red-100 text-red-800',
    disputed: 'bg-rose-100 text-rose-800',
  }

  const priorityColors = {
    high: 'bg-red-100 text-red-800',
    normal: 'bg-blue-100 text-blue-800',
    low: 'bg-green-100 text-green-800',
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
          <h1 className="text-3xl font-bold text-gray-900">Order Monitoring</h1>
          <p className="text-gray-500">Monitor and manage all platform orders</p>
        </div>
        <div className="flex items-center gap-3">
          <button className="flex items-center gap-2 px-4 py-2 bg-gradient-to-r from-blue-500 to-indigo-600 text-white rounded-lg font-medium shadow-md hover:shadow-lg transition-all">
            <AlertCircle size={18} />
            View Issues
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
              <p className="text-sm text-blue-600 mt-1">Active monitoring</p>
            </div>
            <div className="p-3 bg-gradient-to-r from-blue-100 to-cyan-100 text-blue-700 rounded-xl">
              <Package size={24} />
            </div>
          </div>
        </div>

        <div className="bg-white p-6 rounded-2xl shadow-sm border border-gray-100">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm text-gray-500 font-medium">Platform Revenue</p>
              <p className="text-3xl font-bold text-gray-900 mt-2">ETB {stats.totalRevenue.toLocaleString()}</p>
              <p className="text-sm text-green-600 mt-1">+15% growth</p>
            </div>
            <div className="p-3 bg-gradient-to-r from-green-100 to-emerald-100 text-green-700 rounded-xl">
              <DollarSign size={24} />
            </div>
          </div>
        </div>

        <div className="bg-white p-6 rounded-2xl shadow-sm border border-gray-100">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm text-gray-500 font-medium">Active Issues</p>
              <p className="text-3xl font-bold text-gray-900 mt-2">{stats.issuesCount}</p>
              <p className="text-sm text-amber-600 mt-1">Requires attention</p>
            </div>
            <div className="p-3 bg-gradient-to-r from-amber-100 to-yellow-100 text-amber-700 rounded-xl">
              <AlertCircle size={24} />
            </div>
          </div>
        </div>

        <div className="bg-white p-6 rounded-2xl shadow-sm border border-gray-100">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm text-gray-500 font-medium">High Priority</p>
              <p className="text-3xl font-bold text-gray-900 mt-2">{stats.highPriority}</p>
              <p className="text-sm text-red-600 mt-1">Urgent action needed</p>
            </div>
            <div className="p-3 bg-gradient-to-r from-red-100 to-rose-100 text-red-700 rounded-xl">
              <Clock size={24} />
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
              placeholder="Search orders by customer, seller, or order ID..."
              className="w-full pl-12 pr-4 py-3 border border-gray-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500/50 focus:border-blue-500"
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
              className="border border-gray-300 rounded-lg px-4 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500/50 focus:border-blue-500"
            >
              <option value="all">All Orders</option>
              <option value="processing">Processing</option>
              <option value="delayed">Delayed</option>
              <option value="shipped">Shipped</option>
              <option value="delivered">Delivered</option>
              <option value="cancelled">Cancelled</option>
              <option value="disputed">Disputed</option>
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
                <th className="text-left py-4 px-2 text-sm font-medium text-gray-500">Seller</th>
                <th className="text-left py-4 px-2 text-sm font-medium text-gray-500">Date</th>
                <th className="text-left py-4 px-2 text-sm font-medium text-gray-500">Amount</th>
                <th className="text-left py-4 px-2 text-sm font-medium text-gray-500">Status</th>
                <th className="text-left py-4 px-2 text-sm font-medium text-gray-500">Priority</th>
                <th className="text-left py-4 px-2 text-sm font-medium text-gray-500">Actions</th>
              </tr>
            </thead>
            <tbody>
              {filteredOrders.map((order) => (
                <tr key={order.id} className={`border-b border-gray-100 hover:bg-gray-50 transition-colors ${
                  order.priority === 'high' ? 'bg-red-50/50' : ''
                }`}>
                  <td className="py-4 px-2">
                    <p className="font-bold text-gray-900">{order.id}</p>
                    <div className="flex items-center gap-2 mt-1">
                      <span className={`px-2 py-0.5 rounded-full text-xs font-medium ${deliveryColors[order.delivery]}`}>
                        {order.delivery}
                      </span>
                      {order.issues > 0 && (
                        <span className="flex items-center gap-1 px-2 py-0.5 bg-rose-100 text-rose-800 rounded-full text-xs">
                          <AlertCircle size={10} />
                          {order.issues} issue{order.issues > 1 ? 's' : ''}
                        </span>
                      )}
                    </div>
                  </td>
                  <td className="py-4 px-2">
                    <div className="flex items-center gap-3">
                      <div className="w-8 h-8 bg-gradient-to-r from-blue-100 to-indigo-100 rounded-full flex items-center justify-center">
                        <span className="font-bold text-blue-700 text-sm">
                          {order.customer.split(' ')[0][0]}
                        </span>
                      </div>
                      <p className="font-medium text-gray-900">{order.customer}</p>
                    </div>
                  </td>
                  <td className="py-4 px-2">
                    <p className="text-sm text-gray-700">{order.seller}</p>
                  </td>
                  <td className="py-4 px-2">
                    <div className="flex items-center gap-2">
                      <Clock size={16} className="text-gray-400" />
                      <span className="text-gray-700">{order.date}</span>
                    </div>
                  </td>
                  <td className="py-4 px-2">
                    <p className="font-bold text-lg text-gray-900">ETB {order.amount}</p>
                    <p className="text-sm text-gray-500">{order.items} items</p>
                  </td>
                  <td className="py-4 px-2">
                    <span className={`px-3 py-1 rounded-full text-sm font-medium ${statusColors[order.status]}`}>
                      {order.status}
                    </span>
                  </td>
                  <td className="py-4 px-2">
                    <span className={`px-3 py-1 rounded-full text-sm font-medium ${priorityColors[order.priority]}`}>
                      {order.priority}
                    </span>
                  </td>
                  <td className="py-4 px-2">
                    <div className="flex items-center gap-2">
                      <button className="flex items-center gap-1 px-3 py-1 bg-blue-50 text-blue-700 hover:bg-blue-100 rounded-lg text-sm transition-colors">
                        <Eye size={14} />
                        View
                      </button>
                      {order.status === 'delayed' || order.status === 'disputed' ? (
                        <button className="px-3 py-1 bg-gradient-to-r from-red-500 to-rose-600 text-white hover:from-red-600 hover:to-rose-700 rounded-lg text-sm transition-all">
                          Escalate
                        </button>
                      ) : (
                        <button className="px-3 py-1 bg-gradient-to-r from-blue-500 to-indigo-600 text-white hover:from-blue-600 hover:to-indigo-700 rounded-lg text-sm transition-all">
                          Monitor
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
            <div className="inline-flex p-6 bg-gradient-to-r from-blue-50 to-indigo-50 rounded-full mb-6">
              <Package size={48} className="text-blue-600" />
            </div>
            <h3 className="text-2xl font-bold text-gray-900 mb-3">No orders found</h3>
            <p className="text-gray-500 mb-6">Try adjusting your search or filter criteria.</p>
            <button
              onClick={() => {
                setSearchTerm('')
                setFilter('all')
              }}
              className="px-6 py-3 bg-gradient-to-r from-blue-500 to-indigo-600 text-white rounded-lg font-medium shadow-lg hover:shadow-xl transition-all"
            >
              Clear filters
            </button>
          </div>
        )}

        {/* Order Analytics */}
        <div className="mt-8 p-6 bg-gradient-to-r from-blue-50 to-indigo-50 rounded-xl">
          <h3 className="font-medium text-gray-900 mb-4">Order Analytics</h3>
          <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
            <div className="bg-white/80 backdrop-blur-sm p-4 rounded-lg">
              <p className="text-sm text-gray-500">Avg Processing Time</p>
              <p className="text-2xl font-bold text-gray-900">3.2 hours</p>
              <p className="text-sm text-green-600">-0.5 hours</p>
            </div>
            <div className="bg-white/80 backdrop-blur-sm p-4 rounded-lg">
              <p className="text-sm text-gray-500">Dispute Rate</p>
              <p className="text-2xl font-bold text-gray-900">2.4%</p>
              <p className="text-sm text-green-600">-0.8%</p>
            </div>
            <div className="bg-white/80 backdrop-blur-sm p-4 rounded-lg">
              <p className="text-sm text-gray-500">Delivery Success</p>
              <p className="text-2xl font-bold text-gray-900">96.7%</p>
              <p className="text-sm text-green-600">+1.2%</p>
            </div>
            <div className="bg-white/80 backdrop-blur-sm p-4 rounded-lg">
              <p className="text-sm text-gray-500">Customer Satisfaction</p>
              <p className="text-2xl font-bold text-gray-900">4.6/5</p>
              <p className="text-sm text-green-600">+0.2</p>
            </div>
          </div>
        </div>
      </div>
    </div>
  )
}

export default StaffOrders