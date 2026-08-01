import { useEffect, useState } from 'react'
import { FileText, CheckCircle, XCircle, User, Car } from 'lucide-react'
import { adminApi } from '../services/api'

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
  // Seller fields
  businessName?: string
  businessLicense?: string
  taxId?: string
  businessAddress?: string
  businessPhone?: string
  businessEmail?: string
  yearsInBusiness?: number
  businessLicenseImage?: string
  taxCertificateImage?: string
  businessRegistrationImage?: string
  idFrontImage?: string
  idBackImage?: string
  businessPremisesImage?: string
  // Driver fields
  licenseNumber?: string
  vehicleType?: string
  plateNumber?: string
  vehicleModel?: string
  vehicleColor?: string
  yearsOfExperience?: number
  insuranceProvider?: string
  insuranceNumber?: string
  licenseImage?: string
  vehicleImage?: string
}

const Verification = () => {
  const [applications, setApplications] = useState<Application[]>([])
  const [loading, setLoading] = useState(true)
  const [type, setType] = useState<'all' | 'seller' | 'driver'>('all')
  const [status, setStatus] = useState<'all' | 'pending' | 'approved' | 'rejected'>('all')
  const [selectedImage, setSelectedImage] = useState<string | null>(null)

  useEffect(() => {
    fetchApplications()
  }, [type, status])

  const fetchApplications = async () => {
    try {
      const params: any = {}
      if (type !== 'all') params.type = type
      if (status !== 'all') params.status = status
      
      const response = await adminApi.getApplications(params)
      
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
      await adminApi.verifyApplication(id, {
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

  const renderImagePreview = (label: string, imgData?: string) => {
    if (!imgData) return null
    return (
      <div className="flex flex-col items-center">
        <span className="text-xs text-gray-500 mb-1">{label}</span>
        <img
          src={imgData.startsWith('http') || imgData.startsWith('data:') ? imgData : `data:image/jpeg;base64,${imgData}`}
          alt={label}
          onClick={() => setSelectedImage(imgData)}
          className="w-24 h-24 object-cover rounded-lg border cursor-pointer hover:opacity-80 transition-opacity"
        />
      </div>
    )
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
        <p className="text-gray-500">Review and approve seller & driver applications with full license and document details</p>
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
            <div key={app._id} className="glass-card rounded-xl p-6 flex flex-col justify-between">
              <div>
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
                        {app.type === 'seller' ? 'Seller Verification' : 'Driver Verification'}
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
                  <p className="font-semibold text-sm mb-2 text-gray-800">Applicant Info</p>
                  <div className="grid grid-cols-2 gap-2 text-sm">
                    <p><span className="text-gray-500">Name:</span> {app.userId.name}</p>
                    <p><span className="text-gray-500">Email:</span> {app.userId.email}</p>
                    <p><span className="text-gray-500">Phone:</span> {app.userId.phone}</p>
                  </div>
                </div>

                {/* Application Details */}
                <div className="mb-4 p-4 border border-gray-100 rounded-lg bg-white">
                  <p className="font-semibold text-sm mb-2 text-gray-800">Application Details</p>
                  {app.type === 'seller' ? (
                    <div className="grid grid-cols-2 gap-2 text-sm">
                      <p><span className="text-gray-500">Business Name:</span> {app.businessName || 'N/A'}</p>
                      <p><span className="text-gray-500">Business License:</span> {app.businessLicense || 'N/A'}</p>
                      <p><span className="text-gray-500">Tax ID:</span> {app.taxId || 'N/A'}</p>
                      <p><span className="text-gray-500">Address:</span> {app.businessAddress || 'N/A'}</p>
                      <p><span className="text-gray-500">Phone:</span> {app.businessPhone || 'N/A'}</p>
                      <p><span className="text-gray-500">Years in Business:</span> {app.yearsInBusiness || 0}</p>
                    </div>
                  ) : (
                    <div className="grid grid-cols-2 gap-2 text-sm">
                      <p><span className="text-gray-500">Driver License:</span> {app.licenseNumber || 'N/A'}</p>
                      <p><span className="text-gray-500">Vehicle Type:</span> {app.vehicleType || 'N/A'}</p>
                      <p><span className="text-gray-500">Plate Number:</span> {app.plateNumber || 'N/A'}</p>
                      <p><span className="text-gray-500">Vehicle Model:</span> {app.vehicleModel || 'N/A'}</p>
                      <p><span className="text-gray-500">Color:</span> {app.vehicleColor || 'N/A'}</p>
                      <p><span className="text-gray-500">Insurance:</span> {app.insuranceProvider || 'N/A'} ({app.insuranceNumber || 'N/A'})</p>
                    </div>
                  )}
                </div>

                {/* Document Previews */}
                <div className="mb-6">
                  <p className="font-semibold text-sm mb-2 text-gray-800">Uploaded Documents</p>
                  <div className="flex flex-wrap gap-3">
                    {app.type === 'seller' ? (
                      <>
                        {renderImagePreview('License', app.businessLicenseImage)}
                        {renderImagePreview('Tax Certificate', app.taxCertificateImage)}
                        {renderImagePreview('Registration', app.businessRegistrationImage)}
                        {renderImagePreview('ID Front', app.idFrontImage)}
                        {renderImagePreview('ID Back', app.idBackImage)}
                        {renderImagePreview('Premises', app.businessPremisesImage)}
                      </>
                    ) : (
                      <>
                        {renderImagePreview('Driver License', app.licenseImage)}
                        {renderImagePreview('Vehicle', app.vehicleImage)}
                        {renderImagePreview('ID Front', app.idFrontImage)}
                        {renderImagePreview('ID Back', app.idBackImage)}
                      </>
                    )}
                    {!app.businessLicenseImage && !app.taxCertificateImage && !app.licenseImage && !app.vehicleImage && !app.idFrontImage && (
                      <span className="text-xs text-gray-400 italic">No document image files uploaded</span>
                    )}
                  </div>
                </div>
              </div>

              <div>
                {/* Actions */}
                {app.status === 'pending' && (
                  <div className="flex gap-3 mt-4">
                    <button
                      onClick={() => handleVerification(app._id, app.type, 'approved')}
                      className="flex-1 btn-primary flex items-center justify-center gap-2"
                    >
                      <CheckCircle size={18} />
                      Approve Application
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
                    <p>Reviewed by: {app.reviewedBy.name} ({app.reviewedBy.email})</p>
                  </div>
                )}
              </div>
            </div>
          ))
        )}
      </div>

      {/* Image Modal */}
      {selectedImage && (
        <div className="fixed inset-0 z-50 bg-black bg-opacity-75 flex items-center justify-center p-4" onClick={() => setSelectedImage(null)}>
          <div className="relative max-w-3xl max-h-full">
            <img
              src={selectedImage.startsWith('http') || selectedImage.startsWith('data:') ? selectedImage : `data:image/jpeg;base64,${selectedImage}`}
              alt="Enlarged Document"
              className="max-h-[85vh] max-w-full rounded-lg shadow-2xl"
            />
            <button
              onClick={() => setSelectedImage(null)}
              className="absolute top-2 right-2 bg-white text-black rounded-full p-2 font-bold shadow-lg"
            >
              ✕
            </button>
          </div>
        </div>
      )}

      {/* Stats */}
      <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
        <div className="stat-card">
          <p className="text-sm text-gray-500">Pending Verification Applications</p>
          <p className="text-3xl font-bold text-gray-900 mt-2">
            {applications.filter(a => a.status === 'pending').length}
          </p>
        </div>
        <div className="stat-card">
          <p className="text-sm text-gray-500">Total Applications Processed</p>
          <p className="text-3xl font-bold text-gray-900 mt-2">
            {applications.length}
          </p>
        </div>
      </div>
    </div>
  )
}

export default Verification