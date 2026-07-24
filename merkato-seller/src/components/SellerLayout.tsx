import React from 'react'
import { Outlet, Link, useNavigate, useLocation } from 'react-router-dom'
import { 
  LayoutDashboard, 
  Package, 
  ShoppingBag, 
  Store,
  LogOut,
  Menu,
  X,
  Bell,
  User,
  TrendingUp
} from 'lucide-react'
import { useState } from 'react'

const SellerLayout = () => {
  const [sidebarOpen, setSidebarOpen] = useState(false)
  const navigate = useNavigate()
  const location = useLocation()

  const handleLogout = () => {
    localStorage.removeItem('seller_token')
    localStorage.removeItem('seller_user')
    navigate('/login')
  }

  const navItems = [
    { icon: LayoutDashboard, label: 'Dashboard', path: '/' },
    { icon: Package, label: 'Products', path: '/products' },
    { icon: ShoppingBag, label: 'Orders', path: '/orders' },
    { icon: Store, label: 'Store Settings', path: '/store' },
  ]

  return (
    <div className="min-h-screen gradient-bg">
      {/* Mobile menu button */}
      <div className="lg:hidden fixed top-4 left-4 z-50">
        <button
          onClick={() => setSidebarOpen(!sidebarOpen)}
          className="p-3 bg-white rounded-xl shadow-lg"
        >
          {sidebarOpen ? <X size={24} /> : <Menu size={24} />}
        </button>
      </div>

      {/* Sidebar */}
      <aside className={`
        fixed inset-y-0 left-0 z-40 w-72 bg-white/95 backdrop-blur-xl shadow-2xl transform 
        ${sidebarOpen ? 'translate-x-0' : '-translate-x-full'} 
        lg:translate-x-0 transition-transform duration-300 ease-in-out
      `}>
        <div className="flex flex-col h-full">
          {/* Logo */}
          <div className="p-6 border-b border-gray-100">
            <div className="flex items-center space-x-3">
              <div className="w-12 h-12 bg-gradient-to-br from-green-500 to-emerald-600 rounded-xl flex items-center justify-center shadow-lg">
                <Store className="text-white" size={28} />
              </div>
              <div>
                <h1 className="text-xl font-bold text-gray-900">Merkato Seller</h1>
                <p className="text-sm text-gray-500">Business Dashboard</p>
              </div>
            </div>
          </div>

          {/* Navigation */}
          <nav className="flex-1 p-4">
            <ul className="space-y-2">
              {navItems.map((item) => {
                const isActive = location.pathname === item.path
                return (
                  <li key={item.path}>
                    <Link
                      to={item.path}
                      className={`sidebar-item ${isActive ? 'sidebar-item-active' : ''}`}
                      onClick={() => setSidebarOpen(false)}
                    >
                      <item.icon size={22} />
                      <span className="font-medium">{item.label}</span>
                      {isActive && (
                        <div className="ml-auto w-2 h-2 bg-green-500 rounded-full"></div>
                      )}
                    </Link>
                  </li>
                )
              })}
            </ul>
          </nav>

          {/* Stats */}
          <div className="p-4 border-t border-gray-100">
            <div className="bg-gradient-to-r from-green-50 to-emerald-50 rounded-xl p-4">
              <div className="flex items-center justify-between mb-3">
                <div className="flex items-center space-x-2">
                  <TrendingUp size={18} className="text-green-600" />
                  <span className="text-sm font-medium text-gray-700">Today's Sales</span>
                </div>
                <span className="text-lg font-bold text-green-700">ETB 2,450</span>
              </div>
              <div className="text-xs text-gray-500">+12% from yesterday</div>
            </div>
          </div>

          {/* User info & logout */}
          <div className="p-4 border-t border-gray-100">
            <div className="flex items-center space-x-3 mb-4">
              <div className="w-10 h-10 bg-gradient-to-br from-green-400 to-emerald-500 rounded-full flex items-center justify-center shadow-md">
                <User className="text-white" size={20} />
              </div>
              <div className="flex-1">
                <p className="font-semibold">Ethio Crafts Store</p>
                <p className="text-sm text-gray-500">seller@test.com</p>
              </div>
              <button className="p-2 text-gray-400 hover:text-gray-600">
                <Bell size={20} />
              </button>
            </div>
            <button
              onClick={handleLogout}
              className="flex items-center space-x-2 w-full px-4 py-3 text-red-600 hover:bg-red-50 rounded-xl transition-colors"
            >
              <LogOut size={20} />
              <span className="font-medium">Logout</span>
            </button>
          </div>
        </div>
      </aside>

      {/* Main content */}
      <div className="lg:ml-72 min-h-screen">
        <div className="p-6">
          <Outlet />
        </div>
      </div>

      {/* Overlay for mobile */}
      {sidebarOpen && (
        <div
          className="lg:hidden fixed inset-0 bg-black/30 backdrop-blur-sm z-30"
          onClick={() => setSidebarOpen(false)}
        />
      )}
    </div>
  )
}

export default SellerLayout