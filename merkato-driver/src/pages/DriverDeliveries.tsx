import React from 'react'
import { Package, MapPin, Clock, CheckCircle, Navigation, Phone } from 'lucide-react'

const DriverDeliveries = () => {
  const deliveries = [
    { 
      id: '#DEL-001', 
      customer: 'Abebe Kebede', 
      phone: '+251 91 234 5678',
      pickup: 'Bole Area, Building #12', 
      dropoff: 'Kirkos Subcity, House #45',
      distance: '5.2 km', 
      status: 'on the way', 
      eta: '30 min',
      amount: 250,
      items: 3
    },
    { 
      id: '#DEL-002', 
      customer: 'Marta Samuel', 
      phone: '+251 92 345 6789',
      pickup: 'Piazza, Shop #23', 
      dropoff: 'Megenagna, Apt #78',
      distance: '7.8 km', 
      status: 'picked up', 
      eta: '45 min',
      amount: 300,
      items: 2
    },
    { 
      id: '#DEL-003', 
      customer: 'Yohannes Tekle', 
      phone: '+251 93 456 7890',
      pickup: 'CMC Area, Office #5', 
      dropoff: 'Bole, Residence #12',
      distance: '8.5 km', 
      status: 'assigned', 
      eta: '1 hr',
      amount: 400,
      items: 5
    },
  ]

  const statusColors = {
    assigned: 'bg-blue-100 text-blue-800',
    'picked up': 'bg-purple-100 text-purple-800',
    'on the way': 'bg-orange-100 text-orange-800',
    delivered: 'bg-green-100 text-green-800',
  }

  return (
    <div className="space-y-8">
      <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
        <div>
          <h1 className="text-3xl font-bold text-gray-900">Active Deliveries</h1>
          <p className="text-gray-500">Manage and track your current deliveries</p>
        </div>
        <div className="flex items-center gap-3">
          <div className="px-4 py-2 bg-gradient-to-r from-green-500 to-emerald-600 text-white rounded-lg font-semibold">
            {deliveries.length} Active Deliveries
          </div>
          <button className="flex items-center gap-2 px-4 py-2 bg-gradient-to-r from-orange-500 to-amber-600 text-white rounded-lg font-medium">
            <Navigation size={18} />
            View All on Map
          </button>
        </div>
      </div>

      {/* Delivery Cards */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        {deliveries.map((delivery) => (
          <div key={delivery.id} className="bg-white rounded-2xl shadow-lg p-6 border border-gray-100">
            <div className="flex items-center justify-between mb-6">
              <div className="flex items-center gap-3">
                <div className="p-2 bg-gradient-to-r from-orange-100 to-amber-100 rounded-lg">
                  <Package className="text-orange-600" size={24} />
                </div>
                <div>
                  <h3 className="font-bold text-xl text-gray-900">{delivery.id}</h3>
                  <p className="text-gray-500">{delivery.distance} • {delivery.eta} ETA</p>
                </div>
              </div>
              <span className={`px-3 py-1 rounded-full text-sm font-medium ${statusColors[delivery.status]}`}>
                {delivery.status}
              </span>
            </div>

            {/* Customer Info */}
            <div className="mb-6 p-4 bg-gradient-to-r from-orange-50 to-amber-50 rounded-xl">
              <div className="flex items-center justify-between mb-3">
                <div className="flex items-center gap-3">
                  <div className="w-10 h-10 bg-gradient-to-r from-orange-500 to-amber-600 rounded-full flex items-center justify-center text-white font-bold">
                    {delivery.customer.split(' ')[0][0]}
                  </div>
                  <div>
                    <p className="font-bold text-gray-900">{delivery.customer}</p>
                    <div className="flex items-center gap-2 text-sm text-gray-500">
                      <Phone size={14} />
                      {delivery.phone}
                    </div>
                  </div>
                </div>
                <div className="text-right">
                  <p className="font-bold text-2xl text-gray-900">ETB {delivery.amount}</p>
                  <p className="text-sm text-gray-500">{delivery.items} items</p>
                </div>
              </div>
            </div>

            {/* Pickup & Dropoff */}
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4 mb-6">
              <div className="p-4 bg-gradient-to-r from-blue-50 to-cyan-50 rounded-xl">
                <div className="flex items-center gap-3 mb-2">
                  <div className="p-1.5 bg-blue-100 rounded-lg">
                    <MapPin className="text-blue-600" size={18} />
                  </div>
                  <p className="font-medium text-gray-900">Pickup Location</p>
                </div>
                <p className="text-gray-700">{delivery.pickup}</p>
              </div>
              
              <div className="p-4 bg-gradient-to-r from-green-50 to-emerald-50 rounded-xl">
                <div className="flex items-center gap-3 mb-2">
                  <div className="p-1.5 bg-green-100 rounded-lg">
                    <MapPin className="text-green-600" size={18} />
                  </div>
                  <p className="font-medium text-gray-900">Dropoff Location</p>
                </div>
                <p className="text-gray-700">{delivery.dropoff}</p>
              </div>
            </div>

            {/* Actions */}
            <div className="flex flex-col sm:flex-row gap-3">
              <button className="flex-1 flex items-center justify-center gap-2 bg-gradient-to-r from-green-500 to-emerald-600 text-white py-3 rounded-xl font-medium hover:shadow-lg transition-all">
                <Navigation size={18} />
                Start Navigation
              </button>
              <button className="flex-1 flex items-center justify-center gap-2 bg-gradient-to-r from-blue-500 to-indigo-600 text-white py-3 rounded-xl font-medium hover:shadow-lg transition-all">
                <Phone size={18} />
                Call Customer
              </button>
              <button className="flex-1 flex items-center justify-center gap-2 bg-white border border-orange-300 text-orange-700 py-3 rounded-xl font-medium hover:bg-orange-50 transition-all">
                <CheckCircle size={18} />
                Mark Delivered
              </button>
            </div>

            {/* Progress */}
            <div className="mt-6">
              <div className="flex items-center justify-between text-sm text-gray-500 mb-2">
                <span>Delivery Progress</span>
                <span>{delivery.status === 'assigned' ? '25%' : delivery.status === 'picked up' ? '50%' : '75%'}</span>
              </div>
              <div className="h-2 bg-gray-200 rounded-full overflow-hidden">
                <div 
                  className="h-full bg-gradient-to-r from-orange-500 to-amber-600 rounded-full"
                  style={{ width: delivery.status === 'assigned' ? '25%' : delivery.status === 'picked up' ? '50%' : '75%' }}
                />
              </div>
            </div>
          </div>
        ))}
      </div>

      {/* Empty State */}
      {deliveries.length === 0 && (
        <div className="bg-white rounded-2xl shadow-lg p-12 text-center">
          <div className="inline-flex p-6 bg-gradient-to-r from-orange-50 to-amber-50 rounded-full mb-6">
            <Package size={48} className="text-orange-600" />
          </div>
          <h3 className="text-2xl font-bold text-gray-900 mb-3">No Active Deliveries</h3>
          <p className="text-gray-500 mb-6">You're currently not assigned to any deliveries.</p>
          <button className="px-6 py-3 bg-gradient-to-r from-orange-500 to-amber-600 text-white rounded-lg font-medium shadow-lg hover:shadow-xl transition-all">
            Check for Available Deliveries
          </button>
        </div>
      )}
    </div>
  )
}

export default DriverDeliveries