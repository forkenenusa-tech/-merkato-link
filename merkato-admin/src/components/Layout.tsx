import React from 'react'
import { Outlet, Link, useNavigate } from 'react-router-dom'
import { 
  LayoutDashboard, 
  ShoppingBag, 
  Users, 
  FileCheck,
  LogOut,
  Menu,
  X
} from 'lucide-react'
import { useState } from 'react'

const Layout = () => {
  const [sidebarOpen, setSidebarOpen] = useState(false)
  const navigate = useNavigate()

  const handleLogout = () => {
    // Clear token and redirect
    localStorage.removeItem('token')
    localStorage.removeItem('user')
    navigate('/login')
  }

  const navItems = [
    { icon: LayoutDashboard, label: 'Dashboard', path: '/' },
    { icon: ShoppingBag, label: 'Products', path: '/products' },
    { icon: Users, label: 'Users', path: '/users' },
    { icon: FileCheck, label: 'Verification', path: '/verification' },
  ]

  return (
    <div className="min-h-screen bg-gray-50">
      {/* Mobile menu button */}
      <div className="lg:hidden fixed top-4 left-4 z-50">
        <button
          onClick={() => setSidebarOpen(!sidebarOpen)}
          className="p-2 bg-white rounded-lg shadow-md"
        >
          {sidebarOpen ? <X size={24} /> : <Menu size={24} />}
        </button>
      </div>

      {/* Sidebar */}
      <aside className={`
        fixed inset-y-0 left-0 z-40 w-64 bg-white shadow-xl transform 
        ${sidebarOpen ? 'translate-x-0' : '-translate-x-full'} 
        lg:translate-x-0 transition-transform duration-200 ease-in-out
      `}>
        <div className="flex flex-col h-full">
          {/* Logo */}
          <div className="p-6 border-b">
            <div className="flex items-center space-x-3">
              <div className="w-10 h-10 bg-primary rounded-lg flex items-center justify-center">
                <ShoppingBag className="text-white" size={24} />
              </div>
              <div>
                <h1 className="text-xl font-bold text-gray-900">Merkato Link</h1>
                <p className="text-sm text-gray-500">Admin Dashboard</p>
              </div>
            </div>
          </div>

          {/* Navigation */}
          <nav className="flex-1 p-4">
            <ul className="space-y-2">
              {navItems.map((item) => (
                <li key={item.path}>
                  <Link
                    to={item.path}
                    className="flex items-center space-x-3 px-4 py-3 rounded-lg hover:bg-gray-100 text-gray-700 hover:text-primary transition-colors"
                    onClick={() => setSidebarOpen(false)}
                  >
                    <item.icon size={20} />
                    <span className="font-medium">{item.label}</span>
                  </Link>
                </li>
              ))}
            </ul>
          </nav>

          {/* User info & logout */}
          <div className="p-4 border-t">
            <div className="flex items-center space-x-3 mb-4">
              <div className="w-10 h-10 bg-primary/10 rounded-full flex items-center justify-center">
                <span className="font-semibold text-primary">A</span>
              </div>
              <div className="flex-1">
                <p className="font-medium">Admin User</p>
                <p className="text-sm text-gray-500">admin@test.com</p>
              </div>
            </div>
            <button
              onClick={handleLogout}
              className="flex items-center space-x-2 w-full px-4 py-2 text-red-600 hover:bg-red-50 rounded-lg transition-colors"
            >
              <LogOut size={20} />
              <span className="font-medium">Logout</span>
            </button>
          </div>
        </div>
      </aside>

      {/* Main content */}
      <div className="lg:ml-64 min-h-screen">
        <div className="p-6">
          <Outlet />
        </div>
      </div>

      {/* Overlay for mobile */}
      {sidebarOpen && (
        <div
          className="lg:hidden fixed inset-0 bg-black/50 z-30"
          onClick={() => setSidebarOpen(false)}
        />
      )}
    </div>
  )
}

export default Layout