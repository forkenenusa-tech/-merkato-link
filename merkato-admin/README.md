# Merkato Link - Admin Dashboard

React-based admin dashboard for managing the Merkato Link marketplace.

## Features
- Dashboard with statistics and analytics
- Product management (view, delete)
- User management (view, suspend/activate)
- Application verification system
- Responsive design with Tailwind CSS

## Setup

```bash
# Install dependencies
npm install

# Start development server
npm run dev

# Build for production
npm run build
```

## Environment Variables

Create `.env` file:
```env
VITE_API_URL=http://localhost:5001
```

## Development
- Built with Vite + React + TypeScript
- Uses Tailwind CSS for styling
- React Router for navigation
- Axios for API calls

## Deployment
- Ready for Vercel (see `vercel.json`)
- Can deploy to Netlify or any static host

## API Integration
Connects to the Merkato Link backend API running on port 5001.