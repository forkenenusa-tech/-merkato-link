import React, { useState } from 'react'
import { Car, Mail, Lock, Eye, EyeOff, LogIn } from 'lucide-react'
import { useNavigate } from 'react-router-dom'

const DriverLogin = () => {
  const navigate = useNavigate()
  const [showPassword, setShowPassword] = useState(false)
  const [formData, setFormData] = useState({
    email: 'driver@test.com',
    password: 'password123'
  })
  const [isLoading, setIsLoading] = useState(false)
  const [rememberMe, setRememberMe] = useState(false)

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    setIsLoading(true)
    
    // Simulate API call
    setTimeout(() => {
      setIsLoading(false)
      // For demo, always succeed with test credentials
      if (formData.email === 'driver@test.com' && formData.password === 'password123') {
        navigate('/')
      }
    }, 1000)
  }

  const handleInputChange = (field: string, value: string) => {
    setFormData(prev => ({
      ...prev,
      [field]: value
    }))
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-orange-50 to-amber-50 flex items-center justify-center p-4">
      <div className="w-full max-w-md">
        {/* Logo & Header */}
        <div className="text-center mb-8">
          <div className="inline-flex p-4 bg-gradient-to-r from-orange-500 to-amber-600 rounded-2xl shadow-lg mb-4">
            <Car size={40} className="text-white" />
          </div>
          <h1 className="text-3xl font-bold text-gray-900">Merkato Driver Portal</h1>
          <p className="text-gray-500 mt-2">Sign in to your delivery partner account</p>
        </div>

        {/* Login Card */}
        <div className="bg-white/80 backdrop-blur-lg rounded-2xl shadow-xl p-8 border border-white/20">
          <form onSubmit={handleSubmit} className="space-y-6">
            {/* Email Input */}
            <div>
              <label htmlFor="email" className="block text-sm font-medium text-gray-700 mb-2">
                Email Address
              </label>
              <div className="relative">
                <div className="absolute left-3 top-1/2 transform -translate-y-1/2">
                  <Mail size={20} className="text-gray-400" />
                </div>
                <input
                  id="email"
                  type="email"
                  value={formData.email}
                  onChange={(e) => handleInputChange('email', e.target.value)}
                  className="w-full pl-12 pr-4 py-3 border border-gray-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-orange-500/50 focus:border-orange-500 transition-all"
                  placeholder="driver@example.com"
                  required
                />
              </div>
            </div>

            {/* Password Input */}
            <div>
              <div className="flex items-center justify-between mb-2">
                <label htmlFor="password" className="block text-sm font-medium text-gray-700">
                  Password
                </label>
                <button
                  type="button"
                  className="text-sm text-orange-600 hover:text-orange-700 font-medium"
                >
                  Forgot password?
                </button>
              </div>
              <div className="relative">
                <div className="absolute left-3 top-1/2 transform -translate-y-1/2">
                  <Lock size={20} className="text-gray-400" />
                </div>
                <input
                  id="password"
                  type={showPassword ? 'text' : 'password'}
                  value={formData.password}
                  onChange={(e) => handleInputChange('password', e.target.value)}
                  className="w-full pl-12 pr-12 py-3 border border-gray-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-orange-500/50 focus:border-orange-500 transition-all"
                  placeholder="Enter your password"
                  required
                />
                <button
                  type="button"
                  onClick={() => setShowPassword(!showPassword)}
                  className="absolute right-3 top-1/2 transform -translate-y-1/2 text-gray-400 hover:text-gray-600"
                >
                  {showPassword ? <EyeOff size={20} /> : <Eye size={20} />}
                </button>
              </div>
            </div>

            {/* Remember Me & Demo Credentials */}
            <div className="flex items-center justify-between">
              <div className="flex items-center">
                <input
                  id="remember-me"
                  type="checkbox"
                  checked={rememberMe}
                  onChange={(e) => setRememberMe(e.target.checked)}
                  className="h-4 w-4 text-orange-600 focus:ring-orange-500 border-gray-300 rounded"
                />
                <label htmlFor="remember-me" className="ml-2 text-sm text-gray-700">
                  Remember me
                </label>
              </div>
              
              <div className="text-sm">
                <p className="text-gray-500">Demo credentials:</p>
                <p className="font-medium">driver@test.com</p>
                <p className="font-medium">password123</p>
              </div>
            </div>

            {/* Submit Button */}
            <button
              type="submit"
              disabled={isLoading}
              className="w-full flex items-center justify-center gap-3 bg-gradient-to-r from-orange-500 to-amber-600 hover:from-orange-600 hover:to-amber-700 text-white py-3 rounded-xl font-medium shadow-lg hover:shadow-xl transition-all disabled:opacity-50"
            >
              {isLoading ? (
                <>
                  <div className="w-5 h-5 border-2 border-white/30 border-t-white rounded-full animate-spin"></div>
                  Signing in...
                </>
              ) : (
                <>
                  <LogIn size={20} />
                  Sign In to Dashboard
                </>
              )}
            </button>
          </form>

          {/* Divider */}
          <div className="mt-8 mb-6">
            <div className="relative">
              <div className="absolute inset-0 flex items-center">
                <div className="w-full border-t border-gray-300"></div>
              </div>
              <div className="relative flex justify-center text-sm">
                <span className="px-2 bg-white text-gray-500">Or continue with</span>
              </div>
            </div>
          </div>

          {/* Social Login & Links */}
          <div className="space-y-4">
            <button className="w-full flex items-center justify-center gap-3 border border-gray-300 hover:border-gray-400 text-gray-700 py-3 rounded-xl font-medium transition-all hover:shadow-sm">
              <div className="w-5 h-5 bg-blue-600 rounded-full flex items-center justify-center text-white">
                <span className="text-xs font-bold">f</span>
              </div>
              Continue with Facebook
            </button>

            <button className="w-full flex items-center justify-center gap-3 border border-gray-300 hover:border-gray-400 text-gray-700 py-3 rounded-xl font-medium transition-all hover:shadow-sm">
              <div className="w-5 h-5 bg-red-600 rounded-full flex items-center justify-center text-white">
                <span className="text-xs font-bold">G</span>
              </div>
              Continue with Google
            </button>

            <div className="text-center mt-6">
              <p className="text-gray-500">
                New to Merkato Driver?{' '}
                <button className="text-orange-600 hover:text-orange-700 font-medium">
                  Apply now as a driver
                </button>
              </p>
            </div>
          </div>
        </div>

        {/* Stats Footer */}
        <div className="mt-8 grid grid-cols-3 gap-4">
          <div className="text-center p-4 bg-white/50 backdrop-blur-sm rounded-xl">
            <p className="text-2xl font-bold text-gray-900">500+</p>
            <p className="text-sm text-gray-500">Active Drivers</p>
          </div>
          <div className="text-center p-4 bg-white/50 backdrop-blur-sm rounded-xl">
            <p className="text-2xl font-bold text-gray-900">10K+</p>
            <p className="text-sm text-gray-500">Deliveries</p>
          </div>
          <div className="text-center p-4 bg-white/50 backdrop-blur-sm rounded-xl">
            <p className="text-2xl font-bold text-gray-900">4.8/5</p>
            <p className="text-sm text-gray-500">Avg Rating</p>
          </div>
        </div>

        {/* Footer */}
        <div className="mt-8 text-center">
          <p className="text-gray-500 text-sm">
            © 2023 Merkato Link • Ethiopian Marketplace Platform
          </p>
          <div className="flex items-center justify-center gap-4 mt-2">
            <button className="text-sm text-gray-500 hover:text-gray-700">Privacy Policy</button>
            <button className="text-sm text-gray-500 hover:text-gray-700">Terms of Service</button>
            <button className="text-sm text-gray-500 hover:text-gray-700">Help Center</button>
          </div>
        </div>
      </div>
    </div>
  )
}

export default DriverLogin