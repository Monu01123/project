# Azure Backend 500 Error - Quick Fix Guide

## Problem
Your Azure backend is returning 500 errors because **environment variables are not configured in Azure**.

## Quick Fix Steps

### Step 1: Configure Environment Variables in Azure Portal

1. Go to [Azure Portal](https://portal.azure.com)
2. Navigate to your App Service: **skillora-hxcjbsbzd6e4h9c6**
3. Click **Configuration** in the left sidebar
4. Click **New application setting** for each variable below:

**Required Settings:**
```
DB_HOST = skillora.mysql.database.azure.com
DB_USER = monumeena
DB_PASSWORD = Monu8875@
DB_NAME = elearning
JWT_SECRET = ksdjfhkldsjhfkdhf
EMAIL_USER = justryme8875@gmail.com
EMAIL_PASS = yepl usyq ytuc wswg
NODE_ENV = production
STRIPE_SERVER_SECRET_KEY = <your-stripe-secret-key>
ENDPOINT_SECRET = <your-stripe-endpoint-secret>
CLIENT_URL = <your-frontend-url>
```

5. Click **Save** at the top
6. Click **Restart** to apply changes

### Step 2: Redeploy Updated Code

Your local code now has a health check endpoint. Deploy it to Azure:

**Option A: Using Azure CLI**
```bash
cd "c:\Users\monum\OneDrive\Desktop\Projects\My Projects\Ed-Tech\Backend"
az webapp up --name skillora-hxcjbsbzd6e4h9c6 --resource-group <your-resource-group>
```

**Option B: Using Git (if configured)**
```bash
git add .
git commit -m "Add health check endpoint"
git push azure main
```

**Option C: Manual Upload via Kudu**
1. Go to: https://skillora-hxcjbsbzd6e4h9c6.scm.azurewebsites.net
2. Click **Debug console** → **CMD**
3. Navigate to `site/wwwroot`
4. Upload these files:
   - `server.js`
   - `routes/healthRoute.js`
   - `DigiCertGlobalRootCA.crt.pem`
5. Restart the app

### Step 3: Test the Health Endpoint

After deployment, visit:
```
https://skillora-hxcjbsbzd6e4h9c6.canadacentral-01.azurewebsites.net/health
```

This will show:
- ✓ Environment variables status
- ✓ Database connection status
- ✓ Any configuration issues

### Step 4: Verify Endpoints Work

Once health check passes, test:
- https://skillora-hxcjbsbzd6e4h9c6.canadacentral-01.azurewebsites.net/categories
- https://skillora-hxcjbsbzd6e4h9c6.canadacentral-01.azurewebsites.net/auth/login

## Why This Happened

Azure App Service doesn't read `.env` files. You must configure environment variables through:
- Azure Portal → Configuration
- Azure CLI
- ARM templates

The 500 errors occurred because the backend couldn't connect to the database without these variables.
