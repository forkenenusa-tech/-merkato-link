import React, { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { Store, Lock, Mail, Sparkles } from 'lucide-react'

const SellerLogin = () => {
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState('')
  const navigate = useNavigate()

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    setLoading(true)
    setError('')

    // Mock login for now
    setTimeout(() => {
      localStorage.setItem('seller_token', 'mock_token')
      localStorage.setItem('seller_user', JSON.stringify({
        name: 'Ethio Crafts Store',
        email: email,
        role: 'seller'
      }))
      navigate('/')
      setLoading(false)
    }, 1000)
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-green-50 via-white to-emerald-50 flex items-center justify-center p-4">
      <div className="max-w-md w-full">
        {/* Logo with animation */}
        <div className="text-center mb-8 animate-fade-in">
          <div className="inline-flex items-center justify-center w-20 h-20 bg-gradient-to-br from-green-500 to-emerald-600 rounded-2xl mb-4 shadow-lg animate-bounce">
            <Store className="text-white" size={36} />
          </div>
          <div className="flex items-center justify-center gap-2 mb-2">
            <h1 className="text-3xl font-bold text-gray-900">Merkato Seller</h1>
            <Sparkles className="text-amber-500" size={20} />
          </div>
          <p className="text-gray-500">Access your business dashboard</p>
        </div>

        {/* Login Form */}
        <div className="glass-card rounded-2xl p-8 shadow-xl animate-slide-up">
          <form onSubmit={handleSubmit} className="space-y-6">
            {error && (
              <div className="bg-red-50 border border-red-200 text-red-600 px-4 py-3 rounded-lg animate-shake">
                {error}
              </div>
            )}

            <div>
              <label className="block text-sm font-medium text-gray-700 mb-2">
                Email Address
              </label>
              <div className="relative">
                <Mail className="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400" size={20} />
                <input
                  type="email"
                  value={email}
                  onChange={(e) => setEmail(e.target.value)}
                  className="input-field pl-10 w-full"
                  placeholder="seller@test.com"
                  required
                />
              </div>
            </div>

            <div>
              <label className="block text-sm font-medium text-gray-700 mb-2">
                Password
              </label>
              <div className="relative">
                <Lock className="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400" size={20} />
                <input
                  type="password"
                  value={password}
                  onChange={(e) => setPassword(e.target.value)}
                  className="input-field pl-10 w-full"
                  placeholder="••••••••"
                  required
                />
              </div>
            </div>

            <button
              type="submit"
              disabled={loading}
              className="btn-primary w-full py-3 text-lg font-semibold flex items-center justify-center gap-2"
            >
              {loading ? (
                <>
                  <div className="w-5 h-5 border-2 border-white border-t-transparent rounded-full animate-spin"></div>
                  Signing in...
                </>
              ) : (
                'Sign In to Dashboard'
              )}
            </button>

            <div className="text-center text-sm text-gray-500">
              <p>Demo Credentials:</p>
              <p className="mt-1 font-mono">seller@test.com / password123</p>
              <div className="mt-4 p-3 bg-gradient-to-r from-green-50 to-emerald-50 rounded-lg">
                <p className="font-medium text-green-800">Seller Benefits:</p>
                <ul className="text-xs text-green-700 mt-2 space-y-1">
                  <li>✓ Manage products & inventory</li>
                  <li>✓ Process customer orders</li>
                  <li>✓ Track sales & analytics</li>
                  <li>✓ Customize store settings</li>
                </ul>
              </div>
            </div>
          </form>
        </div>

        {/* Footer */}
        <div className="mt-8 text-center text-sm text-gray-500 animate-fade-in">
          <p>© {new Date().getFullYear()} Merkato Link. Ethiopian Marketplace</p>
          <p className="mt-1">Sell your products to thousands of customers</p>
        </div>
      </div>
    </div>
  )
}

export default SellerLogin