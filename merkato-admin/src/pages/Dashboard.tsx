import { useEffect, useState } from 'react'
import { 
  Users, 
  ShoppingBag, 
  DollarSign, 
  FileCheck,
  TrendingUp,
  Activity
} from 'lucide-react'
import { adminApi } from '../services/api'
import StatCard from '../components/StatCard'

interface DashboardStats {
  stats: {
    totalUsers: number
    totalProducts: number
    totalOrders: number
    totalRevenue: number
    pendingApplications: number
    newUsers: number
  }
  recentOrders: any[]
  pendingSellerApps: number
  pendingDriverApps: number
}

const Dashboard = () => {
  const [stats, setStats] = useState<DashboardStats | null>(null)
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    fetchStats()
  }, [])

  const fetchStats = async () => {
    try {
      const response = await adminApi.getStats()
      setStats(response.data)
    } catch (error) {
      console.error('Failed to fetch stats:', error)
    } finally {
      setLoading(false)
    }
  }

  if (loading) {
    return (
      <div className="flex items-center justify-center h-64">
        <div className="text-lg text-gray-500">Loading dashboard...</div>
      </div>
    )
  }

  return (
    <div className="space-y-6">
      {/* Header */}
      <div>
        <h1 className="text-3xl font-bold text-gray-900">Dashboard</h1>
        <p className="text-gray-500">Welcome back, Admin. Here's what's happening.</p>
      </div>

      {/* Stats Grid */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
        <StatCard
          title="Total Users"
          value={stats?.stats.totalUsers || 0}
          icon={Users}
          color="blue"
          change={stats?.stats.newUsers || 0}
          changeLabel="new this month"
        />
        
        <StatCard
          title="Total Products"
          value={stats?.stats.totalProducts || 0}
          icon={ShoppingBag}
          color="green"
        />
        
        <StatCard
          title="Total Orders"
          value={stats?.stats.totalOrders || 0}
          icon={Activity}
          color="purple"
        />
        
        <StatCard
          title="Total Revenue"
          value={`ETB ${(stats?.stats.totalRevenue || 0).toLocaleString()}`}
          icon={DollarSign}
          color="yellow"
        />
        
        <StatCard
          title="Pending Applications"
          value={stats?.stats.pendingApplications || 0}
          icon={FileCheck}
          color="red"
        />
        
        <StatCard
          title="Growth Rate"
          value="24%"
          icon={TrendingUp}
          color="indigo"
        />
      </div>

      {/* Recent Orders */}
      <div className="glass-card rounded-xl p-6">
        <div className="flex items-center justify-between mb-6">
          <h2 className="text-xl font-bold text-gray-900">Recent Orders</h2>
          <button className="text-primary hover:text-primary/80 font-medium">
            View All
          </button>
        </div>
        
        <div className="overflow-x-auto">
          <table className="w-full">
            <thead>
              <tr className="border-b">
                <th className="text-left py-3 px-4 text-gray-600 font-medium">Order ID</th>
                <th className="text-left py-3 px-4 text-gray-600 font-medium">Customer</th>
                <th className="text-left py-3 px-4 text-gray-600 font-medium">Total</th>
                <th className="text-left py-3 px-4 text-gray-600 font-medium">Status</th>
                <th className="text-left py-3 px-4 text-gray-600 font-medium">Date</th>
              </tr>
            </thead>
            <tbody>
              {stats?.recentOrders.slice(0, 5).map((order: any) => (
                <tr key={order._id} className="border-b hover:bg-gray-50">
                  <td className="py-3 px-4 font-mono text-sm">{order._id.slice(-8)}</td>
                  <td className="py-3 px-4">{order.customerId?.name || 'N/A'}</td>
                  <td className="py-3 px-4">ETB {order.total?.toLocaleString()}</td>
                  <td className="py-3 px-4">
                    <span className={`px-3 py-1 rounded-full text-xs font-medium ${
                      order.status === 'delivered' 
                        ? 'bg-green-100 text-green-800'
                        : order.status === 'pending'
                        ? 'bg-yellow-100 text-yellow-800'
                        : 'bg-blue-100 text-blue-800'
                    }`}>
                      {order.status}
                    </span>
                  </td>
                  <td className="py-3 px-4 text-gray-500 text-sm">
                    {new Date(order.createdAt).toLocaleDateString()}
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>

      {/* Pending Applications */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        <div className="glass-card rounded-xl p-6">
          <h3 className="text-lg font-bold text-gray-900 mb-4">Seller Applications</h3>
          <div className="space-y-4">
            <div className="flex items-center justify-between">
              <div>
                <p className="font-medium">Pending</p>
                <p className="text-sm text-gray-500">Awaiting review</p>
              </div>
              <div className="text-2xl font-bold text-primary">
                {stats?.pendingSellerApps || 0}
              </div>
            </div>
            <button className="btn-primary w-full">
              Review Applications
            </button>
          </div>
        </div>

        <div className="glass-card rounded-xl p-6">
          <h3 className="text-lg font-bold text-gray-900 mb-4">Driver Applications</h3>
          <div className="space-y-4">
            <div className="flex items-center justify-between">
              <div>
                <p className="font-medium">Pending</p>
                <p className="text-sm text-gray-500">Awaiting review</p>
              </div>
              <div className="text-2xl font-bold text-primary">
                {stats?.pendingDriverApps || 0}
              </div>
            </div>
            <button className="btn-primary w-full">
              Review Applications
            </button>
          </div>
        </div>
      </div>
    </div>
  )
}

export default Dashboard