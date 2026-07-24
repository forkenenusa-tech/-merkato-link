import React, { useState } from 'react'
import { Package, CheckCircle, DollarSign, Clock, Calendar, Filter } from 'lucide-react'

const DriverHistory = () => {
  const [filter, setFilter] = useState('all')
  
  const deliveryHistory = [
    { id: '#DEL-101', customer: 'Abebe Kebede', date: 'Today, 10:30 AM', amount: 250, status: 'delivered', rating: 5, items: 3 },
    { id: '#DEL-102', customer: 'Marta Samuel', date: 'Today, 9:15 AM', amount: 300, status: 'delivered', rating: 4, items: 2 },
    { id: '#DEL-103', customer: 'Yohannes Tekle', date: 'Yesterday, 4:45 PM', amount: 400, status: 'delivered', rating: 5, items: 5 },
    { id: '#DEL-104', customer: 'Selamawit Abebe', date: 'Yesterday, 2:30 PM', amount: 200, status: 'delivered', rating: 4, items: 1 },
    { id: '#DEL-105', customer: 'Tekalign Mulu', date: 'Dec 10, 2023', amount: 350, status: 'delivered', rating: 5, items: 4 },
    { id: '#DEL-106', customer: 'Hirut Tadesse', date: 'Dec 10, 2023', amount: 280, status: 'delivered', rating: 4, items: 3 },
    { id: '#DEL-107', customer: 'Kaleb Solomon', date: 'Dec 9, 2023', amount: 500, status: 'delivered', rating: 5, items: 6 },
    { id: '#DEL-108', customer: 'Mulugeta Worku', date: 'Dec 9, 2023', amount: 320, status: 'delivered', rating: 5, items: 3 },
  ]

  const filteredHistory = filter === 'all' 
    ? deliveryHistory 
    : filter === 'today' 
      ? deliveryHistory.filter(d => d.date.includes('Today'))
      : filter === 'yesterday' 
        ? deliveryHistory.filter(d => d.date.includes('Yesterday'))
        : deliveryHistory.filter(d => d.rating === 5)

  const totalEarnings = deliveryHistory.reduce((sum, delivery) => sum + delivery.amount, 0)
  const totalDeliveries = deliveryHistory.length
  const averageRating = (deliveryHistory.reduce((sum, delivery) => sum + delivery.rating, 0) / deliveryHistory.length).toFixed(1)

  return (
    <div className="space-y-8">
      <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
        <div>
          <h1 className="text-3xl font-bold text-gray-900">Delivery History</h1>
          <p className="text-gray-500">Track your past deliveries and earnings</p>
        </div>
        <div className="flex items-center gap-3">
          <button className="flex items-center gap-2 px-4 py-2 bg-white border border-gray-300 rounded-lg text-gray-700 hover:bg-gray-50">
            <Calendar size={18} />
            Export History
          </button>
        </div>
      </div>

      {/* Stats Overview */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
        <div className="bg-gradient-to-br from-orange-50 to-amber-50 p-6 rounded-2xl border border-orange-100">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm text-gray-500 font-medium">Total Earnings</p>
              <p className="text-3xl font-bold text-gray-900 mt-2">ETB {totalEarnings}</p>
              <p className="text-sm text-green-600 mt-1">This month</p>
            </div>
            <div className="p-3 bg-gradient-to-r from-orange-100 to-amber-100 text-orange-700 rounded-xl">
              <DollarSign size={24} />
            </div>
          </div>
        </div>

        <div className="bg-gradient-to-br from-green-50 to-emerald-50 p-6 rounded-2xl border border-green-100">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm text-gray-500 font-medium">Total Deliveries</p>
              <p className="text-3xl font-bold text-gray-900 mt-2">{totalDeliveries}</p>
              <p className="text-sm text-green-600 mt-1">8 this week</p>
            </div>
            <div className="p-3 bg-gradient-to-r from-green-100 to-emerald-100 text-green-700 rounded-xl">
              <Package size={24} />
            </div>
          </div>
        </div>

        <div className="bg-gradient-to-br from-blue-50 to-cyan-50 p-6 rounded-2xl border border-blue-100">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm text-gray-500 font-medium">Average Rating</p>
              <p className="text-3xl font-bold text-gray-900 mt-2">{averageRating}/5</p>
              <p className="text-sm text-green-600 mt-1">Excellent</p>
            </div>
            <div className="p-3 bg-gradient-to-r from-blue-100 to-cyan-100 text-blue-700 rounded-xl">
              <CheckCircle size={24} />
            </div>
          </div>
        </div>

        <div className="bg-gradient-to-br from-purple-50 to-violet-50 p-6 rounded-2xl border border-purple-100">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm text-gray-500 font-medium">Avg. Time</p>
              <p className="text-3xl font-bold text-gray-900 mt-2">38 min</p>
              <p className="text-sm text-green-600 mt-1">Faster than average</p>
            </div>
            <div className="p-3 bg-gradient-to-r from-purple-100 to-violet-100 text-purple-700 rounded-xl">
              <Clock size={24} />
            </div>
          </div>
        </div>
      </div>

      {/* Filter & History Table */}
      <div className="bg-white rounded-2xl shadow-lg p-6">
        <div className="flex flex-col md:flex-row md:items-center justify-between gap-4 mb-6">
          <div>
            <h2 className="text-xl font-bold text-gray-900">Recent Deliveries</h2>
            <p className="text-gray-500">Your completed delivery history</p>
          </div>
          
          <div className="flex items-center gap-3">
            <div className="flex items-center gap-2 text-gray-500">
              <Filter size={18} />
              <span>Filter by:</span>
            </div>
            <div className="flex items-center gap-2">
              {['all', 'today', 'yesterday', '5-star'].map((filterOption) => (
                <button
                  key={filterOption}
                  onClick={() => setFilter(filterOption)}
                  className={`px-4 py-2 rounded-lg font-medium transition-all ${
                    filter === filterOption
                      ? 'bg-gradient-to-r from-orange-500 to-amber-600 text-white shadow-md'
                      : 'bg-gray-100 text-gray-700 hover:bg-gray-200'
                  }`}
                >
                  {filterOption === 'all' ? 'All' : 
                   filterOption === 'today' ? 'Today' : 
                   filterOption === 'yesterday' ? 'Yesterday' : '5⭐'}
                </button>
              ))}
            </div>
          </div>
        </div>

        <div className="overflow-x-auto">
          <table className="w-full">
            <thead>
              <tr className="border-b border-gray-200">
                <th className="text-left py-4 px-2 text-sm font-medium text-gray-500">Delivery ID</th>
                <th className="text-left py-4 px-2 text-sm font-medium text-gray-500">Customer</th>
                <th className="text-left py-4 px-2 text-sm font-medium text-gray-500">Date & Time</th>
                <th className="text-left py-4 px-2 text-sm font-medium text-gray-500">Amount</th>
                <th className="text-left py-4 px-2 text-sm font-medium text-gray-500">Items</th>
                <th className="text-left py-4 px-2 text-sm font-medium text-gray-500">Rating</th>
                <th className="text-left py-4 px-2 text-sm font-medium text-gray-500">Status</th>
              </tr>
            </thead>
            <tbody>
              {filteredHistory.map((delivery) => (
                <tr key={delivery.id} className="border-b border-gray-100 hover:bg-gray-50 transition-colors">
                  <td className="py-4 px-2">
                    <p className="font-bold text-gray-900">{delivery.id}</p>
                  </td>
                  <td className="py-4 px-2">
                    <p className="font-medium text-gray-900">{delivery.customer}</p>
                  </td>
                  <td className="py-4 px-2">
                    <div className="flex items-center gap-2">
                      <Calendar size={16} className="text-gray-400" />
                      <span className="text-gray-700">{delivery.date}</span>
                    </div>
                  </td>
                  <td className="py-4 px-2">
                    <p className="font-bold text-lg text-gray-900">ETB {delivery.amount}</p>
                  </td>
                  <td className="py-4 px-2">
                    <div className="flex items-center gap-2">
                      <Package size={16} className="text-gray-400" />
                      <span className="text-gray-700">{delivery.items}</span>
                    </div>
                  </td>
                  <td className="py-4 px-2">
                    <div className="flex items-center gap-1">
                      {[...Array(5)].map((_, i) => (
                        <svg
                          key={i}
                          className={`w-4 h-4 ${
                            i < delivery.rating ? 'text-yellow-400' : 'text-gray-300'
                          }`}
                          fill="currentColor"
                          viewBox="0 0 20 20"
                        >
                          <path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z" />
                        </svg>
                      ))}
                    </div>
                  </td>
                  <td className="py-4 px-2">
                    <span className="px-3 py-1 bg-green-100 text-green-800 rounded-full text-sm font-medium">
                      {delivery.status}
                    </span>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>

        {/* Pagination */}
        <div className="flex items-center justify-between mt-6">
          <p className="text-gray-500">
            Showing {filteredHistory.length} of {deliveryHistory.length} deliveries
          </p>
          <div className="flex items-center gap-2">
            <button className="px-4 py-2 bg-gray-100 text-gray-700 rounded-lg hover:bg-gray-200 transition-colors">
              Previous
            </button>
            <button className="px-4 py-2 bg-gradient-to-r from-orange-500 to-amber-600 text-white rounded-lg">
              1
            </button>
            <button className="px-4 py-2 bg-gray-100 text-gray-700 rounded-lg hover:bg-gray-200 transition-colors">
              2
            </button>
            <button className="px-4 py-2 bg-gray-100 text-gray-700 rounded-lg hover:bg-gray-200 transition-colors">
              3
            </button>
            <button className="px-4 py-2 bg-gray-100 text-gray-700 rounded-lg hover:bg-gray-200 transition-colors">
              Next
            </button>
          </div>
        </div>
      </div>

      {/* Earnings Chart Placeholder */}
      <div className="bg-white rounded-2xl shadow-lg p-6">
        <div className="flex items-center justify-between mb-6">
          <div>
            <h2 className="text-xl font-bold text-gray-900">Earnings Overview</h2>
            <p className="text-gray-500">Weekly and monthly earnings breakdown</p>
          </div>
          <button className="px-4 py-2 bg-gradient-to-r from-orange-500 to-amber-600 text-white rounded-lg font-medium">
            View Detailed Report
          </button>
        </div>
        
        <div className="h-64 bg-gradient-to-br from-orange-50 to-amber-50 rounded-xl flex items-center justify-center">
          <div className="text-center">
            <div className="inline-flex p-4 bg-white rounded-full shadow-lg mb-4">
              <DollarSign className="text-orange-600" size={32} />
            </div>
            <p className="text-gray-700 font-medium">Earnings Analytics</p>
            <p className="text-sm text-gray-500">View detailed earnings charts and insights</p>
          </div>
        </div>
      </div>
    </div>
  )
}

export default DriverHistory