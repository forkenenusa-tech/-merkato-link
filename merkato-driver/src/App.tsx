import React from 'react'
import { BrowserRouter as Router, Routes, Route, Navigate } from 'react-router-dom'
import DriverLayout from './components/DriverLayout'
import DriverDashboard from './pages/DriverDashboard'
import DriverDeliveries from './pages/DriverDeliveries'
import DriverHistory from './pages/DriverHistory'
import DriverProfile from './pages/DriverProfile'
import DriverLogin from './pages/DriverLogin'

function App() {
  const isAuthenticated = true // Replace with actual auth check

  return (
    <Router>
      <Routes>
        <Route path="/login" element={<DriverLogin />} />
        
        {isAuthenticated ? (
          <Route path="/" element={<DriverLayout />}>
            <Route index element={<DriverDashboard />} />
            <Route path="deliveries" element={<DriverDeliveries />} />
            <Route path="history" element={<DriverHistory />} />
            <Route path="profile" element={<DriverProfile />} />
          </Route>
        ) : (
          <Route path="*" element={<Navigate to="/login" replace />} />
        )}
      </Routes>
    </Router>
  )
}

export default App