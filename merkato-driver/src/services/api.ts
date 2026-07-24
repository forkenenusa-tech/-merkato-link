import axios from 'axios'

const API_URL = 'http://localhost:5001/api'

const api = axios.create({
  baseURL: API_URL,
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

// Driver API endpoints
export const driverAPI = {
  // Auth
  login: (data: { email: string; password: string }) =>
    api.post('/auth/login', data),
  
  register: (data: any) =>
    api.post('/auth/register/driver', data),
  
  // Profile
  getProfile: () =>
    api.get('/driver/profile'),
  
  updateProfile: (data: any) =>
    api.put('/driver/profile', data),
  
  // Deliveries
  getActiveDeliveries: () =>
    api.get('/driver/deliveries/active'),
  
  getDeliveryHistory: (params?: { page?: number; limit?: number }) =>
    api.get('/driver/deliveries/history', { params }),
  
  updateDeliveryStatus: (deliveryId: string, status: string) =>
    api.put(`/driver/deliveries/${deliveryId}/status`, { status }),
  
  // Earnings
  getEarnings: (period?: 'daily' | 'weekly' | 'monthly') =>
    api.get('/driver/earnings', { params: { period } }),
  
  getStats: () =>
    api.get('/driver/stats'),
  
  // Map & Location
  updateLocation: (location: { lat: number; lng: number }) =>
    api.post('/driver/location', location),
  
  getDeliveryRoute: (deliveryId: string) =>
    api.get(`/driver/deliveries/${deliveryId}/route`),
  
  // Availability
  setAvailability: (available: boolean) =>
    api.post('/driver/availability', { available }),
  
  // Support
  reportIssue: (data: { deliveryId: string; issue: string; details: string }) =>
    api.post('/driver/report-issue', data),
  
  getSupportMessages: () =>
    api.get('/driver/support'),
}

export default api