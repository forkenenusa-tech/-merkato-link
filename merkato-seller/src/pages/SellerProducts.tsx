import React, { useState } from 'react'
import { Plus, Search, Filter, Edit, Trash2, Package, DollarSign, Star, Eye } from 'lucide-react'

const SellerProducts = () => {
  const [searchTerm, setSearchTerm] = useState('')
  const [filter, setFilter] = useState('all')

  const products = [
    { id: '#PROD-001', name: 'Fresh Coffee Beans', category: 'Food & Beverage', price: 350, stock: 42, sold: 156, rating: 4.8, status: 'active' },
    { id: '#PROD-002', name: 'Handmade Basket', category: 'Handicrafts', price: 120, stock: 18, sold: 89, rating: 4.9, status: 'active' },
    { id: '#PROD-003', name: 'Traditional Spices Set', category: 'Food & Beverage', price: 280, stock: 0, sold: 203, rating: 4.7, status: 'out of stock' },
    { id: '#PROD-004', name: 'Ethiopian Shawl', category: 'Clothing', price: 450, stock: 25, sold: 67, rating: 4.6, status: 'active' },
    { id: '#PROD-005', name: 'Clay Coffee Pot', category: 'Handicrafts', price: 320, stock: 12, sold: 45, rating: 4.9, status: 'active' },
    { id: '#PROD-006', name: 'Honey Jar', category: 'Food & Beverage', price: 180, stock: 36, sold: 112, rating: 4.5, status: 'active' },
    { id: '#PROD-007', name: 'Leather Sandals', category: 'Clothing', price: 240, stock: 8, sold: 78, rating: 4.4, status: 'low stock' },
    { id: '#PROD-008', name: 'Injera Basket', category: 'Food & Beverage', price: 150, stock: 50, sold: 134, rating: 4.8, status: 'active' },
  ]

  const filteredProducts = products.filter(product => {
    const matchesSearch = product.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
                         product.category.toLowerCase().includes(searchTerm.toLowerCase())
    const matchesFilter = filter === 'all' || product.status === filter
    return matchesSearch && matchesFilter
  })

  const stats = {
    totalProducts: products.length,
    totalRevenue: products.reduce((sum, p) => sum + (p.price * p.sold), 0),
    outOfStock: products.filter(p => p.status === 'out of stock').length,
    lowStock: products.filter(p => p.status === 'low stock').length,
  }

  return (
    <div className="space-y-8">
      {/* Header */}
      <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
        <div>
          <h1 className="text-3xl font-bold text-gray-900">Product Management</h1>
          <p className="text-gray-500">Manage your store products and inventory</p>
        </div>
        <button className="flex items-center gap-2 px-4 py-2 bg-gradient-to-r from-green-500 to-emerald-600 text-white rounded-lg font-medium shadow-md hover:shadow-lg transition-all">
          <Plus size={18} />
          Add New Product
        </button>
      </div>

      {/* Stats */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
        <div className="bg-white p-6 rounded-2xl shadow-sm border border-gray-100">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm text-gray-500 font-medium">Total Products</p>
              <p className="text-3xl font-bold text-gray-900 mt-2">{stats.totalProducts}</p>
              <p className="text-sm text-green-600 mt-1">+3 this month</p>
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
              <p className="text-sm text-green-600 mt-1">+15% growth</p>
            </div>
            <div className="p-3 bg-gradient-to-r from-blue-100 to-cyan-100 text-blue-700 rounded-xl">
              <DollarSign size={24} />
            </div>
          </div>
        </div>

        <div className="bg-white p-6 rounded-2xl shadow-sm border border-gray-100">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm text-gray-500 font-medium">Out of Stock</p>
              <p className="text-3xl font-bold text-gray-900 mt-2">{stats.outOfStock}</p>
              <p className="text-sm text-red-600 mt-1">Needs restocking</p>
            </div>
            <div className="p-3 bg-gradient-to-r from-red-100 to-rose-100 text-red-700 rounded-xl">
              <Package size={24} />
            </div>
          </div>
        </div>

        <div className="bg-white p-6 rounded-2xl shadow-sm border border-gray-100">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm text-gray-500 font-medium">Low Stock</p>
              <p className="text-3xl font-bold text-gray-900 mt-2">{stats.lowStock}</p>
              <p className="text-sm text-amber-600 mt-1">Monitor closely</p>
            </div>
            <div className="p-3 bg-gradient-to-r from-amber-100 to-yellow-100 text-amber-700 rounded-xl">
              <Package size={24} />
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
              placeholder="Search products by name or category..."
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
              <option value="all">All Products</option>
              <option value="active">Active</option>
              <option value="out of stock">Out of Stock</option>
              <option value="low stock">Low Stock</option>
            </select>
          </div>
        </div>

        {/* Products Table */}
        <div className="overflow-x-auto">
          <table className="w-full">
            <thead>
              <tr className="border-b border-gray-200">
                <th className="text-left py-4 px-2 text-sm font-medium text-gray-500">Product</th>
                <th className="text-left py-4 px-2 text-sm font-medium text-gray-500">Category</th>
                <th className="text-left py-4 px-2 text-sm font-medium text-gray-500">Price</th>
                <th className="text-left py-4 px-2 text-sm font-medium text-gray-500">Stock</th>
                <th className="text-left py-4 px-2 text-sm font-medium text-gray-500">Sold</th>
                <th className="text-left py-4 px-2 text-sm font-medium text-gray-500">Rating</th>
                <th className="text-left py-4 px-2 text-sm font-medium text-gray-500">Status</th>
                <th className="text-left py-4 px-2 text-sm font-medium text-gray-500">Actions</th>
              </tr>
            </thead>
            <tbody>
              {filteredProducts.map((product) => (
                <tr key={product.id} className="border-b border-gray-100 hover:bg-gray-50 transition-colors">
                  <td className="py-4 px-2">
                    <div className="flex items-center gap-3">
                      <div className="w-10 h-10 bg-gradient-to-r from-green-100 to-emerald-100 rounded-lg flex items-center justify-center">
                        <Package size={20} className="text-green-600" />
                      </div>
                      <div>
                        <p className="font-bold text-gray-900">{product.name}</p>
                        <p className="text-sm text-gray-500">{product.id}</p>
                      </div>
                    </div>
                  </td>
                  <td className="py-4 px-2">
                    <span className="px-3 py-1 bg-blue-100 text-blue-800 rounded-full text-sm">
                      {product.category}
                    </span>
                  </td>
                  <td className="py-4 px-2">
                    <p className="font-bold text-gray-900">ETB {product.price}</p>
                  </td>
                  <td className="py-4 px-2">
                    <p className={`font-medium ${
                      product.stock === 0 ? 'text-red-600' :
                      product.stock < 10 ? 'text-amber-600' : 'text-gray-900'
                    }`}>
                      {product.stock} units
                    </p>
                  </td>
                  <td className="py-4 px-2">
                    <p className="font-medium text-gray-900">{product.sold} sold</p>
                  </td>
                  <td className="py-4 px-2">
                    <div className="flex items-center gap-2">
                      <Star size={16} className="text-yellow-400 fill-yellow-400" />
                      <span className="font-medium">{product.rating}/5</span>
                    </div>
                  </td>
                  <td className="py-4 px-2">
                    <span className={`px-3 py-1 rounded-full text-sm font-medium ${
                      product.status === 'active' ? 'bg-green-100 text-green-800' :
                      product.status === 'out of stock' ? 'bg-red-100 text-red-800' :
                      'bg-amber-100 text-amber-800'
                    }`}>
                      {product.status}
                    </span>
                  </td>
                  <td className="py-4 px-2">
                    <div className="flex items-center gap-2">
                      <button className="p-2 hover:bg-green-50 text-green-600 rounded-lg transition-colors">
                        <Eye size={18} />
                      </button>
                      <button className="p-2 hover:bg-blue-50 text-blue-600 rounded-lg transition-colors">
                        <Edit size={18} />
                      </button>
                      <button className="p-2 hover:bg-red-50 text-red-600 rounded-lg transition-colors">
                        <Trash2 size={18} />
                      </button>
                    </div>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>

        {/* Empty State */}
        {filteredProducts.length === 0 && (
          <div className="text-center py-12">
            <div className="inline-flex p-6 bg-gradient-to-r from-green-50 to-emerald-50 rounded-full mb-6">
              <Search size={48} className="text-green-600" />
            </div>
            <h3 className="text-2xl font-bold text-gray-900 mb-3">No products found</h3>
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

        {/* Pagination */}
        <div className="flex items-center justify-between mt-6">
          <p className="text-gray-500">
            Showing {filteredProducts.length} of {products.length} products
          </p>
          <div className="flex items-center gap-2">
            <button className="px-4 py-2 bg-gray-100 text-gray-700 rounded-lg hover:bg-gray-200 transition-colors">
              Previous
            </button>
            <button className="px-4 py-2 bg-gradient-to-r from-green-500 to-emerald-600 text-white rounded-lg">
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
    </div>
  )
}

export default SellerProducts