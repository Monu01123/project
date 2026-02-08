# Azure Authentication & Deployment Fix

## Problem Identified
Your Azure CLI login is failing with:
1. **MFA Error**: Multi-factor authentication required
2. **No Subscriptions Found**: Account `monumeena0112@gmail.com` has no subscriptions

## Root Cause
The Azure account you're logging in with (`monumeena0112@gmail.com`) doesn't have access to the subscription where your app `skillora-hxcjbsbzd6e4h9c6` is deployed.

---

## Solutions

### Solution 1: Login with Correct Account (Most Likely)

You may have created the Azure resources with a **different Microsoft account**. 

**Try these steps:**

1. **Check which account owns the resource:**
   - Go to https://portal.azure.com
   - Login with the account you used to create the app
   - Look for your app: `skillora-hxcjbsbzd6e4h9c6`

2. **Login with device code (handles MFA better):**
   ```powershell
   az login --use-device-code
   ```
   This will give you a code to enter at https://microsoft.com/devicelogin

3. **List your subscriptions:**
   ```powershell
   az account list --output table
   ```

4. **If you have multiple accounts, try each one:**
   ```powershell
   az logout
   az login --use-device-code
   ```

### Solution 2: Use Azure Portal Deployment (Works Immediately)

Since authentication is problematic, deploy directly through the portal:

#### Option A: Kudu Console (Fastest)

1. Go to: https://skillora-hxcjbsbzd6e4h9c6.scm.azurewebsites.net
2. Login with your Azure credentials
3. Click **Debug console** → **CMD**
4. Navigate to `site/wwwroot`
5. Delete old files
6. Drag and drop your updated files:
   - All `.js` files
   - `routes/`, `Controllers/`, `middleware/`, `services/`, `config/`, `utils/` folders
   - `DigiCertGlobalRootCA.crt.pem`
   - `package.json`
7. Go to Azure Portal → App Service → Click **Restart**

#### Option B: Deployment Center

1. Go to Azure Portal: https://portal.azure.com
2. Navigate to your App Service: `skillora-hxcjbsbzd6e4h9c6`
3. Click **Deployment Center** in left sidebar
4. Choose **Local Git** or **GitHub** as source
5. Follow the setup instructions
6. Push your code using Git

### Solution 3: Create Deployment Package Manually

If you can access the portal but not CLI:

1. **Create a ZIP file** of your Backend folder (exclude `node_modules`)
2. Go to: https://skillora-hxcjbsbzd6e4h9c6.scm.azurewebsites.net/ZipDeployUI
3. Drag and drop the ZIP file
4. Wait for deployment to complete
5. Restart the app

---

## Quick Manual Deployment Script

Since Azure CLI isn't working, here's a PowerShell script to create a deployment ZIP:

```powershell
# Create deployment package
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$zipFile = "manual_deploy_$timestamp.zip"

$filesToInclude = @(
    "*.js",
    "*.json",
    "*.pem",
    "*.crt",
    ".deployment",
    "routes",
    "Controllers",
    "middleware",
    "services",
    "config",
    "utils"
)

Compress-Archive -Path $filesToInclude -DestinationPath $zipFile -Force

Write-Host "Created: $zipFile" -ForegroundColor Green
Write-Host "`nUpload this file to:" -ForegroundColor Cyan
Write-Host "https://skillora-hxcjbsbzd6e4h9c6.scm.azurewebsites.net/ZipDeployUI" -ForegroundColor White
```

---

## Recommended Immediate Action

**Use Kudu Console (Option A above)** - This is the fastest way to get your updated code deployed right now without dealing with authentication issues.

1. Open: https://skillora-hxcjbsbzd6e4h9c6.scm.azurewebsites.net
2. Upload your files
3. Restart the app
4. Test: https://skillora-hxcjbsbzd6e4h9c6.canadacentral-01.azurewebsites.net/health

Then you can fix the Azure CLI authentication later for automated deployments.
