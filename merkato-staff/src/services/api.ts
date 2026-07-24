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

// Staff API endpoints
export const staffAPI = {
  // Auth
  login: (data: { email: string; password: string }) =>
    api.post('/auth/login', data),
  
  // Applications
  getApplications: (params?: { 
    type?: 'seller' | 'driver'; 
    status?: string;
    page?: number; 
    limit?: number;
  }) =>
    api.get('/staff/applications', { params }),
  
  getApplication: (applicationId: string, type: 'seller' | 'driver') =>
    api.get(`/staff/applications/${type}/${applicationId}`),
  
  reviewApplication: (applicationId: string, type: 'seller' | 'driver', data: {
    status: 'approved' | 'rejected';
    notes?: string;
  }) =>
    api.put(`/staff/verify/${applicationId}`, { ...data, type }),
  
  // Orders Monitoring
  getAllOrders: (params?: { 
    page?: number; 
    limit?: number; 
    status?: string;
    priority?: string;
  }) =>
    api.get('/staff/orders', { params }),
  
  getOrderDetails: (orderId: string) =>
    api.get(`/staff/orders/${orderId}`),
  
  escalateOrder: (orderId: string, reason: string) =>
    api.post(`/staff/orders/${orderId}/escalate`, { reason }),
  
  resolveOrderIssue: (orderId: string, resolution: string) =>
    api.post(`/staff/orders/${orderId}/resolve`, { resolution }),
  
  // User Management
  getUsers: (params?: { 
    role?: 'customer' | 'seller' | 'driver' | 'staff' | 'admin';
    status?: 'active' | 'suspended' | 'pending';
    page?: number; 
    limit?: number;
  }) =>
    api.get('/staff/users', { params }),
  
  getUser: (userId: string) =>
    api.get(`/staff/users/${userId}`),
  
  updateUserStatus: (userId: string, status: 'active' | 'suspended') =>
    api.put(`/staff/users/${userId}/status`, { status }),
  
  updateUserRole: (userId: string, role: 'customer' | 'seller' | 'driver' | 'staff' | 'admin') =>
    api.put(`/staff/users/${userId}/role`, { role }),
  
  // Analytics & Reports
  getPlatformStats: () =>
    api.get('/staff/stats/platform'),
  
  getSalesReports: (period?: 'daily' | 'weekly' | 'monthly') =>
    api.get('/staff/reports/sales', { params: { period } }),
  
  getUserReports: () =>
    api.get('/staff/reports/users'),
  
  getOrderReports: (params?: { startDate?: string; endDate?: string }) =>
    api.get('/staff/reports/orders', { params }),
  
  // Disputes & Issues
  getDisputes: (params?: { 
    status?: 'open' | 'resolved' | 'escalated';
    page?: number; 
    limit?: number;
  }) =>
    api.get('/staff/disputes', { params }),
  
  getDispute: (disputeId: string) =>
    api.get(`/staff/disputes/${disputeId}`),
  
  updateDispute: (disputeId: string, data: any) =>
    api.put(`/staff/disputes/${disputeId}`, data),
  
  // Platform Settings
  getPlatformSettings: () =>
    api.get('/staff/settings'),
  
  updatePlatformSettings: (settings: any) =>
    api.put('/staff/settings', settings),
  
  // Notifications
  sendNotification: (data: {
    userId?: string;
    userType?: 'all' | 'sellers' | 'drivers' | 'customers';
    title: string;
    message: string;
    type: 'info' | 'warning' | 'success' | 'error';
  }) =>
    api.post('/staff/notifications', data),
  
  // Support
  getSupportTickets: (params?: { 
    status?: 'open' | 'resolved';
    priority?: 'low' | 'medium' | 'high';
    page?: number; 
    limit?: number;
  }) =>
    api.get('/staff/support', { params }),
  
  getSupportTicket: (ticketId: string) =>
    api.get(`/staff/support/${ticketId}`),
  
  updateSupportTicket: (ticketId: string, data: any) =>
    api.put(`/staff/support/${ticketId}`, data),
  
  // Audit Logs
  getAuditLogs: (params?: { 
    action?: string;
    userId?: string;
    startDate?: string;
    endDate?: string;
    page?: number; 
    limit?: number;
  }) =>
    api.get('/staff/audit-logs', { params }),
}

export default api