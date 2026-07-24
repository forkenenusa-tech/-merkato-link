import React, { useState } from 'react'
import { Store, Edit, Camera, Globe, Bell, TrendingUp, Users, Star, Share2 } from 'lucide-react'

const SellerStore = () => {
  const [storeData, setStoreData] = useState({
    name: 'Ethiopian Crafts & Spices',
    description: 'Authentic Ethiopian handmade crafts, traditional spices, and fresh coffee beans directly sourced from local artisans.',
    category: 'Handicrafts & Food',
    location: 'Addis Ababa, Ethiopia',
    contactEmail: 'contact@ethiopiancrafts.com',
    contactPhone: '+251 91 123 4567',
    established: '2021',
    rating: 4.8,
    totalSales: 1245,
    activeCustomers: 342,
  })

  const storeStats = [
    { label: 'Store Rating', value: '4.8/5', icon: Star, color: 'yellow', change: '+0.2' },
    { label: 'Total Sales', value: '1,245', icon: TrendingUp, color: 'green', change: '+18%' },
    { label: 'Active Customers', value: '342', icon: Users, color: 'blue', change: '+24' },
    { label: 'Store Views', value: '5,678', icon: Globe, color: 'purple', change: '+32%' },
  ]

  const storeHours = [
    { day: 'Monday', hours: '9:00 AM - 6:00 PM', open: true },
    { day: 'Tuesday', hours: '9:00 AM - 6:00 PM', open: true },
    { day: 'Wednesday', hours: '9:00 AM - 6:00 PM', open: true },
    { day: 'Thursday', hours: '9:00 AM - 6:00 PM', open: true },
    { day: 'Friday', hours: '9:00 AM - 8:00 PM', open: true },
    { day: 'Saturday', hours: '10:00 AM - 4:00 PM', open: true },
    { day: 'Sunday', hours: 'Closed', open: false },
  ]

  const socialLinks = [
    { platform: 'Facebook', url: 'facebook.com/ethiopiancrafts', followers: '1.2K' },
    { platform: 'Instagram', url: 'instagram.com/ethiopiancrafts', followers: '2.4K' },
    { platform: 'Twitter', url: 'twitter.com/ethiopiancrafts', followers: '856' },
    { platform: 'Telegram', url: 't.me/ethiopiancrafts', followers: '432' },
  ]

  return (
    <div className="space-y-8">
      {/* Header */}
      <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
        <div>
          <h1 className="text-3xl font-bold text-gray-900">Store Settings</h1>
          <p className="text-gray-500">Manage your store profile and settings</p>
        </div>
        <div className="flex items-center gap-3">
          <button className="flex items-center gap-2 px-4 py-2 bg-gradient-to-r from-green-500 to-emerald-600 text-white rounded-lg font-medium shadow-md hover:shadow-lg transition-all">
            <Share2 size={18} />
            Share Store
          </button>
          <button className="flex items-center gap-2 px-4 py-2 bg-gradient-to-r from-amber-400 to-yellow-500 text-white rounded-lg font-medium shadow-md hover:shadow-lg transition-all">
            <Edit size={18} />
            Edit Store
          </button>
        </div>
      </div>

      {/* Store Overview */}
      <div className="bg-white rounded-2xl shadow-lg p-6">
        <div className="flex flex-col lg:flex-row gap-8">
          {/* Store Logo & Info */}
          <div className="lg:w-1/3">
            <div className="relative mb-6">
              <div className="w-32 h-32 mx-auto bg-gradient-to-r from-green-500 to-emerald-600 rounded-2xl flex items-center justify-center text-white">
                <Store size={48} />
              </div>
              <button className="absolute bottom-2 right-1/2 transform translate-x-16 p-2 bg-white rounded-full shadow-lg hover:shadow-xl transition-all">
                <Camera size={18} className="text-gray-700" />
              </button>
            </div>

            <div className="text-center">
              <h2 className="text-2xl font-bold text-gray-900 mb-2">{storeData.name}</h2>
              <div className="inline-flex items-center gap-1 mb-4">
                {[...Array(5)].map((_, i) => (
                  <svg
                    key={i}
                    className={`w-5 h-5 ${
                      i < Math.floor(storeData.rating) ? 'text-yellow-400' : 'text-gray-300'
                    }`}
                    fill="currentColor"
                    viewBox="0 0 20 20"
                  >
                    <path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z" />
                  </svg>
                ))}
                <span className="ml-2 font-medium text-gray-700">{storeData.rating}/5</span>
              </div>
            </div>

            {/* Quick Stats */}
            <div className="space-y-4">
              {storeStats.map((stat, index) => (
                <div key={index} className="bg-gradient-to-r from-green-50 to-emerald-50 p-4 rounded-xl">
                  <div className="flex items-center justify-between">
                    <div>
                      <p className="text-sm text-gray-500 font-medium">{stat.label}</p>
                      <p className="text-2xl font-bold text-gray-900 mt-1">{stat.value}</p>
                      <p className={`text-sm ${stat.change.startsWith('+') ? 'text-green-600' : 'text-red-600'} mt-1`}>
                        {stat.change}
                      </p>
                    </div>
                    <div className={`p-3 ${
                      stat.color === 'yellow' ? 'bg-gradient-to-r from-yellow-100 to-amber-100 text-yellow-700' :
                      stat.color === 'green' ? 'bg-gradient-to-r from-green-100 to-emerald-100 text-green-700' :
                      stat.color === 'blue' ? 'bg-gradient-to-r from-blue-100 to-cyan-100 text-blue-700' :
                      'bg-gradient-to-r from-purple-100 to-violet-100 text-purple-700'
                    } rounded-xl`}>
                      <stat.icon size={24} />
                    </div>
                  </div>
                </div>
              ))}
            </div>
          </div>

          {/* Store Details */}
          <div className="lg:w-2/3">
            {/* Description */}
            <div className="mb-8">
              <h3 className="text-lg font-bold text-gray-900 mb-3">Store Description</h3>
              <p className="text-gray-700 bg-green-50 p-4 rounded-xl">
                {storeData.description}
              </p>
            </div>

            {/* Store Information */}
            <div className="grid grid-cols-1 md:grid-cols-2 gap-6 mb-8">
              <div>
                <h3 className="text-lg font-bold text-gray-900 mb-4">Store Information</h3>
                <div className="space-y-4">
                  <div>
                    <p className="text-sm text-gray-500">Category</p>
                    <p className="font-medium text-gray-900">{storeData.category}</p>
                  </div>
                  <div>
                    <p className="text-sm text-gray-500">Location</p>
                    <p className="font-medium text-gray-900">{storeData.location}</p>
                  </div>
                  <div>
                    <p className="text-sm text-gray-500">Established</p>
                    <p className="font-medium text-gray-900">{storeData.established}</p>
                  </div>
                </div>
              </div>

              <div>
                <h3 className="text-lg font-bold text-gray-900 mb-4">Contact Information</h3>
                <div className="space-y-4">
                  <div>
                    <p className="text-sm text-gray-500">Email</p>
                    <p className="font-medium text-gray-900">{storeData.contactEmail}</p>
                  </div>
                  <div>
                    <p className="text-sm text-gray-500">Phone</p>
                    <p className="font-medium text-gray-900">{storeData.contactPhone}</p>
                  </div>
                  <div>
                    <p className="text-sm text-gray-500">Customer Support</p>
                    <p className="font-medium text-gray-900">Available 24/7 via chat</p>
                  </div>
                </div>
              </div>
            </div>

            {/* Store Hours */}
            <div className="mb-8">
              <h3 className="text-lg font-bold text-gray-900 mb-4">Store Hours</h3>
              <div className="bg-gradient-to-r from-green-50 to-emerald-50 rounded-xl p-4">
                <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
                  {storeHours.map((day, index) => (
                    <div key={index} className="bg-white/80 backdrop-blur-sm p-3 rounded-lg">
                      <p className="font-medium text-gray-900">{day.day}</p>
                      <p className={`text-sm ${day.open ? 'text-green-600' : 'text-red-600'}`}>
                        {day.hours}
                      </p>
                    </div>
                  ))}
                </div>
              </div>
            </div>

            {/* Social Links */}
            <div>
              <h3 className="text-lg font-bold text-gray-900 mb-4">Social Media Presence</h3>
              <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
                {socialLinks.map((social, index) => (
                  <div key={index} className="bg-gradient-to-br from-blue-50 to-indigo-50 p-4 rounded-xl">
                    <div className="flex items-center justify-between mb-3">
                      <div className="font-medium text-gray-900">{social.platform}</div>
                      <div className="text-sm text-gray-500">{social.followers} followers</div>
                    </div>
                    <a
                      href={`https://${social.url}`}
                      target="_blank"
                      rel="noopener noreferrer"
                      className="text-blue-600 hover:text-blue-700 text-sm font-medium"
                    >
                      {social.url}
                    </a>
                  </div>
                ))}
              </div>
            </div>
          </div>
        </div>
      </div>

      {/* Store Settings */}
      <div className="bg-white rounded-2xl shadow-lg p-6">
        <h2 className="text-xl font-bold text-gray-900 mb-6">Store Configuration</h2>
        <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
          {/* Notification Settings */}
          <div className="p-4 border border-gray-200 rounded-xl hover:border-green-300 transition-colors">
            <div className="flex items-center gap-3 mb-4">
              <div className="p-2 bg-green-100 rounded-lg">
                <Bell size={20} className="text-green-600" />
              </div>
              <div>
                <h3 className="font-medium text-gray-900">Notification Settings</h3>
                <p className="text-sm text-gray-500">Manage store notifications</p>
              </div>
            </div>
            <div className="space-y-3">
              <div className="flex items-center justify-between">
                <span className="text-sm text-gray-700">New Order Alerts</span>
                <label className="relative inline-flex items-center cursor-pointer">
                  <input type="checkbox" className="sr-only peer" defaultChecked />
                  <div className="w-11 h-6 bg-gray-200 peer-focus:outline-none peer-focus:ring-4 peer-focus:ring-green-300 rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-green-600"></div>
                </label>
              </div>
              <div className="flex items-center justify-between">
                <span className="text-sm text-gray-700">Low Stock Alerts</span>
                <label className="relative inline-flex items-center cursor-pointer">
                  <input type="checkbox" className="sr-only peer" defaultChecked />
                  <div className="w-11 h-6 bg-gray-200 peer-focus:outline-none peer-focus:ring-4 peer-focus:ring-green-300 rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-green-600"></div>
                </label>
              </div>
              <div className="flex items-center justify-between">
                <span className="text-sm text-gray-700">Customer Reviews</span>
                <label className="relative inline-flex items-center cursor-pointer">
                  <input type="checkbox" className="sr-only peer" defaultChecked />
                  <div className="w-11 h-6 bg-gray-200 peer-focus:outline-none peer-focus:ring-4 peer-focus:ring-green-300 rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-green-600"></div>
                </label>
              </div>
            </div>
          </div>

          {/* Store Policies */}
          <div className="p-4 border border-gray-200 rounded-xl hover:border-green-300 transition-colors">
            <div className="flex items-center gap-3 mb-4">
              <div className="p-2 bg-blue-100 rounded-lg">
                <Globe size={20} className="text-blue-600" />
              </div>
              <div>
                <h3 className="font-medium text-gray-900">Store Policies</h3>
                <p className="text-sm text-gray-500">Shipping, returns, and terms</p>
              </div>
            </div>
            <div className="space-y-3">
              <button className="w-full text-left px-4 py-2 bg-gray-100 hover:bg-gray-200 text-gray-700 rounded-lg transition-colors">
                Shipping Policy
              </button>
              <button className="w-full text-left px-4 py-2 bg-gray-100 hover:bg-gray-200 text-gray-700 rounded-lg transition-colors">
                Return & Refund Policy
              </button>
              <button className="w-full text-left px-4 py-2 bg-gray-100 hover:bg-gray-200 text-gray-700 rounded-lg transition-colors">
                Terms of Service
              </button>
            </div>
          </div>

          {/* Payment Methods */}
          <div className="p-4 border border-gray-200 rounded-xl hover:border-green-300 transition-colors">
            <div className="flex items-center gap-3 mb-4">
              <div className="p-2 bg-purple-100 rounded-lg">
                <DollarSign size={20} className="text-purple-600" />
              </div>
              <div>
                <h3 className="font-medium text-gray-900">Payment Methods</h3>
                <p className="text-sm text-gray-500">Configure payment options</p>
              </div>
            </div>
            <div className="space-y-3">
              <div className="flex items-center justify-between">
                <span className="text-sm text-gray-700">Cash on Delivery</span>
                <label className="relative inline-flex items-center cursor-pointer">
                  <input type="checkbox" className="sr-only peer" defaultChecked />
                  <div className="w-11 h-6 bg-gray-200 peer-focus:outline-none peer-focus:ring-4 peer-focus:ring-green-300 rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-green-600"></div>
                </label>
              </div>
              <div className="flex items-center justify-between">
                <span className="text-sm text-gray-700">Bank Transfer</span>
                <label className="relative inline-flex items-center cursor-pointer">
                  <input type="checkbox" className="sr-only peer" defaultChecked />
                  <div className="w-11 h-6 bg-gray-200 peer-focus:outline-none peer-focus:ring-4 peer-focus:ring-green-300 rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-green-600"></div>
                </label>
              </div>
              <div className="flex items-center justify-between">
                <span className="text-sm text-gray-700">Mobile Money</span>
                <label className="relative inline-flex items-center cursor-pointer">
                  <input type="checkbox" className="sr-only peer" defaultChecked />
                  <div className="w-11 h-6 bg-gray-200 peer-focus:outline-none peer-focus:ring-4 peer-focus:ring-green-300 rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-green-600"></div>
                </label>
              </div>
            </div>
          </div>

          {/* Store Analytics */}
          <div className="p-4 border border-gray-200 rounded-xl hover:border-green-300 transition-colors">
            <div className="flex items-center gap-3 mb-4">
              <div className="p-2 bg-amber-100 rounded-lg">
                <TrendingUp size={20} className="text-amber-600" />
              </div>
              <div>
                <h3 className="font-medium text-gray-900">Store Analytics</h3>
                <p className="text-sm text-gray-500">View performance insights</p>
              </div>
            </div>
            <div className="space-y-3">
              <button className="w-full text-left px-4 py-2 bg-gray-100 hover:bg-gray-200 text-gray-700 rounded-lg transition-colors">
                Sales Reports
              </button>
              <button className="w-full text-left px-4 py-2 bg-gray-100 hover:bg-gray-200 text-gray-700 rounded-lg transition-colors">
                Customer Analytics
              </button>
              <button className="w-full text-left px-4 py-2 bg-gray-100 hover:bg-gray-200 text-gray-700 rounded-lg transition-colors">
                Inventory Reports
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
  )
}

export default SellerStore