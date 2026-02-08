# Upload Backend Files to Azure - Quick Guide

## ✅ Deployment Package Ready

**File**: `backend_deploy_20260208_010735.zip` (67 KB)
**Location**: `c:\Users\monum\OneDrive\Desktop\Projects\My Projects\Ed-Tech\Backend\`

---

## 🚀 Upload Steps (3 Minutes)

### Method 1: Kudu Zip Deploy (Recommended - Easiest)

1. **Open this URL** in your browser:
   ```
   https://skillora-hxcjbsbzd6e4h9c6.scm.azurewebsites.net/ZipDeployUI
   ```

2. **Login** with your Azure credentials

3. **Drag and drop** the file: `backend_deploy_20260208_010735.zip`

4. **Wait** for the upload bar to complete (~30 seconds)

5. **Go to Azure Portal** and restart your app:
   - https://portal.azure.com
   - Navigate to `skillora-hxcjbsbzd6e4h9c6`
   - Click **Restart**

6. **Test** (wait 30 seconds after restart):
   ```
   https://skillora-hxcjbsbzd6e4h9c6.canadacentral-01.azurewebsites.net/health
   ```

---

### Method 2: Kudu File Manager (If Method 1 Fails)

1. **Open**: https://skillora-hxcjbsbzd6e4h9c6.scm.azurewebsites.net

2. **Click**: Debug console → CMD

3. **Navigate to**: `site/wwwroot`

4. **Delete all existing files** (if any)

5. **Upload files manually**:
   - Drag `server.js`, `db.js`, `package.json`
   - Drag folders: `routes`, `Controllers`, `middleware`, `services`, `config`, `utils`
   - Drag `DigiCertGlobalRootCA.crt.pem`

6. **Restart** the app from Azure Portal

---

## ✓ What Should Happen

After upload and restart, the logs should show:
```
Server is running on port 8080
Database connection successful
```

And the health endpoint should return JSON with your backend status.

---

## 🔍 Verify Files Were Uploaded

To check if files are present:

1. Go to: https://skillora-hxcjbsbzd6e4h9c6.scm.azurewebsites.net
2. Click: Debug console → CMD
3. Navigate to: `site/wwwroot`
4. You should see: `server.js`, `package.json`, folders, etc.

---

Your deployment package is ready! Use **Method 1** (ZipDeploy) - it's the fastest. 🚀
