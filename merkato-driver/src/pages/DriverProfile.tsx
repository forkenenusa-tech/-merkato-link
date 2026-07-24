import React, { useState } from 'react'
import { User, Phone, Mail, MapPin, Car, Calendar, Edit, Save, Camera, Shield } from 'lucide-react'

const DriverProfile = () => {
  const [isEditing, setIsEditing] = useState(false)
  const [profileData, setProfileData] = useState({
    name: 'John Driver',
    email: 'driver@test.com',
    phone: '+251 91 234 5678',
    address: 'Bole Area, Addis Ababa',
    vehicleType: 'Motorcycle',
    vehiclePlate: 'AA-1234-CD',
    licenseNumber: 'ET-DR-567890',
    joinDate: 'Jan 15, 2023',
    status: 'Active',
    rating: 4.7,
  })

  const handleInputChange = (field: string, value: string) => {
    setProfileData(prev => ({
      ...prev,
      [field]: value
    }))
  }

  const handleSave = () => {
    setIsEditing(false)
    // In a real app, save to API here
  }

  const stats = [
    { label: 'Total Deliveries', value: '89', change: '+12%', color: 'orange' },
    { label: 'Completion Rate', value: '94%', change: '+3%', color: 'green' },
    { label: 'Response Time', value: '4.2 min', change: '-0.8 min', color: 'blue' },
    { label: 'Customer Rating', value: '4.7/5', change: '+0.2', color: 'yellow' },
  ]

  return (
    <div className="space-y-8">
      <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
        <div>
          <h1 className="text-3xl font-bold text-gray-900">Driver Profile</h1>
          <p className="text-gray-500">Manage your profile and account settings</p>
        </div>
        <div className="flex items-center gap-3">
          {isEditing ? (
            <button
              onClick={handleSave}
              className="flex items-center gap-2 px-4 py-2 bg-gradient-to-r from-green-500 to-emerald-600 text-white rounded-lg font-medium shadow-md hover:shadow-lg transition-all"
            >
              <Save size={18} />
              Save Changes
            </button>
          ) : (
            <button
              onClick={() => setIsEditing(true)}
              className="flex items-center gap-2 px-4 py-2 bg-gradient-to-r from-orange-500 to-amber-600 text-white rounded-lg font-medium shadow-md hover:shadow-lg transition-all"
            >
              <Edit size={18} />
              Edit Profile
            </button>
          )}
        </div>
      </div>

      {/* Profile Overview */}
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
        {/* Profile Card */}
        <div className="lg:col-span-2 bg-white rounded-2xl shadow-lg p-6">
          <div className="flex flex-col md:flex-row gap-6">
            {/* Profile Picture */}
            <div className="relative">
              <div className="w-32 h-32 bg-gradient-to-r from-orange-500 to-amber-600 rounded-2xl flex items-center justify-center text-white text-4xl font-bold">
                JD
              </div>
              <button className="absolute bottom-2 right-2 p-2 bg-white rounded-full shadow-lg hover:shadow-xl transition-all">
                <Camera size={18} className="text-gray-700" />
              </button>
            </div>

            {/* Profile Info */}
            <div className="flex-1">
              <div className="flex items-start justify-between mb-4">
                <div>
                  {isEditing ? (
                    <input
                      type="text"
                      value={profileData.name}
                      onChange={(e) => handleInputChange('name', e.target.value)}
                      className="text-2xl font-bold text-gray-900 border-b border-gray-300 focus:outline-none focus:border-orange-500"
                    />
                  ) : (
                    <h2 className="text-2xl font-bold text-gray-900">{profileData.name}</h2>
                  )}
                  <div className="flex items-center gap-2 mt-2">
                    <span className="px-3 py-1 bg-green-100 text-green-800 rounded-full text-sm font-medium">
                      {profileData.status}
                    </span>
                    <div className="flex items-center gap-1">
                      {[...Array(5)].map((_, i) => (
                        <svg
                          key={i}
                          className={`w-4 h-4 ${
                            i < Math.floor(profileData.rating) ? 'text-yellow-400' : 'text-gray-300'
                          }`}
                          fill="currentColor"
                          viewBox="0 0 20 20"
                        >
                          <path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z" />
                        </svg>
                      ))}
                      <span className="text-sm text-gray-500 ml-1">{profileData.rating}/5</span>
                    </div>
                  </div>
                </div>
                
                <div className="flex items-center gap-2 text-gray-500">
                  <Calendar size={18} />
                  <span className="text-sm">Joined {profileData.joinDate}</span>
                </div>
              </div>

              {/* Profile Details */}
              <div className="space-y-4">
                <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                  <div className="flex items-center gap-3">
                    <div className="p-2 bg-orange-100 rounded-lg">
                      <Mail size={18} className="text-orange-600" />
                    </div>
                    <div className="flex-1">
                      <p className="text-sm text-gray-500">Email</p>
                      {isEditing ? (
                        <input
                          type="email"
                          value={profileData.email}
                          onChange={(e) => handleInputChange('email', e.target.value)}
                          className="w-full font-medium text-gray-900 border-b border-gray-300 focus:outline-none focus:border-orange-500"
                        />
                      ) : (
                        <p className="font-medium text-gray-900">{profileData.email}</p>
                      )}
                    </div>
                  </div>

                  <div className="flex items-center gap-3">
                    <div className="p-2 bg-green-100 rounded-lg">
                      <Phone size={18} className="text-green-600" />
                    </div>
                    <div className="flex-1">
                      <p className="text-sm text-gray-500">Phone</p>
                      {isEditing ? (
                        <input
                          type="tel"
                          value={profileData.phone}
                          onChange={(e) => handleInputChange('phone', e.target.value)}
                          className="w-full font-medium text-gray-900 border-b border-gray-300 focus:outline-none focus:border-orange-500"
                        />
                      ) : (
                        <p className="font-medium text-gray-900">{profileData.phone}</p>
                      )}
                    </div>
                  </div>
                </div>

                <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                  <div className="flex items-center gap-3">
                    <div className="p-2 bg-blue-100 rounded-lg">
                      <MapPin size={18} className="text-blue-600" />
                    </div>
                    <div className="flex-1">
                      <p className="text-sm text-gray-500">Address</p>
                      {isEditing ? (
                        <input
                          type="text"
                          value={profileData.address}
                          onChange={(e) => handleInputChange('address', e.target.value)}
                          className="w-full font-medium text-gray-900 border-b border-gray-300 focus:outline-none focus:border-orange-500"
                        />
                      ) : (
                        <p className="font-medium text-gray-900">{profileData.address}</p>
                      )}
                    </div>
                  </div>

                  <div className="flex items-center gap-3">
                    <div className="p-2 bg-purple-100 rounded-lg">
                      <Car size={18} className="text-purple-600" />
                    </div>
                    <div className="flex-1">
                      <p className="text-sm text-gray-500">Vehicle</p>
                      <p className="font-medium text-gray-900">
                        {profileData.vehicleType} • {profileData.vehiclePlate}
                      </p>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>

          {/* License Info */}
          <div className="mt-8 p-4 bg-gradient-to-r from-blue-50 to-cyan-50 rounded-xl">
            <div className="flex items-center gap-3 mb-3">
              <Shield size={20} className="text-blue-600" />
              <p className="font-medium text-gray-900">Driver License Information</p>
            </div>
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div>
                <p className="text-sm text-gray-500">License Number</p>
                <p className="font-medium text-gray-900">{profileData.licenseNumber}</p>
              </div>
              <div>
                <p className="text-sm text-gray-500">Status</p>
                <span className="px-3 py-1 bg-green-100 text-green-800 rounded-full text-sm font-medium">
                  Verified
                </span>
              </div>
            </div>
          </div>
        </div>

        {/* Stats Sidebar */}
        <div className="space-y-6">
          {stats.map((stat, index) => (
            <div key={index} className="bg-white p-6 rounded-2xl shadow-sm border border-gray-100">
              <div className="flex items-center justify-between">
                <div>
                  <p className="text-sm text-gray-500 font-medium">{stat.label}</p>
                  <p className="text-3xl font-bold text-gray-900 mt-2">{stat.value}</p>
                  <p className={`text-sm ${stat.change.startsWith('+') ? 'text-green-600' : 'text-red-600'} mt-1`}>
                    {stat.change}
                  </p>
                </div>
                <div className={`p-3 ${
                  stat.color === 'orange' ? 'bg-gradient-to-r from-orange-100 to-amber-100 text-orange-700' :
                  stat.color === 'green' ? 'bg-gradient-to-r from-green-100 to-emerald-100 text-green-700' :
                  stat.color === 'blue' ? 'bg-gradient-to-r from-blue-100 to-cyan-100 text-blue-700' :
                  'bg-gradient-to-r from-yellow-100 to-amber-100 text-yellow-700'
                } rounded-xl`}>
                  <User size={24} />
                </div>
              </div>
            </div>
          ))}
        </div>
      </div>

      {/* Account Settings */}
      <div className="bg-white rounded-2xl shadow-lg p-6">
        <h2 className="text-xl font-bold text-gray-900 mb-6">Account Settings</h2>
        <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
          <div className="p-4 border border-gray-200 rounded-xl hover:border-orange-300 transition-colors">
            <h3 className="font-medium text-gray-900 mb-2">Change Password</h3>
            <p className="text-sm text-gray-500 mb-4">Update your account password</p>
            <button className="px-4 py-2 bg-gray-100 text-gray-700 rounded-lg hover:bg-gray-200 transition-colors">
              Change Password
            </button>
          </div>

          <div className="p-4 border border-gray-200 rounded-xl hover:border-orange-300 transition-colors">
            <h3 className="font-medium text-gray-900 mb-2">Notification Settings</h3>
            <p className="text-sm text-gray-500 mb-4">Manage your notification preferences</p>
            <button className="px-4 py-2 bg-gray-100 text-gray-700 rounded-lg hover:bg-gray-200 transition-colors">
              Configure
            </button>
          </div>

          <div className="p-4 border border-gray-200 rounded-xl hover:border-orange-300 transition-colors">
            <h3 className="font-medium text-gray-900 mb-2">Privacy Settings</h3>
            <p className="text-sm text-gray-500 mb-4">Control your privacy preferences</p>
            <button className="px-4 py-2 bg-gray-100 text-gray-700 rounded-lg hover:bg-gray-200 transition-colors">
              Manage Privacy
            </button>
          </div>

          <div className="p-4 border border-gray-200 rounded-xl hover:border-orange-300 transition-colors">
            <h3 className="font-medium text-gray-900 mb-2">Deactivate Account</h3>
            <p className="text-sm text-gray-500 mb-4">Temporarily deactivate your account</p>
            <button className="px-4 py-2 bg-red-100 text-red-700 rounded-lg hover:bg-red-200 transition-colors">
              Deactivate
            </button>
          </div>
        </div>
      </div>
    </div>
  )
}

export default DriverProfile