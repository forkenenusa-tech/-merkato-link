import React from 'react'
import { 
  Package, 
  ShoppingBag, 
  DollarSign, 
  TrendingUp,
  Users,
  Star,
  BarChart3,
  Calendar
} from 'lucide-react'
import StatCard from '../components/StatCard'
import RecentOrders from '../components/RecentOrders'
import ProductPerformance from '../components/ProductPerformance'

const SellerDashboard = () => {
  const stats = {
    totalProducts: 24,
    totalOrders: 156,
    totalRevenue: 45280,
    newCustomers: 42,
    rating: 4.8,
    pendingOrders: 8
  }

  const recentOrders = [
    { id: '#ORD-001', customer: 'Abebe Kebede', amount: 2450, status: 'pending', date: '2 hours ago' },
    { id: '#ORD-002', customer: 'Marta Samuel', amount: 1850, status: 'accepted', date: '5 hours ago' },
    { id: '#ORD-003', customer: 'Yohannes Tekle', amount: 3200, status: 'prepared', date: '1 day ago' },
    { id: '#ORD-004', customer: 'Sara Abraham', amount: 1250, status: 'delivered', date: '2 days ago' },
    { id: '#ORD-005', customer: 'Daniel Getachew', amount: 2800, status: 'pending', date: '2 days ago' },
  ]

  const topProducts = [
    { name: 'Ethiopian Coffee Beans', sales: 45, revenue: 15750, rating: 4.9 },
    { name: 'Handwoven Scarf', sales: 32, revenue: 27200, rating: 4.7 },
    { name: 'Traditional Coffee Pot', sales: 18, revenue: 21600, rating: 4.8 },
    { name: 'Spice Mix', sales: 56, revenue: 15680, rating: 4.6 },
  ]

  return (
    <div className="space-y-8">
      {/* Header */}
      <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
        <div>
          <h1 className="text-3xl font-bold text-gray-900">Dashboard</h1>
          <p className="text-gray-500">Welcome back! Here's your store performance.</p>
        </div>
        <div className="flex items-center gap-3">
          <button className="flex items-center gap-2 px-4 py-2 bg-white border border-gray-300 rounded-lg text-gray-700 hover:bg-gray-50">
            <Calendar size={18} />
            This Week
          </button>
          <button className="btn-primary">
            <BarChart3 size={18} />
            Generate Report
          </button>
        </div>
      </div>

      {/* Stats Grid */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-6 gap-6">
        <StatCard
          title="Total Products"
          value={stats.totalProducts}
          icon={Package}
          color="green"
          trend="+3 this month"
        />
        
        <StatCard
          title="Total Orders"
          value={stats.totalOrders}
          icon={ShoppingBag}
          color="blue"
          trend="+12%"
        />
        
        <StatCard
          title="Total Revenue"
          value={`ETB ${stats.totalRevenue.toLocaleString()}`}
          icon={DollarSign}
          color="purple"
          trend="+18%"
        />
        
        <StatCard
          title="New Customers"
          value={stats.newCustomers}
          icon={Users}
          color="amber"
          trend="+8 this week"
        />
        
        <StatCard
          title="Store Rating"
          value={stats.rating.toFixed(1)}
          icon={Star}
          color="yellow"
          trend="4.9 avg"
        />
        
        <StatCard
          title="Pending Orders"
          value={stats.pendingOrders}
          icon={TrendingUp}
          color="red"
          trend="Need attention"
        />
      </div>

      {/* Charts and Tables */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-8">
        {/* Recent Orders */}
        <div className="glass-card rounded-2xl p-6">
          <div className="flex items-center justify-between mb-6">
            <div>
              <h2 className="text-xl font-bold text-gray-900">Recent Orders</h2>
              <p className="text-gray-500">Latest customer orders</p>
            </div>
            <button className="text-green-600 hover:text-green-700 font-medium">
              View All
            </button>
          </div>
          <RecentOrders orders={recentOrders} />
        </div>

        {/* Product Performance */}
        <div className="glass-card rounded-2xl p-6">
          <div className="flex items-center justify-between mb-6">
            <div>
              <h2 className="text-xl font-bold text-gray-900">Top Products</h2>
              <p className="text-gray-500">Best selling products</p>
            </div>
            <button className="text-green-600 hover:text-green-700 font-medium">
              See Details
            </button>
          </div>
          <ProductPerformance products={topProducts} />
        </div>
      </div>

      {/* Quick Actions */}
      <div className="glass-card rounded-2xl p-6">
        <h2 className="text-xl font-bold text-gray-900 mb-4">Quick Actions</h2>
        <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
          <button className="p-4 bg-gradient-to-r from-green-50 to-emerald-50 rounded-xl border border-green-100 hover:border-green-300 transition-all text-left">
            <div className="flex items-center gap-3 mb-2">
              <div className="p-2 bg-green-100 rounded-lg">
                <Package className="text-green-600" size={20} />
              </div>
              <span className="font-semibold">Add New Product</span>
            </div>
            <p className="text-sm text-gray-500">Upload new items to your store</p>
          </button>
          
          <button className="p-4 bg-gradient-to-r from-blue-50 to-sky-50 rounded-xl border border-blue-100 hover:border-blue-300 transition-all text-left">
            <div className="flex items-center gap-3 mb-2">
              <div className="p-2 bg-blue-100 rounded-lg">
                <ShoppingBag className="text-blue-600" size={20} />
              </div>
              <span className="font-semibold">Process Orders</span>
            </div>
            <p className="text-sm text-gray-500">Review and process pending orders</p>
          </button>
          
          <button className="p-4 bg-gradient-to-r from-purple-50 to-violet-50 rounded-xl border border-purple-100 hover:border-purple-300 transition-all text-left">
            <div className="flex items-center gap-3 mb-2">
              <div className="p-2 bg-purple-100 rounded-lg">
                <BarChart3 className="text-purple-600" size={20} />
              </div>
              <span className="font-semibold">View Analytics</span>
            </div>
            <p className="text-sm text-gray-500">Detailed sales and performance reports</p>
          </button>
        </div>
      </div>
    </div>
  )
}

export default SellerDashboard