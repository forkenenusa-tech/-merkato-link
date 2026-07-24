import React, { useEffect, useState } from 'react'
import { FileText, CheckCircle, XCircle, User, Car } from 'lucide-react'
import { staffApi } from '../services/api'

interface Application {
  _id: string
  userId: {
    _id: string
    name: string
    email: string
    phone: string
  }
  status: string
  submittedAt: string
  reviewedBy?: {
    name: string
    email: string
  }
  type: 'seller' | 'driver'
  businessName?: string
  licenseNumber?: string
  vehicleType?: string
  plateNumber?: string
}

const Verification = () => {
  const [applications, setApplications] = useState<Application[]>([])
  const [loading, setLoading] = useState(true)
  const [type, setType] = useState<'all' | 'seller' | 'driver'>('all')
  const [status, setStatus] = useState<'all' | 'pending' | 'approved' | 'rejected'>('all')

  useEffect(() => {
    fetchApplications()
  }, [type, status])

  const fetchApplications = async () => {
    try {
      const params: any = {}
      if (type !== 'all') params.type = type
      if (status !== 'all') params.status = status
      
      const response = await staffApi.getApplications(params)
      
      // Combine seller and driver applications
      const sellerApps = response.data.sellerApplications.map((app: any) => ({
        ...app,
        type: 'seller' as const
      }))
      
      const driverApps = response.data.driverApplications.map((app: any) => ({
        ...app,
        type: 'driver' as const
      }))
      
      setApplications([...sellerApps, ...driverApps])
    } catch (error) {
      console.error('Failed to fetch applications:', error)
    } finally {
      setLoading(false)
    }
  }

  const handleVerification = async (id: string, appType: 'seller' | 'driver', newStatus: 'approved' | 'rejected') => {
    try {
      await staffApi.verifyApplication(id, {
        status: newStatus,
        type: appType,
        notes: `Application ${newStatus} by admin`
      })
      fetchApplications() // Refresh list
    } catch (error) {
      console.error('Failed to verify application:', error)
    }
  }

  const getStatusColor = (status: string) => {
    switch (status) {
      case 'approved': return 'bg-green-100 text-green-800'
      case 'rejected': return 'bg-red-100 text-red-800'
      default: return 'bg-yellow-100 text-yellow-800'
    }
  }

  if (loading) {
    return (
      <div className="flex items-center justify-center h-64">
        <div className="text-lg text-gray-500">Loading applications...</div>
      </div>
    )
  }

  return (
    <div className="space-y-6">
      {/* Header */}
      <div>
        <h1 className="text-3xl font-bold text-gray-900">Verification Center</h1>
        <p className="text-gray-500">Review and approve seller & driver applications</p>
      </div>

      {/* Filters */}
      <div className="glass-card rounded-xl p-6">
        <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-2">
              Application Type
            </label>
            <select
              value={type}
              onChange={(e) => setType(e.target.value as any)}
              className="input-field w-full"
            >
              <option value="all">All Types</option>
              <option value="seller">Seller Applications</option>
              <option value="driver">Driver Applications</option>
            </select>
          </div>

          <div>
            <label className="block text-sm font-medium text-gray-700 mb-2">
              Status
            </label>
            <select
              value={status}
              onChange={(e) => setStatus(e.target.value as any)}
              className="input-field w-full"
            >
              <option value="all">All Status</option>
              <option value="pending">Pending</option>
              <option value="approved">Approved</option>
              <option value="rejected">Rejected</option>
            </select>
          </div>
        </div>
      </div>

      {/* Applications Grid */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        {applications.length === 0 ? (
          <div className="col-span-2 py-12 text-center">
            <FileText className="mx-auto text-gray-300" size={48} />
            <p className="mt-4 text-gray-500">No applications found</p>
          </div>
        ) : (
          applications.map((app) => (
            <div key={app._id} className="glass-card rounded-xl p-6">
              <div className="flex items-start justify-between mb-4">
                <div className="flex items-center gap-3">
                  <div className={`p-2 rounded-lg ${
                    app.type === 'seller' 
                      ? 'bg-green-100 text-green-600'
                      : 'bg-blue-100 text-blue-600'
                  }`}>
                    {app.type === 'seller' ? <User size={20} /> : <Car size={20} />}
                  </div>
                  <div>
                    <p className="font-medium">
                      {app.type === 'seller' ? 'Seller Application' : 'Driver Application'}
                    </p>
                    <p className="text-sm text-gray-500">
                      Submitted {new Date(app.submittedAt).toLocaleDateString()}
                    </p>
                  </div>
                </div>
                <span className={`px-3 py-1 rounded-full text-sm font-medium ${getStatusColor(app.status)}`}>
                  {app.status}
                </span>
              </div>

              {/* User Info */}
              <div className="mb-4 p-4 bg-gray-50 rounded-lg">
                <p className="font-medium mb-2">Applicant Information</p>
                <div className="space-y-1 text-sm">
                  <p><span className="text-gray-500">Name:</span> {app.userId.name}</p>
                  <p><span className="text-gray-500">Email:</span> {app.userId.email}</p>
                  <p><span className="text-gray-500">Phone:</span> {app.userId.phone}</p>
                </div>
              </div>

              {/* Application Details */}
              <div className="mb-6">
                <p className="font-medium mb-2">Application Details</p>
                {app.type === 'seller' ? (
                  <div className="space-y-1 text-sm">
                    <p><span className="text-gray-500">Business Name:</span> {app.businessName}</p>
                    <p><span className="text-gray-500">License:</span> {app.businessName}</p>
                  </div>
                ) : (
                  <div className="space-y-1 text-sm">
                    <p><span className="text-gray-500">License No:</span> {app.licenseNumber}</p>
                    <p><span className="text-gray-500">Vehicle Type:</span> {app.vehicleType}</p>
                    <p><span className="text-gray-500">Plate No:</span> {app.plateNumber}</p>
                  </div>
                )}
              </div>

              {/* Actions */}
              {app.status === 'pending' && (
                <div className="flex gap-3">
                  <button
                    onClick={() => handleVerification(app._id, app.type, 'approved')}
                    className="flex-1 btn-primary flex items-center justify-center gap-2"
                  >
                    <CheckCircle size={18} />
                    Approve
                  </button>
                  <button
                    onClick={() => handleVerification(app._id, app.type, 'rejected')}
                    className="flex-1 bg-red-600 hover:bg-red-700 text-white font-medium px-4 py-2 rounded-lg flex items-center justify-center gap-2"
                  >
                    <XCircle size={18} />
                    Reject
                  </button>
                </div>
              )}

              {/* Reviewer Info */}
              {app.reviewedBy && (
                <div className="mt-4 pt-4 border-t text-sm text-gray-500">
                  <p>Reviewed by: {app.reviewedBy.name}</p>
                  <p>Email: {app.reviewedBy.email}</p>
                </div>
              )}
            </div>
          ))
        )}
      </div>

      {/* Stats */}
      <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
        <div className="stat-card">
          <p className="text-sm text-gray-500">Pending Applications</p>
          <p className="text-3xl font-bold text-gray-900 mt-2">
            {applications.filter(a => a.status === 'pending').length}
          </p>
        </div>
        <div className="stat-card">
          <p className="text-sm text-gray-500">Total Applications</p>
          <p className="text-3xl font-bold text-gray-900 mt-2">
            {applications.length}
          </p>
        </div>
      </div>
    </div>
  )
}

export default Verification