# Azure Startup Command Fix

## Problem Identified

Your Azure logs show:
```
node /opt/startup/default-static-site.js
```

**This is the wrong startup command!** Azure is running a default static file server instead of your `server.js` application. That's why your backend code isn't executing.

---

## Solution: Configure Startup Command

You have **two options** to fix this:

### Option 1: Via Azure Portal (Easiest - Recommended)

1. **Go to Azure Portal**: https://portal.azure.com
2. **Navigate to your App Service**: `skillora-hxcjbsbzd6e4h9c6`
3. **Click "Configuration"** in the left sidebar
4. **Click "General settings"** tab
5. **Find "Startup Command"** field
6. **Enter**: `node server.js`
7. **Click "Save"** at the top
8. **Click "Restart"** to apply changes

**That's it!** Your backend should now run correctly.

### Option 2: Include startup.sh in Deployment

I've created a `startup.sh` file. Include it in your next deployment:

1. **Create new deployment ZIP** with the startup script:
   ```powershell
   cd "c:\Users\monum\OneDrive\Desktop\Projects\My Projects\Ed-Tech\Backend"
   $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
   $zipFile = "deploy_with_startup_$timestamp.zip"
   Compress-Archive -Path "*.js","*.json","*.pem","*.crt","*.sh",".deployment","routes","Controllers","middleware","services","config","utils" -DestinationPath $zipFile -Force
   ```

2. **Upload to Kudu**: https://skillora-hxcjbsbzd6e4h9c6.scm.azurewebsites.net/ZipDeployUI

3. **Set startup command in Azure Portal** (still need to do this):
   - Configuration → General settings → Startup Command: `./startup.sh`

---

## Quick Fix (Do This Now)

**Use Option 1** - it's faster and doesn't require redeployment:

1. Open: https://portal.azure.com
2. Go to your app: `skillora-hxcjbsbzd6e4h9c6`
3. Configuration → General settings
4. Startup Command: `node server.js`
5. Save → Restart

**Wait 30 seconds**, then test:
https://skillora-hxcjbsbzd6e4h9c6.canadacentral-01.azurewebsites.net/health

---

## Why This Happened

Azure App Service for Node.js tries to auto-detect your startup command by looking for:
1. `npm start` script in `package.json` ✓ (You have this: `"start": "node server.js"`)
2. `server.js` or `index.js` in root ✓ (You have `server.js`)

However, when it can't determine the correct command, it falls back to the default static site server.

**Setting the startup command explicitly** ensures Azure always runs the correct file.

---

## Verification

After setting the startup command and restarting, your logs should show:
```
Starting Skillora Backend...
Server is running on port 8080
Database connection successful
```

Instead of:
```
node /opt/startup/default-static-site.js  ❌
```
