import React from 'react'
import { BrowserRouter as Router, Routes, Route, Navigate } from 'react-router-dom'
import StaffLayout from './components/StaffLayout'
import StaffDashboard from './pages/StaffDashboard'
import StaffVerification from './pages/StaffVerification'
import StaffOrders from './pages/StaffOrders'
import StaffLogin from './pages/StaffLogin'

function App() {
  const isAuthenticated = true // Replace with actual auth check

  return (
    <Router>
      <Routes>
        <Route path="/login" element={<StaffLogin />} />
        
        {isAuthenticated ? (
          <Route path="/" element={<StaffLayout />}>
            <Route index element={<StaffDashboard />} />
            <Route path="verification" element={<StaffVerification />} />
            <Route path="orders" element={<StaffOrders />} />
          </Route>
        ) : (
          <Route path="*" element={<Navigate to="/login" replace />} />
        )}
      </Routes>
    </Router>
  )
}

export default App