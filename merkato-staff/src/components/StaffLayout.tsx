import React, { useState } from 'react'
import { Outlet, NavLink, useNavigate } from 'react-router-dom'
import { 
  Home, 
  CheckCircle, 
  Package, 
  User, 
  LogOut,
  Menu,
  X,
  Shield,
  Bell,
  Users
} from 'lucide-react'

const StaffLayout = () => {
  const [sidebarOpen, setSidebarOpen] = useState(false)
  const navigate = useNavigate()

  const navItems = [
    { path: '/', label: 'Dashboard', icon: Home },
    { path: '/verification', label: 'Verification', icon: CheckCircle },
    { path: '/orders', label: 'Order Monitoring', icon: Package },
  ]

  const handleLogout = () => {
    // Implement logout logic
    navigate('/login')
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 to-indigo-50">
      {/* Mobile sidebar toggle */}
      <div className="lg:hidden fixed top-4 left-4 z-50">
        <button
          onClick={() => setSidebarOpen(!sidebarOpen)}
          className="p-2 bg-gradient-to-r from-blue-500 to-indigo-600 text-white rounded-lg shadow-lg"
        >
          {sidebarOpen ? <X size={24} /> : <Menu size={24} />}
        </button>
      </div>

      {/* Sidebar */}
      <aside className={`
        fixed left-0 top-0 h-screen w-64 bg-white shadow-xl transform transition-transform duration-300 z-40
        ${sidebarOpen ? 'translate-x-0' : '-translate-x-full lg:translate-x-0'}
      `}>
        <div className="p-6">
          <div className="flex items-center space-x-3 mb-8">
            <div className="p-2 bg-gradient-to-r from-blue-500 to-indigo-600 rounded-xl">
              <Shield className="text-white" size={24} />
            </div>
            <div>
              <h1 className="text-xl font-bold text-gray-900">Merkato Staff</h1>
              <p className="text-sm text-gray-500">Support & Verification</p>
            </div>
          </div>

          <nav className="space-y-2">
            {navItems.map((item) => (
              <NavLink
                key={item.path}
                to={item.path}
                end={item.path === '/'}
                className={({ isActive }) => `
                  sidebar-item ${isActive ? 'sidebar-item-active' : ''}
                `}
                onClick={() => setSidebarOpen(false)}
              >
                <item.icon size={20} />
                <span>{item.label}</span>
              </NavLink>
            ))}
          </nav>

          <div className="mt-auto pt-8 border-t border-gray-200">
            <div className="flex items-center space-x-3 mb-4">
              <div className="relative">
                <div className="w-10 h-10 bg-gradient-to-r from-blue-500 to-indigo-600 rounded-full flex items-center justify-center text-white font-bold">
                  SM
                </div>
                <div className="absolute -top-1 -right-1 w-4 h-4 bg-green-500 border-2 border-white rounded-full"></div>
              </div>
              <div>
                <p className="font-medium text-gray-900">Sarah Manager</p>
                <p className="text-sm text-gray-500">Staff Admin</p>
              </div>
            </div>

            <button
              onClick={handleLogout}
              className="flex items-center space-x-3 px-4 py-3 rounded-xl hover:bg-red-50 text-gray-700 hover:text-red-700 transition-all w-full"
            >
              <LogOut size={20} />
              <span>Logout</span>
            </button>
          </div>
        </div>
      </aside>

      {/* Main content */}
      <main className="lg:ml-64 min-h-screen">
        {/* Header */}
        <header className="bg-white/80 backdrop-blur-lg border-b border-gray-200 sticky top-0 z-30">
          <div className="px-6 py-4 flex items-center justify-between">
            <div>
              <h1 className="text-2xl font-bold text-gray-900">Support Dashboard</h1>
              <p className="text-gray-500">Manage verifications and monitor orders</p>
            </div>
            
            <div className="flex items-center space-x-4">
              <button className="relative p-2 hover:bg-gray-100 rounded-lg">
                <Bell size={22} className="text-gray-600" />
                <span className="absolute -top-1 -right-1 w-2 h-2 bg-red-500 rounded-full"></span>
              </button>
              
              <div className="flex items-center space-x-3">
                <Users size={20} className="text-gray-500" />
                <div className="text-sm">
                  <p className="font-medium">Online Staff: 4</p>
                  <p className="text-gray-500">Support available</p>
                </div>
              </div>
            </div>
          </div>
        </header>

        {/* Page content */}
        <div className="p-6">
          <Outlet />
        </div>
      </main>

      {/* Mobile overlay */}
      {sidebarOpen && (
        <div
          className="fixed inset-0 bg-black/50 z-30 lg:hidden"
          onClick={() => setSidebarOpen(false)}
        />
      )}
    </div>
  )
}

export default StaffLayout