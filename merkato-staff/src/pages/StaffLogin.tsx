import React, { useState } from 'react'
import { Shield, Mail, Lock, Eye, EyeOff, LogIn } from 'lucide-react'
import { useNavigate } from 'react-router-dom'

const StaffLogin = () => {
  const navigate = useNavigate()
  const [showPassword, setShowPassword] = useState(false)
  const [formData, setFormData] = useState({
    email: 'staff@test.com',
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
      if (formData.email === 'staff@test.com' && formData.password === 'password123') {
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
    <div className="min-h-screen bg-gradient-to-br from-blue-50 to-indigo-50 flex items-center justify-center p-4">
      <div className="w-full max-w-md">
        {/* Logo & Header */}
        <div className="text-center mb-8">
          <div className="inline-flex p-4 bg-gradient-to-r from-blue-500 to-indigo-600 rounded-2xl shadow-lg mb-4">
            <Shield size={40} className="text-white" />
          </div>
          <h1 className="text-3xl font-bold text-gray-900">Merkato Staff Portal</h1>
          <p className="text-gray-500 mt-2">Sign in to staff support and verification panel</p>
        </div>

        {/* Login Card */}
        <div className="bg-white/80 backdrop-blur-lg rounded-2xl shadow-xl p-8 border border-white/20">
          <form onSubmit={handleSubmit} className="space-y-6">
            {/* Email Input */}
            <div>
              <label htmlFor="email" className="block text-sm font-medium text-gray-700 mb-2">
                Staff Email
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
                  className="w-full pl-12 pr-4 py-3 border border-gray-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500/50 focus:border-blue-500 transition-all"
                  placeholder="staff@merkato.com"
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
                  className="text-sm text-blue-600 hover:text-blue-700 font-medium"
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
                  className="w-full pl-12 pr-12 py-3 border border-gray-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500/50 focus:border-blue-500 transition-all"
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
                  className="h-4 w-4 text-blue-600 focus:ring-blue-500 border-gray-300 rounded"
                />
                <label htmlFor="remember-me" className="ml-2 text-sm text-gray-700">
                  Remember me
                </label>
              </div>
              
              <div className="text-sm">
                <p className="text-gray-500">Demo credentials:</p>
                <p className="font-medium">staff@test.com</p>
                <p className="font-medium">password123</p>
              </div>
            </div>

            {/* Security Notice */}
            <div className="p-4 bg-gradient-to-r from-blue-50 to-indigo-50 rounded-xl">
              <div className="flex items-start gap-3">
                <Shield size={18} className="text-blue-600 mt-0.5" />
                <div>
                  <p className="text-sm font-medium text-gray-900">Security Notice</p>
                  <p className="text-xs text-gray-500 mt-1">
                    This portal contains sensitive information. Ensure you are authorized to access staff controls.
                  </p>
                </div>
              </div>
            </div>

            {/* Submit Button */}
            <button
              type="submit"
              disabled={isLoading}
              className="w-full flex items-center justify-center gap-3 bg-gradient-to-r from-blue-500 to-indigo-600 hover:from-blue-600 hover:to-indigo-700 text-white py-3 rounded-xl font-medium shadow-lg hover:shadow-xl transition-all disabled:opacity-50"
            >
              {isLoading ? (
                <>
                  <div className="w-5 h-5 border-2 border-white/30 border-t-white rounded-full animate-spin"></div>
                  Verifying credentials...
                </>
              ) : (
                <>
                  <LogIn size={20} />
                  Sign In to Staff Panel
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
                <span className="px-2 bg-white text-gray-500">Or use secure access</span>
              </div>
            </div>
          </div>

          {/* Two-Factor & Links */}
          <div className="space-y-4">
            <button className="w-full flex items-center justify-center gap-3 border border-gray-300 hover:border-gray-400 text-gray-700 py-3 rounded-xl font-medium transition-all hover:shadow-sm">
              <div className="w-5 h-5 bg-purple-600 rounded-full flex items-center justify-center text-white">
                <span className="text-xs font-bold">2FA</span>
              </div>
              Two-Factor Authentication
            </button>

            <div className="text-center mt-6">
              <p className="text-gray-500">
                Need staff access?{' '}
                <button className="text-blue-600 hover:text-blue-700 font-medium">
                  Contact administrator
                </button>
              </p>
            </div>
          </div>
        </div>

        {/* Platform Stats */}
        <div className="mt-8 grid grid-cols-3 gap-4">
          <div className="text-center p-4 bg-white/50 backdrop-blur-sm rounded-xl">
            <p className="text-2xl font-bold text-gray-900">50+</p>
            <p className="text-sm text-gray-500">Staff Members</p>
          </div>
          <div className="text-center p-4 bg-white/50 backdrop-blur-sm rounded-xl">
            <p className="text-2xl font-bold text-gray-900">500+</p>
            <p className="text-sm text-gray-500">Verified Applications</p>
          </div>
          <div className="text-center p-4 bg-white/50 backdrop-blur-sm rounded-xl">
            <p className="text-2xl font-bold text-gray-900">99.8%</p>
            <p className="text-sm text-gray-500">Uptime</p>
          </div>
        </div>

        {/* Footer */}
        <div className="mt-8 text-center">
          <p className="text-gray-500 text-sm">
            © 2023 Merkato Link • Staff Access Only
          </p>
          <div className="flex items-center justify-center gap-4 mt-2">
            <button className="text-sm text-gray-500 hover:text-gray-700">Privacy Policy</button>
            <button className="text-sm text-gray-500 hover:text-gray-700">Terms of Service</button>
            <button className="text-sm text-gray-500 hover:text-gray-700">Security</button>
          </div>
        </div>
      </div>
    </div>
  )
}

export default StaffLogin