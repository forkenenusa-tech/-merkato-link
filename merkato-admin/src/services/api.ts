import axios from 'axios'

const API_BASE = (import.meta.env.VITE_API_URL || 'http://localhost:5000').replace(/\/$/, '')

const api = axios.create({
  baseURL: API_BASE,
  headers: {
    'Content-Type': 'application/json',
  },
})

// Add token to requests
api.interceptors.request.use((config) => {
  const token = localStorage.getItem('token')
  if (token) {
    config.headers.Authorization = `Bearer ${token}`
  }
  return config
})

// Handle responses
api.interceptors.response.use(
  (response) => response,
  (error) => {
    if (error.response?.status === 401) {
      // Token expired or invalid
      localStorage.removeItem('token')
      localStorage.removeItem('user')
      window.location.href = '/login'
    }
    return Promise.reject(error)
  }
)

export const authApi = {
  login: (email: string, password: string) => 
    api.post('/api/auth/login', { email, password }),
  
  getProfile: () => api.get('/api/auth/profile'),
}

export const adminApi = {
  getStats: () => api.get('/api/admin/stats'),
  
  getUsers: (params?: any) => 
    api.get('/api/admin/users', { params }),
  
  updateUser: (id: string, data: any) => 
    api.put(`/api/admin/users/${id}`, data),
  
  getProducts: (params?: any) => 
    api.get('/api/products', { params }),
  
  deleteProduct: (id: string) => 
    api.delete(`/api/products/${id}`),
}

export const staffApi = {
  getApplications: (params?: any) => 
    api.get('/api/staff/applications', { params }),
  
  verifyApplication: (id: string, data: any) => 
    api.put(`/api/staff/verify/${id}`, data),
}

export default api