import axios from 'axios'

// Direct URL - Vercel will replace VITE_API_URL during build
const API_BASE = 'https://merkato-link.onrender.com'

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
  
  createAdmin: (data: any) =>
    api.post('/api/admin/create-admin', data),
}

export const adminApi = {
  getStats: () => api.get('/api/admin/stats'),
  
  getUsers: (params?: any) => 
    api.get('/api/admin/users', { params }),
  
  updateUser: (id: string, data: any) => 
    api.put(`/api/admin/users/${id}`, data),
  
  getProducts: (params?: any) => 
    api.get('/api/admin/products', { params }),
  
  deleteProduct: (id: string) => 
    api.delete(`/api/products/${id}`),
  
  getApplications: (params?: any) => 
    api.get('/api/admin/applications', { params }),
  
  verifyApplication: (id: string, data: any) => 
    api.put(`/api/admin/verify/${id}`, data),
  
  getOrders: (params?: any) =>
    api.get('/api/admin/orders', { params }),
}

export default api