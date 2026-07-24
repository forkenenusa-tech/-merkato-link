import React, { useState } from 'react'
import { Outlet, NavLink, useNavigate } from 'react-router-dom'
import { 
  Package, 
  Clock, 
  History, 
  User, 
  LogOut,
  Menu,
  X,
  Car,
  Bell,
  MapPin
} from 'lucide-react'

const DriverLayout = () => {
  const [sidebarOpen, setSidebarOpen] = useState(false)
  const navigate = useNavigate()

  const navItems = [
    { path: '/', label: 'Dashboard', icon: Package },
    { path: '/deliveries', label: 'Active Deliveries', icon: Car },
    { path: '/history', label: 'Delivery History', icon: History },
    { path: '/profile', label: 'Profile', icon: User },
  ]

  const handleLogout = () => {
    // Implement logout logic
    navigate('/login')
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-orange-50 to-amber-50">
      {/* Mobile sidebar toggle */}
      <div className="lg:hidden fixed top-4 left-4 z-50">
        <button
          onClick={() => setSidebarOpen(!sidebarOpen)}
          className="p-2 bg-gradient-to-r from-orange-500 to-amber-600 text-white rounded-lg shadow-lg"
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
            <div className="p-2 bg-gradient-to-r from-orange-500 to-amber-600 rounded-xl">
              <Car className="text-white" size={24} />
            </div>
            <div>
              <h1 className="text-xl font-bold text-gray-900">Merkato Driver</h1>
              <p className="text-sm text-gray-500">Delivery Partner</p>
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
                <div className="w-10 h-10 bg-gradient-to-r from-orange-500 to-amber-600 rounded-full flex items-center justify-center text-white font-bold">
                  JD
                </div>
                <div className="absolute -top-1 -right-1 w-4 h-4 bg-green-500 border-2 border-white rounded-full"></div>
              </div>
              <div>
                <p className="font-medium text-gray-900">John Driver</p>
                <p className="text-sm text-gray-500">Online</p>
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
              <h1 className="text-2xl font-bold text-gray-900">Welcome back, John!</h1>
              <p className="text-gray-500">Ready for your next delivery?</p>
            </div>
            
            <div className="flex items-center space-x-4">
              <button className="relative p-2 hover:bg-gray-100 rounded-lg">
                <Bell size={22} className="text-gray-600" />
                <span className="absolute -top-1 -right-1 w-2 h-2 bg-red-500 rounded-full"></span>
              </button>
              
              <button className="flex items-center space-x-2 px-4 py-2 bg-gradient-to-r from-orange-500 to-amber-600 text-white rounded-lg font-medium shadow-md hover:shadow-lg transition-all">
                <MapPin size={18} />
                <span>Go Online</span>
              </button>
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

export default DriverLayout