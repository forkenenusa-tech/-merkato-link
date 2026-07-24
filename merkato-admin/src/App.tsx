import React from 'react'
import { BrowserRouter as Router, Routes, Route, Navigate } from 'react-router-dom'
import Layout from './components/Layout'
import Dashboard from './pages/Dashboard'
import Login from './pages/Login'
import Products from './pages/Products'
import Users from './pages/Users'
import Verification from './pages/Verification'

function App() {
  const isAuthenticated = true // Replace with actual auth check

  return (
    <Router>
      <Routes>
        <Route path="/login" element={<Login />} />
        
        {isAuthenticated ? (
          <Route path="/" element={<Layout />}>
            <Route index element={<Dashboard />} />
            <Route path="products" element={<Products />} />
            <Route path="users" element={<Users />} />
            <Route path="verification" element={<Verification />} />
          </Route>
        ) : (
          <Route path="*" element={<Navigate to="/login" replace />} />
        )}
      </Routes>
    </Router>
  )
}

export default App