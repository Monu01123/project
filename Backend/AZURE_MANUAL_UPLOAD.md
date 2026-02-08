# Quick Fix: Force Azure to Pull Latest Code

The logs show the OLD code is still running. The updated `db.js` with SSL certificate search hasn't been deployed yet.

## Immediate Solution: Manual File Upload

Since Azure auto-deployment isn't working, upload the files manually:

### Step 1: Open Kudu Console
1. Go to: https://skillora-hxcjbsbzd6e4h9c6.scm.azurewebsites.net
2. Click **Debug console** → **CMD**

### Step 2: Navigate to Backend Directory
```bash
cd site/wwwroot/Backend
```

### Step 3: Check Current Files
```bash
dir
```
Look for `DigiCertGlobalRootCA.crt.pem` - if it's missing, that's the problem!

### Step 4: Upload These Files
Drag and drop from your local `Backend` folder:
1. **db.js** (the updated one with certificate search)
2. **DigiCertGlobalRootCA.crt.pem** (SSL certificate)
3. **server.js** (with health endpoint)
4. **routes/healthRoute.js** (new file - create routes folder if needed)

### Step 5: Verify Upload
In Kudu console:
```bash
dir DigiCertGlobalRootCA.crt.pem
type db.js | findstr "findSSLCertificate"
```

Should show the certificate file and the new function.

### Step 6: Restart App
- Go to Azure Portal → Your App Service
- Click **Restart**
- Wait 30 seconds

### Step 7: Check Logs Again
- Azure Portal → Log stream
- Look for: "SSL Certificate found at: ..."
- Should NOT see: "Database connection failed"

## Why Auto-Deploy Isn't Working

Azure needs to be configured to pull from GitHub. To fix this permanently:

1. **Azure Portal** → App Service → **Deployment Center**
2. Check if GitHub is connected
3. If not connected:
   - Click **Settings**
   - Source: GitHub
   - Authorize and select: Monu01123/project
   - Branch: main
   - Save

## Quick Verification

After manual upload and restart, test:
```
https://skillora-hxcjbsbzd6e4h9c6.canadacentral-01.azurewebsites.net/health
```

Should return:
```json
{
  "status": "OK",
  "database": "Connected"
}
```
