# MerkatoLink — Full Deployment Guide (Free)

Deploy **backend + 4 dashboards + mobile web app** so everything works together online.

Replace `YOUR-BACKEND-URL` with your actual Render URL (e.g. `https://merkato-backend.onrender.com`).

---

## Architecture

```
                    ┌─────────────────────────┐
                    │   MongoDB Atlas (free)   │
                    └───────────┬─────────────┘
                                │
                    ┌───────────▼─────────────┐
                    │  Backend API (Render)    │
                    │  YOUR-BACKEND-URL        │
                    └───────────┬─────────────┘
                                │
        ┌───────────┬───────────┼───────────┬───────────┐
        │           │           │           │           │
   Admin Web   Seller Web   Staff Web   Driver Web   Mobile Web
   (Vercel)    (Vercel)     (Vercel)    (Vercel)   (GitHub Pages)
```

---

## Step 1 — Backend (Render) ✅

Already set up. Confirm health:

```
YOUR-BACKEND-URL/api/health
```

→ `{"status":"healthy","database":"connected"}`

Seed once in Render Shell:

```bash
npm run seed
```

---

## Step 2 — Deploy 4 dashboards on Vercel (separate URLs)

Go to [vercel.com](https://vercel.com) → **Add New Project** → import `forkenenusa-tech/-merkato-link`.

Create **4 separate projects** from the same repo:

| Project name   | Root Directory  | Environment variable |
|----------------|-----------------|----------------------|
| `merkato-admin`  | `merkato-admin`  | `VITE_API_URL=YOUR-BACKEND-URL` |
| `merkato-seller` | `merkato-seller` | `VITE_API_URL=YOUR-BACKEND-URL` |
| `merkato-staff`  | `merkato-staff`  | `VITE_API_URL=YOUR-BACKEND-URL` |
| `merkato-driver` | `merkato-driver` | `VITE_API_URL=YOUR-BACKEND-URL` |

### For each project:

1. **Import** GitHub repo
2. **Root Directory** → Edit → set folder (e.g. `merkato-admin`)
3. **Environment Variables** → add:
   - Key: `VITE_API_URL`
   - Value: `https://merkato-backend.onrender.com` (your Render URL, **no** `/api` at end)
4. Click **Deploy**

You will get URLs like:

| App    | Example URL                              | Login (after seed)   |
|--------|------------------------------------------|----------------------|
| Admin  | `https://merkato-admin.vercel.app`       | admin@test.com       |
| Seller | `https://merkato-seller.vercel.app`    | seller@test.com      |
| Staff  | `https://merkato-staff.vercel.app`       | staff@test.com       |
| Driver | `https://merkato-driver.vercel.app`    | driver@test.com      |

Password for all: `password123`

---

## Step 3 — Deploy mobile app as website (GitHub Pages)

The Flutter app can be used in a **browser** (same as mobile UI).

### One-time GitHub setup

1. GitHub repo → **Settings** → **Pages**
2. **Source** → **GitHub Actions**
3. **Settings** → **Secrets and variables** → **Actions**
4. Add repository variable (or secret):
   - Name: `API_URL`
   - Value: `https://merkato-backend.onrender.com`

### Deploy

Push to `main` branch — GitHub Actions builds and deploys automatically.

Mobile web URL:

```
https://forkenenusa-tech.github.io/-merkato-link/
```

Login: `user@test.com` / `password123`

---

## Step 4 — Android / iOS app (optional)

For installing on phones, build locally:

```powershell
cd merkato-mobile
# Set production API in .env:
# API_URL=https://merkato-backend.onrender.com
flutter pub get
flutter build apk --release
```

APK output: `merkato-mobile/build/app/outputs/flutter-apk/app-release.apk`

Share the APK or publish to Google Play.

---

## Step 5 — Connect everything (CORS)

On Render → backend service → **Environment**, set `CLIENT_URL` to:

```
*
```

Or list all your frontend URLs (comma-separated, no spaces):

```
https://merkato-admin.vercel.app,https://merkato-seller.vercel.app,https://merkato-staff.vercel.app,https://merkato-driver.vercel.app,https://forkenenusa-tech.github.io
```

Save → Render redeploys.

---

## Environment variables cheat sheet

### Render (backend)

| Key         | Example value |
|-------------|---------------|
| `MONGO_URI` | `mongodb+srv://forkenenusa_db_user:PASSWORD@cluster0.eekmyfn.mongodb.net/merkato?retryWrites=true&w=majority&appName=Cluster0` |
| `JWT_SECRET`| `merkato_jwt_secret_2026` |
| `CLIENT_URL`| `*` |
| `NODE_ENV`  | `production` |

### Vercel (each dashboard)

| Key            | Value |
|----------------|-------|
| `VITE_API_URL` | `https://merkato-backend.onrender.com` |

### GitHub Actions (mobile web)

| Key       | Value |
|-----------|-------|
| `API_URL` | `https://merkato-backend.onrender.com` |

### Flutter local / APK (`merkato-mobile/.env`)

```env
API_URL=https://merkato-backend.onrender.com
```

---

## Test that everything works

1. **Backend:** `YOUR-BACKEND-URL/api/health` → healthy + connected
2. **Admin:** login → see dashboard stats
3. **Seller:** login → see products/orders
4. **Mobile web:** open URL → login → products load
5. **Cross-check:** add product in Seller → appears in Mobile app

---

## Troubleshooting

| Problem | Fix |
|---------|-----|
| CORS error in browser | Set `CLIENT_URL=*` on Render and redeploy |
| Login fails | Run `npm run seed` in Render Shell |
| Slow first load | Render free tier wakes from sleep (~30–60 sec) |
| Mobile shows no products | Check `API_URL` points to Render, not localhost |
| Vercel build fails | Confirm Root Directory is set correctly |

---

## Your live URLs (fill in after deploy)

| Service      | URL |
|--------------|-----|
| Backend API  | `https://________________.onrender.com` |
| Admin        | `https://________________.vercel.app` |
| Seller       | `https://________________.vercel.app` |
| Staff        | `https://________________.vercel.app` |
| Driver       | `https://________________.vercel.app` |
| Mobile Web   | `https://forkenenusa-tech.github.io/-merkato-link/` |
