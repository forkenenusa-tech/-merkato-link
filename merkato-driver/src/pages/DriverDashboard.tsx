import React from 'react'
import { 
  Package, 
  DollarSign, 
  TrendingUp,
  Clock,
  Star,
  MapPin,
  Car,
  Navigation
} from 'lucide-react'

const DriverDashboard = () => {
  const stats = {
    todaysDeliveries: 3,
    weeklyEarnings: 4250,
    totalDeliveries: 89,
    averageRating: 4.7,
    activeDeliveries: 2,
    completionRate: '94%'
  }

  const activeDeliveries = [
    { id: '#DEL-001', pickup: 'Bole Area', dropoff: 'Kirkos', distance: '5 km', status: 'on the way', eta: '30 min' },
    { id: '#DEL-002', pickup: 'Piazza', dropoff: 'Megenagna', distance: '7 km', status: 'picked up', eta: '45 min' },
  ]

  const recentDeliveries = [
    { id: '#DEL-003', customer: 'Abebe Kebede', amount: 250, status: 'delivered', time: '2 hours ago' },
    { id: '#DEL-004', customer: 'Marta Samuel', amount: 300, status: 'delivered', time: '5 hours ago' },
    { id: '#DEL-005', customer: 'Yohannes Tekle', amount: 300, status: 'delivered', time: '1 day ago' },
  ]

  return (
    <div className="space-y-8">
      {/* Header */}
      <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
        <div>
          <h1 className="text-3xl font-bold text-gray-900">Delivery Dashboard</h1>
          <p className="text-gray-500">Welcome back! Ready for your next delivery?</p>
        </div>
        <div className="flex items-center gap-3">
          <button className="flex items-center gap-2 px-4 py-2 bg-gradient-to-r from-green-500 to-emerald-600 text-white rounded-lg font-semibold shadow-lg">
            <Navigation size={18} />
            Go Online
          </button>
          <button className="flex items-center gap-2 px-4 py-2 bg-white border border-gray-300 rounded-lg text-gray-700 hover:bg-gray-50">
            <MapPin size={18} />
            View Map
          </button>
        </div>
      </div>

      {/* Stats Grid */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-6 gap-6">
        <StatCard
          title="Today's Deliveries"
          value={stats.todaysDeliveries}
          icon={Package}
          color="orange"
          trend="+1 more"
        />
        
        <StatCard
          title="Weekly Earnings"
          value={`ETB ${stats.weeklyEarnings}`}
          icon={DollarSign}
          color="green"
          trend="ETB 850 today"
        />
        
        <StatCard
          title="Total Deliveries"
          value={stats.totalDeliveries}
          icon={TrendingUp}
          color="blue"
          trend="89 completed"
        />
        
        <StatCard
          title="Average Rating"
          value={stats.averageRating.toFixed(1)}
          icon={Star}
          color="yellow"
          trend="4.9 this week"
        />
        
        <StatCard
          title="Active Deliveries"
          value={stats.activeDeliveries}
          icon={Clock}
          color="purple"
          trend="2 in progress"
        />
        
        <StatCard
          title="Completion Rate"
          value={stats.completionRate}
          icon={Car}
          color="red"
          trend="Excellent"
        />
      </div>

      {/* Active Deliveries & Recent */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-8">
        {/* Active Deliveries */}
        <div className="bg-white rounded-2xl shadow-lg p-6">
          <div className="flex items-center justify-between mb-6">
            <div>
              <h2 className="text-xl font-bold text-gray-900">Active Deliveries</h2>
              <p className="text-gray-500">Deliveries in progress</p>
            </div>
            <span className="px-3 py-1 bg-orange-100 text-orange-800 rounded-full text-sm font-medium">
              {activeDeliveries.length} Active
            </span>
          </div>
          
          <div className="space-y-4">
            {activeDeliveries.map((delivery) => (
              <div key={delivery.id} className="p-4 bg-gradient-to-r from-orange-50 to-amber-50 rounded-xl border border-orange-100">
                <div className="flex items-center justify-between mb-3">
                  <div className="flex items-center gap-3">
                    <div className="p-2 bg-orange-100 rounded-lg">
                      <Package className="text-orange-600" size={20} />
                    </div>
                    <div>
                      <p className="font-bold text-gray-900">{delivery.id}</p>
                      <p className="text-sm text-gray-500">{delivery.distance} • {delivery.eta}</p>
                    </div>
                  </div>
                  <span className="px-3 py-1 bg-orange-100 text-orange-800 rounded-full text-sm font-medium">
                    {delivery.status}
                  </span>
                </div>
                
                <div className="grid grid-cols-2 gap-4 text-sm">
                  <div>
                    <p className="text-gray-500 mb-1">Pickup</p>
                    <p className="font-medium">{delivery.pickup}</p>
                  </div>
                  <div>
                    <p className="text-gray-500 mb-1">Dropoff</p>
                    <p className="font-medium">{delivery.dropoff}</p>
                  </div>
                </div>
                
                <div className="flex gap-3 mt-4">
                  <button className="flex-1 bg-gradient-to-r from-green-500 to-emerald-600 text-white py-2 rounded-lg font-medium">
                    Navigate
                  </button>
                  <button className="flex-1 bg-white border border-orange-300 text-orange-700 py-2 rounded-lg font-medium">
                    Update Status
                  </button>
                </div>
              </div>
            ))}
            
            {activeDeliveries.length === 0 && (
              <div className="text-center py-8">
                <div className="inline-flex p-4 bg-gray-100 rounded-full mb-4">
                  <Package size={24} className="text-gray-400" />
                </div>
                <p className="text-gray-500">No active deliveries</p>
                <p className="text-sm text-gray-400 mt-1">You're ready for new assignments</p>
              </div>
            )}
          </div>
        </div>

        {/* Recent Deliveries */}
        <div className="bg-white rounded-2xl shadow-lg p-6">
          <div className="flex items-center justify-between mb-6">
            <div>
              <h2 className="text-xl font-bold text-gray-900">Recent Deliveries</h2>
              <p className="text-gray-500">Recently completed deliveries</p>
            </div>
            <button className="text-orange-600 hover:text-orange-700 font-medium">
              View All
            </button>
          </div>
          
          <div className="space-y-4">
            {recentDeliveries.map((delivery) => (
              <div key={delivery.id} className="flex items-center justify-between p-4 hover:bg-gray-50 rounded-xl transition-colors group">
                <div className="flex items-center gap-4">
                  <div className="p-2 bg-green-100 rounded-lg">
                    <CheckCircle className="text-green-600" size={20} />
                  </div>
                  <div>
                    <p className="font-medium text-gray-900">{delivery.id}</p>
                    <p className="text-sm text-gray-500">{delivery.customer}</p>
                  </div>
                </div>
                
                <div className="text-right">
                  <p className="font-bold text-lg text-gray-900">ETB {delivery.amount}</p>
                  <p className="text-sm text-gray-500">{delivery.time}</p>
                </div>
              </div>
            ))}
          </div>
          
          {/* Quick Stats */}
          <div className="mt-8 p-4 bg-gradient-to-r from-green-50 to-emerald-50 rounded-xl">
            <div className="grid grid-cols-2 gap-4">
              <div>
                <p className="text-sm text-gray-500">Today's Earnings</p>
                <p className="text-2xl font-bold text-gray-900">ETB 850</p>
              </div>
              <div>
                <p className="text-sm text-gray-500">Avg. Delivery Time</p>
                <p className="text-2xl font-bold text-gray-900">38 min</p>
              </div>
            </div>
          </div>
        </div>
      </div>

      {/* Map Section (Placeholder) */}
      <div className="bg-white rounded-2xl shadow-lg p-6">
        <div className="flex items-center justify-between mb-6">
          <div>
            <h2 className="text-xl font-bold text-gray-900">Delivery Area Map</h2>
            <p className="text-gray-500">Your current delivery locations</p>
          </div>
          <button className="flex items-center gap-2 px-4 py-2 bg-gradient-to-r from-orange-500 to-amber-600 text-white rounded-lg font-medium">
            <MapPin size={18} />
            Full Screen Map
          </button>
        </div>
        
        <div className="h-64 bg-gradient-to-br from-blue-50 to-cyan-50 rounded-xl flex items-center justify-center">
          <div className="text-center">
            <div className="inline-flex p-4 bg-white rounded-full shadow-lg mb-4">
              <MapPin className="text-orange-600" size={32} />
            </div>
            <p className="text-gray-700 font-medium">Interactive Map View</p>
            <p className="text-sm text-gray-500">Shows pickup and dropoff locations</p>
          </div>
        </div>
      </div>
    </div>
  )
}

// Helper components
const StatCard = ({ title, value, icon: Icon, color, trend }: any) => {
  const colorClasses = {
    orange: 'bg-gradient-to-br from-orange-100 to-amber-100 text-orange-700',
    green: 'bg-gradient-to-br from-green-100 to-emerald-100 text-green-700',
    blue: 'bg-gradient-to-br from-blue-100 to-cyan-100 text-blue-700',
    yellow: 'bg-gradient-to-br from-yellow-100 to-amber-100 text-yellow-700',
    purple: 'bg-gradient-to-br from-purple-100 to-violet-100 text-purple-700',
    red: 'bg-gradient-to-br from-red-100 to-rose-100 text-red-700',
  }

  return (
    <div className="bg-white p-6 rounded-2xl shadow-sm border border-gray-100 hover:shadow-md transition-shadow">
      <div className="flex items-center justify-between">
        <div>
          <p className="text-sm text-gray-500 font-medium">{title}</p>
          <p className="text-3xl font-bold text-gray-900 mt-2">{value}</p>
          {trend && <p className="text-sm text-green-600 mt-1">{trend}</p>}
        </div>
        <div className={`p-3 rounded-xl ${colorClasses[color]}`}>
          <Icon size={24} />
        </div>
      </div>
    </div>
  )
}

const CheckCircle = ({ size, className }: any) => (
  <svg xmlns="http://www.w3.org/2000/svg" width={size} height={size} viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" className={className}>
    <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path>
    <polyline points="22 4 12 14.01 9 11.01"></polyline>
  </svg>
)

export default DriverDashboard