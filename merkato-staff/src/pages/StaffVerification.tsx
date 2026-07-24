import React, { useState } from 'react'
import { CheckCircle, XCircle, Search, Filter, User, Store, Car, Clock, Mail, Phone, FileText } from 'lucide-react'

const StaffVerification = () => {
  const [searchTerm, setSearchTerm] = useState('')
  const [filter, setFilter] = useState('pending')
  const [selectedType, setSelectedType] = useState('all')

  const sellerApplications = [
    {
      id: '#SELL-001',
      name: 'Abebe Kebede',
      email: 'abebe@example.com',
      phone: '+251 91 234 5678',
      businessName: 'Ethiopian Crafts Store',
      businessType: 'Handicrafts',
      submittedAt: 'Today, 10:30 AM',
      documents: ['ID Card', 'Business License', 'Tax Certificate'],
      status: 'pending',
      notes: 'New seller application',
    },
    {
      id: '#SELL-002',
      name: 'Marta Samuel',
      email: 'marta@example.com',
      phone: '+251 92 345 6789',
      businessName: 'Fresh Spices Co.',
      businessType: 'Food & Beverage',
      submittedAt: 'Yesterday, 3:45 PM',
      documents: ['ID Card', 'Business License'],
      status: 'pending',
      notes: 'Waiting for tax certificate',
    },
    {
      id: '#SELL-003',
      name: 'Yohannes Tekle',
      email: 'yohannes@example.com',
      phone: '+251 93 456 7890',
      businessName: 'Coffee Beans Export',
      businessType: 'Agriculture',
      submittedAt: 'Dec 10, 2023',
      documents: ['ID Card', 'Business License', 'Export License'],
      status: 'approved',
      notes: 'Verified export business',
    },
  ]

  const driverApplications = [
    {
      id: '#DRIV-001',
      name: 'Solomon Tadesse',
      email: 'solomon@example.com',
      phone: '+251 94 567 8901',
      vehicleType: 'Motorcycle',
      vehiclePlate: 'AA-1234-CD',
      licenseNumber: 'ET-DR-567890',
      submittedAt: 'Today, 9:15 AM',
      documents: ['Driver License', 'Vehicle Registration', 'Insurance'],
      status: 'pending',
      notes: 'New driver applicant',
    },
    {
      id: '#DRIV-002',
      name: 'Hirut Abebe',
      email: 'hirut@example.com',
      phone: '+251 95 678 9012',
      vehicleType: 'Car',
      vehiclePlate: 'AA-5678-EF',
      licenseNumber: 'ET-DR-567891',
      submittedAt: 'Yesterday, 2:30 PM',
      documents: ['Driver License', 'Vehicle Registration'],
      status: 'pending',
      notes: 'Waiting for insurance document',
    },
    {
      id: '#DRIV-003',
      name: 'Kaleb Solomon',
      email: 'kaleb@example.com',
      phone: '+251 96 789 0123',
      vehicleType: 'Motorcycle',
      vehiclePlate: 'AA-9012-GH',
      licenseNumber: 'ET-DR-567892',
      submittedAt: 'Dec 9, 2023',
      documents: ['Driver License', 'Vehicle Registration', 'Insurance'],
      status: 'rejected',
      notes: 'License expired',
    },
  ]

  const allApplications = [...sellerApplications, ...driverApplications]

  const filteredApplications = allApplications.filter(app => {
    const matchesSearch = app.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
                         app.email.toLowerCase().includes(searchTerm.toLowerCase()) ||
                         app.id.toLowerCase().includes(searchTerm.toLowerCase())
    const matchesStatus = filter === 'all' || app.status === filter
    const matchesType = selectedType === 'all' || 
                       (selectedType === 'seller' && sellerApplications.includes(app)) ||
                       (selectedType === 'driver' && driverApplications.includes(app))
    return matchesSearch && matchesStatus && matchesType
  })

  const stats = {
    pendingSellers: sellerApplications.filter(a => a.status === 'pending').length,
    pendingDrivers: driverApplications.filter(a => a.status === 'pending').length,
    totalPending: sellerApplications.filter(a => a.status === 'pending').length + 
                  driverApplications.filter(a => a.status === 'pending').length,
    approvedToday: 3,
  }

  const handleVerify = (id: string, status: 'approved' | 'rejected', type: 'seller' | 'driver') => {
    // In a real app, this would call the API
    alert(`Application ${id} ${status} (${type})`)
  }

  const getStatusColor = (status: string) => {
    switch (status) {
      case 'pending': return 'bg-amber-100 text-amber-800'
      case 'approved': return 'bg-green-100 text-green-800'
      case 'rejected': return 'bg-red-100 text-red-800'
      default: return 'bg-gray-100 text-gray-800'
    }
  }

  return (
    <div className="space-y-8">
      {/* Header */}
      <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
        <div>
          <h1 className="text-3xl font-bold text-gray-900">Application Verification</h1>
          <p className="text-gray-500">Review and verify seller & driver applications</p>
        </div>
        <div className="flex items-center gap-3">
          <div className="px-4 py-2 bg-gradient-to-r from-blue-500 to-indigo-600 text-white rounded-lg font-semibold">
            {stats.totalPending} Pending Applications
          </div>
        </div>
      </div>

      {/* Stats */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
        <div className="bg-white p-6 rounded-2xl shadow-sm border border-gray-100">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm text-gray-500 font-medium">Pending Sellers</p>
              <p className="text-3xl font-bold text-gray-900 mt-2">{stats.pendingSellers}</p>
              <p className="text-sm text-amber-600 mt-1">Awaiting review</p>
            </div>
            <div className="p-3 bg-gradient-to-r from-amber-100 to-yellow-100 text-amber-700 rounded-xl">
              <Store size={24} />
            </div>
          </div>
        </div>

        <div className="bg-white p-6 rounded-2xl shadow-sm border border-gray-100">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm text-gray-500 font-medium">Pending Drivers</p>
              <p className="text-3xl font-bold text-gray-900 mt-2">{stats.pendingDrivers}</p>
              <p className="text-sm text-amber-600 mt-1">Awaiting review</p>
            </div>
            <div className="p-3 bg-gradient-to-r from-blue-100 to-cyan-100 text-blue-700 rounded-xl">
              <Car size={24} />
            </div>
          </div>
        </div>

        <div className="bg-white p-6 rounded-2xl shadow-sm border border-gray-100">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm text-gray-500 font-medium">Total Pending</p>
              <p className="text-3xl font-bold text-gray-900 mt-2">{stats.totalPending}</p>
              <p className="text-sm text-amber-600 mt-1">Requires attention</p>
            </div>
            <div className="p-3 bg-gradient-to-r from-purple-100 to-violet-100 text-purple-700 rounded-xl">
              <Clock size={24} />
            </div>
          </div>
        </div>

        <div className="bg-white p-6 rounded-2xl shadow-sm border border-gray-100">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-sm text-gray-500 font-medium">Approved Today</p>
              <p className="text-3xl font-bold text-gray-900 mt-2">{stats.approvedToday}</p>
              <p className="text-sm text-green-600 mt-1">Completed reviews</p>
            </div>
            <div className="p-3 bg-gradient-to-r from-green-100 to-emerald-100 text-green-700 rounded-xl">
              <CheckCircle size={24} />
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
              placeholder="Search applications by name, email, or ID..."
              className="w-full pl-12 pr-4 py-3 border border-gray-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500/50 focus:border-blue-500"
            />
          </div>
          
          <div className="flex items-center gap-3">
            <div className="flex items-center gap-2 text-gray-500">
              <Filter size={18} />
              <span>Filters:</span>
            </div>
            
            <select
              value={filter}
              onChange={(e) => setFilter(e.target.value)}
              className="border border-gray-300 rounded-lg px-4 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500/50 focus:border-blue-500"
            >
              <option value="all">All Status</option>
              <option value="pending">Pending</option>
              <option value="approved">Approved</option>
              <option value="rejected">Rejected</option>
            </select>

            <select
              value={selectedType}
              onChange={(e) => setSelectedType(e.target.value)}
              className="border border-gray-300 rounded-lg px-4 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500/50 focus:border-blue-500"
            >
              <option value="all">All Types</option>
              <option value="seller">Seller</option>
              <option value="driver">Driver</option>
            </select>
          </div>
        </div>

        {/* Applications */}
        <div className="space-y-6">
          {filteredApplications.map((application) => (
            <div key={application.id} className="bg-gradient-to-r from-blue-50 to-indigo-50 p-6 rounded-xl border border-blue-100">
              <div className="flex flex-col lg:flex-row lg:items-center justify-between gap-6">
                {/* Application Info */}
                <div className="flex-1">
                  <div className="flex items-start justify-between mb-4">
                    <div className="flex items-center gap-3">
                      <div className="p-2 bg-gradient-to-r from-blue-500 to-indigo-600 rounded-lg">
                        {sellerApplications.includes(application) ? (
                          <Store size={20} className="text-white" />
                        ) : (
                          <Car size={20} className="text-white" />
                        )}
                      </div>
                      <div>
                        <h3 className="font-bold text-xl text-gray-900">{application.name}</h3>
                        <p className="text-gray-500">{application.id} • {sellerApplications.includes(application) ? 'Seller' : 'Driver'}</p>
                      </div>
                    </div>
                    <span className={`px-3 py-1 rounded-full text-sm font-medium ${getStatusColor(application.status)}`}>
                      {application.status}
                    </span>
                  </div>

                  <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4 mb-4">
                    <div className="flex items-center gap-2">
                      <Mail size={16} className="text-gray-400" />
                      <span className="text-sm text-gray-700">{application.email}</span>
                    </div>
                    <div className="flex items-center gap-2">
                      <Phone size={16} className="text-gray-400" />
                      <span className="text-sm text-gray-700">{application.phone}</span>
                    </div>
                    <div className="flex items-center gap-2">
                      <Clock size={16} className="text-gray-400" />
                      <span className="text-sm text-gray-700">{application.submittedAt}</span>
                    </div>
                    {sellerApplications.includes(application) ? (
                      <div className="flex items-center gap-2">
                        <Store size={16} className="text-gray-400" />
                        <span className="text-sm text-gray-700">{application.businessName}</span>
                      </div>
                    ) : (
                      <div className="flex items-center gap-2">
                        <Car size={16} className="text-gray-400" />
                        <span className="text-sm text-gray-700">{application.vehicleType} • {application.vehiclePlate}</span>
                      </div>
                    )}
                  </div>

                  {/* Documents */}
                  <div className="mb-4">
                    <div className="flex items-center gap-2 mb-2">
                      <FileText size={16} className="text-gray-400" />
                      <p className="text-sm font-medium text-gray-700">Submitted Documents:</p>
                    </div>
                    <div className="flex flex-wrap gap-2">
                      {application.documents.map((doc, index) => (
                        <span key={index} className="px-3 py-1 bg-white border border-blue-200 text-blue-700 rounded-full text-sm">
                          {doc}
                        </span>
                      ))}
                    </div>
                  </div>

                  {/* Notes */}
                  {application.notes && (
                    <div className="p-3 bg-white/80 rounded-lg">
                      <p className="text-sm text-gray-700">{application.notes}</p>
                    </div>
                  )}
                </div>

                {/* Actions */}
                {application.status === 'pending' && (
                  <div className="flex flex-col sm:flex-row lg:flex-col gap-3">
                    <button
                      onClick={() => handleVerify(application.id, 'approved', sellerApplications.includes(application) ? 'seller' : 'driver')}
                      className="flex items-center justify-center gap-2 px-6 py-3 bg-gradient-to-r from-green-500 to-emerald-600 text-white rounded-xl font-medium hover:shadow-lg transition-all"
                    >
                      <CheckCircle size={18} />
                      Approve
                    </button>
                    <button
                      onClick={() => handleVerify(application.id, 'rejected', sellerApplications.includes(application) ? 'seller' : 'driver')}
                      className="flex items-center justify-center gap-2 px-6 py-3 bg-gradient-to-r from-red-500 to-rose-600 text-white rounded-xl font-medium hover:shadow-lg transition-all"
                    >
                      <XCircle size={18} />
                      Reject
                    </button>
                  </div>
                )}
              </div>
            </div>
          ))}

          {/* Empty State */}
          {filteredApplications.length === 0 && (
            <div className="text-center py-12">
              <div className="inline-flex p-6 bg-gradient-to-r from-blue-50 to-indigo-50 rounded-full mb-6">
                <CheckCircle size={48} className="text-blue-600" />
              </div>
              <h3 className="text-2xl font-bold text-gray-900 mb-3">No applications found</h3>
              <p className="text-gray-500 mb-6">All applications have been reviewed or no matches found.</p>
              <button
                onClick={() => {
                  setSearchTerm('')
                  setFilter('all')
                  setSelectedType('all')
                }}
                className="px-6 py-3 bg-gradient-to-r from-blue-500 to-indigo-600 text-white rounded-lg font-medium shadow-lg hover:shadow-xl transition-all"
              >
                Clear filters
              </button>
            </div>
          )}
        </div>
      </div>

      {/* Verification Guidelines */}
      <div className="bg-white rounded-2xl shadow-lg p-6">
        <h2 className="text-xl font-bold text-gray-900 mb-6">Verification Guidelines</h2>
        <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
          <div className="p-4 border border-blue-200 rounded-xl">
            <h3 className="font-medium text-gray-900 mb-3 flex items-center gap-2">
              <Store size={18} className="text-blue-600" />
              Seller Verification Checklist
            </h3>
            <ul className="space-y-2 text-sm text-gray-700">
              <li className="flex items-start gap-2">
                <CheckCircle size={16} className="text-green-500 mt-0.5" />
                Valid government-issued ID card
              </li>
              <li className="flex items-start gap-2">
                <CheckCircle size={16} className="text-green-500 mt-0.5" />
                Business license or registration
              </li>
              <li className="flex items-start gap-2">
                <CheckCircle size={16} className="text-green-500 mt-0.5" />
                Tax registration certificate
              </li>
              <li className="flex items-start gap-2">
                <CheckCircle size={16} className="text-green-500 mt-0.5" />
                Product quality certifications (if applicable)
              </li>
            </ul>
          </div>

          <div className="p-4 border border-blue-200 rounded-xl">
            <h3 className="font-medium text-gray-900 mb-3 flex items-center gap-2">
              <Car size={18} className="text-blue-600" />
              Driver Verification Checklist
            </h3>
            <ul className="space-y-2 text-sm text-gray-700">
              <li className="flex items-start gap-2">
                <CheckCircle size={16} className="text-green-500 mt-0.5" />
                Valid driver's license (Category A for motorcycles)
              </li>
              <li className="flex items-start gap-2">
                <CheckCircle size={16} className="text-green-500 mt-0.5" />
                Vehicle registration document
              </li>
              <li className="flex items-start gap-2">
                <CheckCircle size={16} className="text-green-500 mt-0.5" />
                Comprehensive insurance coverage
              </li>
              <li className="flex items-start gap-2">
                <CheckCircle size={16} className="text-green-500 mt-0.5" />
                Clean criminal record certificate
              </li>
            </ul>
          </div>
        </div>
      </div>
    </div>
  )
}

export default StaffVerification