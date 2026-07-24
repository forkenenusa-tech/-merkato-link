import axios from 'axios'

const API_BASE = (import.meta.env.VITE_API_URL || 'http://localhost:5000').replace(/\/$/, '')

const api = axios.create({
  baseURL: `${API_BASE}/api`,
  headers: {
    'Content-Type': 'application/json',
  },
})

// Add token to requests if exists
api.interceptors.request.use(
  (config) => {
    const token = localStorage.getItem('token')
    if (token) {
      config.headers.Authorization = `Bearer ${token}`
    }
    return config
  },
  (error) => {
    return Promise.reject(error)
  }
)

// Seller API endpoints
export const sellerAPI = {
  // Auth
  login: (data: { email: string; password: string }) =>
    api.post('/auth/login', data),
  
  register: (data: any) =>
    api.post('/auth/register/seller', data),
  
  // Profile & Store
  getProfile: () =>
    api.get('/seller/profile'),
  
  updateProfile: (data: any) =>
    api.put('/seller/profile', data),
  
  getStoreInfo: () =>
    api.get('/seller/store'),
  
  updateStoreInfo: (data: any) =>
    api.put('/seller/store', data),
  
  // Products
  getProducts: (params?: { page?: number; limit?: number; category?: string }) =>
    api.get('/seller/products', { params }),
  
  getProduct: (productId: string) =>
    api.get(`/seller/products/${productId}`),
  
  createProduct: (data: any) =>
    api.post('/seller/products', data),
  
  updateProduct: (productId: string, data: any) =>
    api.put(`/seller/products/${productId}`, data),
  
  deleteProduct: (productId: string) =>
    api.delete(`/seller/products/${productId}`),
  
  updateInventory: (productId: string, stock: number) =>
    api.patch(`/seller/products/${productId}/inventory`, { stock }),
  
  // Orders
  getOrders: (params?: { 
    page?: number; 
    limit?: number; 
    status?: string;
    startDate?: string;
    endDate?: string;
  }) =>
    api.get('/seller/orders', { params }),
  
  getOrder: (orderId: string) =>
    api.get(`/seller/orders/${orderId}`),
  
  updateOrderStatus: (orderId: string, status: string) =>
    api.put(`/seller/orders/${orderId}/status`, { status }),
  
  // Analytics
  getSalesAnalytics: (period?: 'daily' | 'weekly' | 'monthly' | 'yearly') =>
    api.get('/seller/analytics/sales', { params: { period } }),
  
  getCustomerAnalytics: () =>
    api.get('/seller/analytics/customers'),
  
  getProductAnalytics: () =>
    api.get('/seller/analytics/products'),
  
  // Store Management
  getStoreStats: () =>
    api.get('/seller/store/stats'),
  
  updateStoreSettings: (settings: any) =>
    api.put('/seller/store/settings', settings),
  
  // Payments
  getPaymentHistory: (params?: { page?: number; limit?: number }) =>
    api.get('/seller/payments', { params }),
  
  getPaymentSummary: () =>
    api.get('/seller/payments/summary'),
  
  // Support
  createSupportTicket: (data: { subject: string; message: string }) =>
    api.post('/seller/support', data),
  
  getSupportTickets: () =>
    api.get('/seller/support'),
  
  // Reviews
  getProductReviews: (params?: { page?: number; limit?: number }) =>
    api.get('/seller/reviews', { params }),
  
  respondToReview: (reviewId: string, response: string) =>
    api.post(`/seller/reviews/${reviewId}/respond`, { response }),
}

export default api