import { useEffect, useState } from 'react'
import { Search, User, Mail, Phone, Shield, CheckCircle, XCircle, MoreVertical } from 'lucide-react'
import { adminApi } from '../services/api'

interface UserType {
  _id: string
  name: string
  email: string
  phone: string
  role: string
  isVerified: boolean
  isActive: boolean
  createdAt: string
}

const Users = () => {
  const [users, setUsers] = useState<UserType[]>([])
  const [loading, setLoading] = useState(true)
  const [search, setSearch] = useState('')
  const [role, setRole] = useState('all')
  const [status, setStatus] = useState('all')

  useEffect(() => {
    fetchUsers()
  }, [search, role, status])

  const fetchUsers = async () => {
    try {
      const params: any = {}
      if (search) params.search = search
      if (role !== 'all') params.role = role
      if (status !== 'all') params.isActive = status === 'active'
      
      const response = await adminApi.getUsers(params)
      setUsers(response.data.users)
    } catch (error) {
      console.error('Failed to fetch users:', error)
    } finally {
      setLoading(false)
    }
  }

  const handleStatusToggle = async (userId: string, currentStatus: boolean) => {
    try {
      await adminApi.updateUser(userId, { isActive: !currentStatus })
      fetchUsers() // Refresh list
    } catch (error) {
      console.error('Failed to update user:', error)
    }
  }

  const getRoleColor = (role: string) => {
    switch (role) {
      case 'admin': return 'bg-purple-100 text-purple-800'
      case 'seller': return 'bg-green-100 text-green-800'
      case 'driver': return 'bg-blue-100 text-blue-800'
      case 'staff': return 'bg-yellow-100 text-yellow-800'
      default: return 'bg-gray-100 text-gray-800'
    }
  }

  const roles = ['all', 'admin', 'seller', 'driver', 'staff', 'customer']
  const statuses = ['all', 'active', 'inactive']

  if (loading) {
    return (
      <div className="flex items-center justify-center h-64">
        <div className="text-lg text-gray-500">Loading users...</div>
      </div>
    )
  }

  return (
    <div className="space-y-6">
      {/* Header */}
      <div>
        <h1 className="text-3xl font-bold text-gray-900">Users</h1>
        <p className="text-gray-500">Manage all user accounts</p>
      </div>

      {/* Filters */}
      <div className="glass-card rounded-xl p-6">
        <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
          <div className="relative">
            <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400" size={20} />
            <input
              type="text"
              placeholder="Search by name or email..."
              value={search}
              onChange={(e) => setSearch(e.target.value)}
              className="input-field pl-10 w-full"
            />
          </div>
          
          <select
            value={role}
            onChange={(e) => setRole(e.target.value)}
            className="input-field"
          >
            {roles.map((r) => (
              <option key={r} value={r}>
                {r === 'all' ? 'All Roles' : r.charAt(0).toUpperCase() + r.slice(1)}
              </option>
            ))}
          </select>

          <select
            value={status}
            onChange={(e) => setStatus(e.target.value)}
            className="input-field"
          >
            {statuses.map((s) => (
              <option key={s} value={s}>
                {s === 'all' ? 'All Status' : s.charAt(0).toUpperCase() + s.slice(1)}
              </option>
            ))}
          </select>
        </div>
      </div>

      {/* Users Table */}
      <div className="glass-card rounded-xl overflow-hidden">
        <div className="overflow-x-auto">
          <table className="w-full">
            <thead>
              <tr className="bg-gray-50">
                <th className="text-left py-4 px-6 font-medium text-gray-600">User</th>
                <th className="text-left py-4 px-6 font-medium text-gray-600">Contact</th>
                <th className="text-left py-4 px-6 font-medium text-gray-600">Role</th>
                <th className="text-left py-4 px-6 font-medium text-gray-600">Status</th>
                <th className="text-left py-4 px-6 font-medium text-gray-600">Joined</th>
                <th className="text-left py-4 px-6 font-medium text-gray-600">Actions</th>
              </tr>
            </thead>
            <tbody>
              {users.length === 0 ? (
                <tr>
                  <td colSpan={6} className="py-8 px-6 text-center text-gray-500">
                    No users found
                  </td>
                </tr>
              ) : (
                users.map((user) => (
                  <tr key={user._id} className="border-b hover:bg-gray-50">
                    <td className="py-4 px-6">
                      <div className="flex items-center gap-3">
                        <div className="w-10 h-10 bg-primary/10 rounded-full flex items-center justify-center">
                          <User className="text-primary" size={20} />
                        </div>
                        <div>
                          <p className="font-medium">{user.name}</p>
                          <div className="flex items-center gap-2 mt-1">
                            {user.isVerified ? (
                              <span className="flex items-center gap-1 text-sm text-green-600">
                                <CheckCircle size={14} />
                                Verified
                              </span>
                            ) : (
                              <span className="flex items-center gap-1 text-sm text-yellow-600">
                                <XCircle size={14} />
                                Unverified
                              </span>
                            )}
                          </div>
                        </div>
                      </div>
                    </td>
                    <td className="py-4 px-6">
                      <div className="space-y-1">
                        <div className="flex items-center gap-2">
                          <Mail size={16} className="text-gray-400" />
                          <span className="text-sm">{user.email}</span>
                        </div>
                        <div className="flex items-center gap-2">
                          <Phone size={16} className="text-gray-400" />
                          <span className="text-sm">{user.phone}</span>
                        </div>
                      </div>
                    </td>
                    <td className="py-4 px-6">
                      <div className="flex items-center gap-2">
                        <Shield size={16} className="text-gray-400" />
                        <span className={`px-3 py-1 rounded-full text-sm font-medium ${getRoleColor(user.role)}`}>
                          {user.role}
                        </span>
                      </div>
                    </td>
                    <td className="py-4 px-6">
                      <button
                        onClick={() => handleStatusToggle(user._id, user.isActive)}
                        className={`px-4 py-1 rounded-full text-sm font-medium transition-colors ${
                          user.isActive
                            ? 'bg-green-100 text-green-800 hover:bg-green-200'
                            : 'bg-red-100 text-red-800 hover:bg-red-200'
                        }`}
                      >
                        {user.isActive ? 'Active' : 'Suspended'}
                      </button>
                    </td>
                    <td className="py-4 px-6">
                      <div className="text-sm text-gray-500">
                        {new Date(user.createdAt).toLocaleDateString()}
                      </div>
                    </td>
                    <td className="py-4 px-6">
                      <button className="p-2 text-gray-600 hover:bg-gray-100 rounded-lg">
                        <MoreVertical size={18} />
                      </button>
                    </td>
                  </tr>
                ))
              )}
            </tbody>
          </table>
        </div>
      </div>

      {/* Stats */}
      <div className="grid grid-cols-1 md:grid-cols-4 gap-6">
        <div className="stat-card">
          <p className="text-sm text-gray-500">Total Users</p>
          <p className="text-3xl font-bold text-gray-900 mt-2">{users.length}</p>
        </div>
        <div className="stat-card">
          <p className="text-sm text-gray-500">Active Users</p>
          <p className="text-3xl font-bold text-gray-900 mt-2">
            {users.filter(u => u.isActive).length}
          </p>
        </div>
        <div className="stat-card">
          <p className="text-sm text-gray-500">Verified</p>
          <p className="text-3xl font-bold text-gray-900 mt-2">
            {users.filter(u => u.isVerified).length}
          </p>
        </div>
        <div className="stat-card">
          <p className="text-sm text-gray-500">Admins</p>
          <p className="text-3xl font-bold text-gray-900 mt-2">
            {users.filter(u => u.role === 'admin').length}
          </p>
        </div>
      </div>
    </div>
  )
}

export default Users