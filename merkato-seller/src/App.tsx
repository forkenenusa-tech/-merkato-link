import React from 'react'
import { BrowserRouter as Router, Routes, Route, Navigate } from 'react-router-dom'
import SellerLayout from './components/SellerLayout'
import SellerDashboard from './pages/SellerDashboard'
import SellerProducts from './pages/SellerProducts'
import SellerOrders from './pages/SellerOrders'
import SellerStore from './pages/SellerStore'
import SellerLogin from './pages/SellerLogin'

function App() {
  const isAuthenticated = true // Replace with actual auth check

  return (
    <Router>
      <Routes>
        <Route path="/login" element={<SellerLogin />} />
        
        {isAuthenticated ? (
          <Route path="/" element={<SellerLayout />}>
            <Route index element={<SellerDashboard />} />
            <Route path="products" element={<SellerProducts />} />
            <Route path="orders" element={<SellerOrders />} />
            <Route path="store" element={<SellerStore />} />
          </Route>
        ) : (
          <Route path="*" element={<Navigate to="/login" replace />} />
        )}
      </Routes>
    </Router>
  )
}

export default App