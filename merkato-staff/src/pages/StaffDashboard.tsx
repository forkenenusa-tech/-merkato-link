import React from 'react'
import { 
  FileText, 
  Users, 
  ShoppingBag,
  Clock,
  CheckCircle,
  XCircle,
  AlertCircle,
  BarChart3
} from 'lucide-react'

const StaffDashboard = () => {
  const stats = {
    pendingApplications: 12,
    totalApplications: 45,
    pendingOrders: 8,
    totalOrders: 156,
    newUsers: 23,
    approvalRate: '89%'
  }

  const pendingApplications = [
    { id: 'APP-001', type: 'seller', business: 'Ethio Crafts', submitted: '2 hours ago', status: 'pending' },
    { id: 'APP-002', type: 'driver', name: 'Abebe Kebede', submitted: '5 hours ago', status: 'pending' },
    { id: 'APP-003', type: 'seller', business: 'Coffee Roasters', submitted: '1 day ago', status: 'pending' },
    { id: 'APP-004', type: 'driver', name: 'Marta Samuel', submitted: '1 day ago', status: 'pending' },
  ]

  const recentActivities = [
    { action: 'Application approved', target: 'Seller: Handmade Crafts', time: '2 hours ago', status: 'approved' },
    { action: 'Order status updated', target: 'Order #ORD-045', time: '5 hours ago', status: 'updated' },
    { action: 'Application rejected', target: 'Driver: License expired', time: '1 day ago', status: 'rejected' },
    { action: 'User suspended', target: 'User: Test Account', time: '2 days ago', status: 'suspended' },
  ]

  return (
    <div className="space-y-8">
      {/* Header */}
      <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
        <div>
          <h1 className="text-3xl font-bold text-gray-900">Operations Dashboard</h1>
          <p className="text-gray-500">Manage applications, orders, and system operations</p>
        </div>
        <div className="flex items-center gap-3">
          <button className="flex items-center gap-2 px-4 py-2 bg-gradient-to-r from-blue-500 to-indigo-600 text-white rounded-lg font-semibold shadow-lg">
            <BarChart3 size={18} />
            Generate Report
          </button>
          <button className="flex items-center gap-2 px-4 py-2 bg-white border border-gray-300 rounded-lg text-gray-700 hover:bg-gray-50">
            <Clock size={18} />
            Today's Tasks
          </button>
        </div>
      </div>

      {/* Stats Grid */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-6 gap-6">
        <StatCard
          title="Pending Applications"
          value={stats.pendingApplications}
          icon={FileText}
          color="blue"
          trend="Needs review"
        />
        
        <StatCard
          title="Total Applications"
          value={stats.totalApplications}
          icon={Users}
          color="purple"
          trend="45 processed"
        />
        
        <StatCard
          title="Pending Orders"
          value={stats.pendingOrders}
          icon={ShoppingBag}
          color="orange"
          trend="8 awaiting"
        />
        
        <StatCard
          title="Total Orders"
          value={stats.totalOrders}
          icon={BarChart3}
          color="green"
          trend="156 total"
        />
        
        <StatCard
          title="New Users"
          value={stats.newUsers}
          icon={Users}
          color="indigo"
          trend="This week"
        />
        
        <StatCard
          title="Approval Rate"
          value={stats.approvalRate}
          icon={CheckCircle}
          color="teal"
          trend="High"
        />
      </div>

      {/* Pending Applications & Recent Activities */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-8">
        {/* Pending Applications */}
        <div className="bg-white rounded-2xl shadow-lg p-6">
          <div className="flex items-center justify-between mb-6">
            <div>
              <h2 className="text-xl font-bold text-gray-900">Pending Applications</h2>
              <p className="text-gray-500">Applications awaiting review</p>
            </div>
            <span className="px-3 py-1 bg-blue-100 text-blue-800 rounded-full text-sm font-medium">
              {pendingApplications.length} Pending
            </span>
          </div>
          
          <div className="space-y-4">
            {pendingApplications.map((app) => (
              <div key={app.id} className="p-4 bg-gradient-to-r from-blue-50 to-indigo-50 rounded-xl border border-blue-100">
                <div className="flex items-center justify-between mb-3">
                  <div className="flex items-center gap-3">
                    <div className={`p-2 rounded-lg ${
                      app.type === 'seller' ? 'bg-green-100 text-green-600' : 'bg-blue-100 text-blue-600'
                    }`}>
                      {app.type === 'seller' ? '🏪' : '🚗'}
                    </div>
                    <div>
                      <p className="font-bold text-gray-900">{app.id}</p>
                      <p className="text-sm text-gray-500">
                        {app.type === 'seller' ? app.business : app.name}
                      </p>
                    </div>
                  </div>
                  <span className="px-3 py-1 bg-amber-100 text-amber-800 rounded-full text-sm font-medium">
                    {app.status}
                  </span>
                </div>
                
                <div className="flex items-center justify-between text-sm">
                  <div className="text-gray-500">
                    Submitted {app.submitted}
                  </div>
                  <div className="flex gap-2">
                    <button className="px-3 py-1 bg-green-100 text-green-800 rounded-lg font-medium hover:bg-green-200">
                      Approve
                    </button>
                    <button className="px-3 py-1 bg-red-100 text-red-800 rounded-lg font-medium hover:bg-red-200">
                      Reject
                    </button>
                  </div>
                </div>
              </div>
            ))}
            
            {pendingApplications.length === 0 && (
              <div className="text-center py-8">
                <div className="inline-flex p-4 bg-gray-100 rounded-full mb-4">
                  <CheckCircle size={24} className="text-gray-400" />
                </div>
                <p className="text-gray-500">No pending applications</p>
                <p className="text-sm text-gray-400 mt-1">All applications have been reviewed</p>
              </div>
            )}
          </div>
          
          <div className="mt-6 pt-6 border-t">
            <button className="w-full py-3 bg-gradient-to-r from-blue-500 to-indigo-600 text-white rounded-xl font-semibold">
              Review All Applications
            </button>
          </div>
        </div>

        {/* Recent Activities */}
        <div className="bg-white rounded-2xl shadow-lg p-6">
          <div className="flex items-center justify-between mb-6">
            <div>
              <h2 className="text-xl font-bold text-gray-900">Recent Activities</h2>
              <p className="text-gray-500">System activities and updates</p>
            </div>
            <button className="text-blue-600 hover:text-blue-700 font-medium">
              View All
            </button>
          </div>
          
          <div className="space-y-4">
            {recentActivities.map((activity, index) => (
              <div key={index} className="flex items-start gap-4 p-4 hover:bg-gray-50 rounded-xl transition-colors">
                <div className={`p-2 rounded-lg ${
                  activity.status === 'approved' ? 'bg-green-100 text-green-600' :
                  activity.status === 'rejected' ? 'bg-red-100 text-red-600' :
                  activity.status === 'suspended' ? 'bg-amber-100 text-amber-600' :
                  'bg-blue-100 text-blue-600'
                }`}>
                  {activity.status === 'approved' ? <CheckCircle size={18} /> :
                   activity.status === 'rejected' ? <XCircle size={18} /> :
                   activity.status === 'suspended' ? <AlertCircle size={18} /> :
                   <Clock size={18} />}
                </div>
                
                <div className="flex-1">
                  <p className="font-medium text-gray-900">{activity.action}</p>
                  <p className="text-sm text-gray-500">{activity.target}</p>
                </div>
                
                <div className="text-right">
                  <p className="text-sm text-gray-500">{activity.time}</p>
                  <span className={`text-xs px-2 py-1 rounded-full ${
                    activity.status === 'approved' ? 'bg-green-100 text-green-800' :
                    activity.status === 'rejected' ? 'bg-red-100 text-red-800' :
                    activity.status === 'suspended' ? 'bg-amber-100 text-amber-800' :
                    'bg-blue-100 text-blue-800'
                  }`}>
                    {activity.status}
                  </span>
                </div>
              </div>
            ))}
          </div>
          
          {/* Quick Stats */}
          <div className="mt-8 p-4 bg-gradient-to-r from-blue-50 to-indigo-50 rounded-xl">
            <div className="grid grid-cols-2 gap-4">
              <div>
                <p className="text-sm text-gray-500">Avg. Review Time</p>
                <p className="text-2xl font-bold text-gray-900">4.2 hrs</p>
              </div>
              <div>
                <p className="text-sm text-gray-500">Applications Today</p>
                <p className="text-2xl font-bold text-gray-900">7</p>
              </div>
            </div>
          </div>
        </div>
      </div>

      {/* Quick Actions */}
      <div className="bg-white rounded-2xl shadow-lg p-6">
        <h2 className="text-xl font-bold text-gray-900 mb-6">Quick Actions</h2>
        <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
          <button className="p-6 bg-gradient-to-r from-blue-50 to-indigo-50 rounded-xl border border-blue-100 hover:border-blue-300 transition-all text-left group">
            <div className="flex items-center gap-4 mb-4">
              <div className="p-3 bg-blue-100 rounded-lg group-hover:scale-110 transition-transform">
                <FileText className="text-blue-600" size={24} />
              </div>
              <div>
                <h3 className="font-bold text-gray-900">Review Applications</h3>
                <p className="text-sm text-gray-500">Seller & Driver apps</p>
              </div>
            </div>
            <div className="text-blue-600 font-medium">12 pending →</div>
          </button>
          
          <button className="p-6 bg-gradient-to-r from-green-50 to-emerald-50 rounded-xl border border-green-100 hover:border-green-300 transition-all text-left group">
            <div className="flex items-center gap-4 mb-4">
              <div className="p-3 bg-green-100 rounded-lg group-hover:scale-110 transition-transform">
                <ShoppingBag className="text-green-600" size={24} />
              </div>
              <div>
                <h3 className="font-bold text-gray-900">Monitor Orders</h3>
                <p className="text-sm text-gray-500">Track order status</p>
              </div>
            </div>
            <div className="text-green-600 font-medium">8 pending →</div>
          </button>
          
          <button className="p-6 bg-gradient-to-r from-purple-50 to-violet-50 rounded-xl border border-purple-100 hover:border-purple-300 transition-all text-left group">
            <div className="flex items-center gap-4 mb-4">
              <div className="p-3 bg-purple-100 rounded-lg group-hover:scale-110 transition-transform">
                <Users className="text-purple-600" size={24} />
              </div>
              <div>
                <h3 className="font-bold text-gray-900">User Management</h3>
                <p className="text-sm text-gray-500">Manage user accounts</p>
              </div>
            </div>
            <div className="text-purple-600 font-medium">23 new →</div>
          </button>
        </div>
      </div>
    </div>
  )
}

// Helper component
const StatCard = ({ title, value, icon: Icon, color, trend }: any) => {
  const colorClasses = {
    blue: 'bg-gradient-to-br from-blue-100 to-indigo-100 text-blue-700',
    purple: 'bg-gradient-to-br from-purple-100 to-violet-100 text-purple-700',
    orange: 'bg-gradient-to-br from-orange-100 to-amber-100 text-orange-700',
    green: 'bg-gradient-to-br from-green-100 to-emerald-100 text-green-700',
    indigo: 'bg-gradient-to-br from-indigo-100 to-blue-100 text-indigo-700',
    teal: 'bg-gradient-to-br from-teal-100 to-cyan-100 text-teal-700',
  }

  return (
    <div className="bg-white p-6 rounded-2xl shadow-sm border border-gray-100 hover:shadow-md transition-shadow">
      <div className="flex items-center justify-between">
        <div>
          <p className="text-sm text-gray-500 font-medium">{title}</p>
          <p className="text-3xl font-bold text-gray-900 mt-2">{value}</p>
          {trend && <p className="text-sm text-blue-600 mt-1">{trend}</p>}
        </div>
        <div className={`p-3 rounded-xl ${colorClasses[color]}`}>
          <Icon size={24} />
        </div>
      </div>
    </div>
  )
}

export default StaffDashboard