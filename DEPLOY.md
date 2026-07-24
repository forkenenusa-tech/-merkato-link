# MerkatoLink Backend - Free Deployment Guide

Deploy the API for **free** using **MongoDB Atlas** (database) + **Render** (hosting).

## 1. Push code to GitHub

Repository: https://github.com/forkenenusa-tech/-merkato-link

```powershell
cd D:\mykey_project\Flutter-website\merkato_link
git remote add origin https://github.com/forkenenusa-tech/-merkato-link.git
git commit -m "Initial MerkatoLink platform commit"
git branch -M main
git push -u origin main
```

If the remote already exists:

```powershell
git remote set-url origin https://github.com/forkenenusa-tech/-merkato-link.git
git push -u origin main
```

## 2. Create free MongoDB Atlas database

1. Go to https://www.mongodb.com/cloud/atlas/register
2. Create a **free M0 cluster**
3. Database Access → Add user (username + password)
4. Network Access → Add IP Address → **Allow Access from Anywhere** (`0.0.0.0/0`)
5. Connect → Drivers → copy connection string, e.g.:
   ```
   mongodb+srv://USER:PASSWORD@cluster0.xxxxx.mongodb.net/merkato
   ```
6. Replace `USER`, `PASSWORD`, and keep database name `merkato`

## 3. Deploy backend on Render (free tier)

1. Go to https://render.com and sign up (GitHub login works)
2. **New** → **Blueprint**
3. Connect repo: `forkenenusa-tech/-merkato-link`
4. Render reads `render.yaml` at repo root and creates `merkato-backend`
5. When prompted, set **MONGO_URI** to your Atlas connection string
6. Click **Apply** and wait for deploy (~3–5 minutes)

Your API URL will look like:

```
https://merkato-backend.onrender.com
```

Test it:

```
https://merkato-backend.onrender.com/api/health
```

Expected response:

```json
{"status":"healthy","database":"connected"}
```

## 4. Seed production database (one time)

After deploy succeeds, open Render → **merkato-backend** → **Shell** and run:

```bash
npm run seed
```

Default login accounts (after seed):

| Role   | Email            | Password    |
|--------|------------------|-------------|
| Admin  | admin@test.com   | password123 |
| Seller | seller@test.com  | password123 |
| Staff  | staff@test.com   | password123 |
| Driver | driver@test.com  | password123 |
| User   | user@test.com    | password123 |

## 5. Point apps to deployed API

### Flutter mobile (`merkato-mobile/.env`)

```env
API_URL=https://merkato-backend.onrender.com
```

### React dashboards (Vercel env or local `.env`)

```env
VITE_API_URL=https://merkato-backend.onrender.com/api
```

Redeploy dashboards after changing env vars.

## 6. Optional: deploy dashboards free on Vercel

Each dashboard folder already has `vercel.json`:

- `merkato-admin`
- `merkato-seller`
- `merkato-staff`
- `merkato-driver`

1. https://vercel.com → Import GitHub repo
2. Set **Root Directory** to e.g. `merkato-admin`
3. Add env: `VITE_API_URL=https://merkato-backend.onrender.com/api`
4. Deploy

Repeat for each dashboard.

## Notes

- **Render free tier** sleeps after ~15 min idle; first request may take 30–60 seconds to wake up.
- **Never commit** `.env` files with real passwords (only `.env.example` is in git).
- If health check shows `"database":"disconnected"`, verify `MONGO_URI` and Atlas network access.
