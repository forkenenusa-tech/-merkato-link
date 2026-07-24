import React, { useEffect, useState } from 'react'
import { Search, Filter, Edit, Trash2, Plus } from 'lucide-react'
import { adminApi } from '../services/api'

interface Product {
  _id: string
  name: string
  category: string
  price: number
  discount: number
  stock: number
  rating: number
  sellerId: {
    name: string
    email: string
  }
  createdAt: string
}

const Products = () => {
  const [products, setProducts] = useState<Product[]>([])
  const [loading, setLoading] = useState(true)
  const [search, setSearch] = useState('')
  const [category, setCategory] = useState('all')

  useEffect(() => {
    fetchProducts()
  }, [search, category])

  const fetchProducts = async () => {
    try {
      const params: any = {}
      if (search) params.search = search
      if (category !== 'all') params.category = category
      
      const response = await adminApi.getProducts(params)
      setProducts(response.data.products)
    } catch (error) {
      console.error('Failed to fetch products:', error)
    } finally {
      setLoading(false)
    }
  }

  const handleDelete = async (id: string) => {
    if (!window.confirm('Are you sure you want to delete this product?')) return
    
    try {
      await adminApi.deleteProduct(id)
      fetchProducts() // Refresh list
    } catch (error) {
      console.error('Failed to delete product:', error)
    }
  }

  const categories = [
    'all', 'electronics', 'clothing', 'food', 'home', 'beauty', 'books', 'other'
  ]

  if (loading) {
    return (
      <div className="flex items-center justify-center h-64">
        <div className="text-lg text-gray-500">Loading products...</div>
      </div>
    )
  }

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
        <div>
          <h1 className="text-3xl font-bold text-gray-900">Products</h1>
          <p className="text-gray-500">Manage all marketplace products</p>
        </div>
        <button className="btn-primary flex items-center gap-2">
          <Plus size={20} />
          Add Product
        </button>
      </div>

      {/* Filters */}
      <div className="glass-card rounded-xl p-6">
        <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
          <div className="relative">
            <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400" size={20} />
            <input
              type="text"
              placeholder="Search products..."
              value={search}
              onChange={(e) => setSearch(e.target.value)}
              className="input-field pl-10 w-full"
            />
          </div>
          
          <div className="flex items-center gap-2">
            <Filter size={20} className="text-gray-400" />
            <select
              value={category}
              onChange={(e) => setCategory(e.target.value)}
              className="input-field w-full"
            >
              {categories.map((cat) => (
                <option key={cat} value={cat}>
                  {cat === 'all' ? 'All Categories' : cat.charAt(0).toUpperCase() + cat.slice(1)}
                </option>
              ))}
            </select>
          </div>
        </div>
      </div>

      {/* Products Table */}
      <div className="glass-card rounded-xl overflow-hidden">
        <div className="overflow-x-auto">
          <table className="w-full">
            <thead>
              <tr className="bg-gray-50">
                <th className="text-left py-4 px-6 font-medium text-gray-600">Product</th>
                <th className="text-left py-4 px-6 font-medium text-gray-600">Category</th>
                <th className="text-left py-4 px-6 font-medium text-gray-600">Price</th>
                <th className="text-left py-4 px-6 font-medium text-gray-600">Stock</th>
                <th className="text-left py-4 px-6 font-medium text-gray-600">Seller</th>
                <th className="text-left py-4 px-6 font-medium text-gray-600">Actions</th>
              </tr>
            </thead>
            <tbody>
              {products.length === 0 ? (
                <tr>
                  <td colSpan={6} className="py-8 px-6 text-center text-gray-500">
                    No products found
                  </td>
                </tr>
              ) : (
                products.map((product) => (
                  <tr key={product._id} className="border-b hover:bg-gray-50">
                    <td className="py-4 px-6">
                      <div>
                        <p className="font-medium">{product.name}</p>
                        <div className="flex items-center gap-1 mt-1">
                          <div className="flex items-center">
                            {[...Array(5)].map((_, i) => (
                              <div
                                key={i}
                                className={`w-4 h-4 ${
                                  i < Math.floor(product.rating)
                                    ? 'text-yellow-400 fill-current'
                                    : 'text-gray-300'
                                }`}
                              >
                                ★
                              </div>
                            ))}
                          </div>
                          <span className="text-sm text-gray-500">{product.rating.toFixed(1)}</span>
                        </div>
                      </div>
                    </td>
                    <td className="py-4 px-6">
                      <span className="px-3 py-1 bg-primary/10 text-primary rounded-full text-sm font-medium">
                        {product.category}
                      </span>
                    </td>
                    <td className="py-4 px-6">
                      <div>
                        <p className="font-bold text-lg">
                          ETB {product.price.toLocaleString()}
                        </p>
                        {product.discount > 0 && (
                          <p className="text-sm text-red-600 line-through">
                            ETB {(product.price / (1 - product.discount / 100)).toLocaleString()}
                          </p>
                        )}
                      </div>
                    </td>
                    <td className="py-4 px-6">
                      <span className={`px-3 py-1 rounded-full text-sm font-medium ${
                        product.stock > 10
                          ? 'bg-green-100 text-green-800'
                          : product.stock > 0
                          ? 'bg-yellow-100 text-yellow-800'
                          : 'bg-red-100 text-red-800'
                      }`}>
                        {product.stock} units
                      </span>
                    </td>
                    <td className="py-4 px-6">
                      <div>
                        <p className="font-medium">{product.sellerId?.name || 'Unknown'}</p>
                        <p className="text-sm text-gray-500">{product.sellerId?.email || ''}</p>
                      </div>
                    </td>
                    <td className="py-4 px-6">
                      <div className="flex items-center gap-2">
                        <button className="p-2 text-blue-600 hover:bg-blue-50 rounded-lg">
                          <Edit size={18} />
                        </button>
                        <button
                          onClick={() => handleDelete(product._id)}
                          className="p-2 text-red-600 hover:bg-red-50 rounded-lg"
                        >
                          <Trash2 size={18} />
                        </button>
                      </div>
                    </td>
                  </tr>
                ))
              )}
            </tbody>
          </table>
        </div>
      </div>

      {/* Stats */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
        <div className="stat-card">
          <p className="text-sm text-gray-500">Total Products</p>
          <p className="text-3xl font-bold text-gray-900 mt-2">{products.length}</p>
        </div>
        <div className="stat-card">
          <p className="text-sm text-gray-500">Low Stock</p>
          <p className="text-3xl font-bold text-gray-900 mt-2">
            {products.filter(p => p.stock <= 10 && p.stock > 0).length}
          </p>
        </div>
        <div className="stat-card">
          <p className="text-sm text-gray-500">Out of Stock</p>
          <p className="text-3xl font-bold text-gray-900 mt-2">
            {products.filter(p => p.stock === 0).length}
          </p>
        </div>
      </div>
    </div>
  )
}

export default Products