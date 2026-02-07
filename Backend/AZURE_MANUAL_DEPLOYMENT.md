# Manual Azure Deployment Steps

Since Azure hasn't automatically deployed the latest changes, you need to manually trigger the deployment.

## Option 1: Restart App Service (Quickest)

1. Go to [Azure Portal](https://portal.azure.com)
2. Navigate to your App Service: `skillora-hxcjbsbzd6e4h9c6`
3. Click **Restart** at the top
4. Wait 2-3 minutes for the app to restart

> **Note:** This will only work if Azure has already pulled the code but hasn't restarted.

## Option 2: Redeploy from Deployment Center (Recommended)

1. Go to [Azure Portal](https://portal.azure.com)
2. Navigate to your App Service: `skillora-hxcjbsbzd6e4h9c6`
3. Click **Deployment Center** in the left sidebar
4. Look for the deployment source (GitHub, Local Git, etc.)
5. Click **Sync** or **Redeploy** to pull latest changes from GitHub
6. Wait for deployment to complete (2-5 minutes)

## Option 3: Manual File Upload via FTP/FTPS

If the above don't work, you can manually upload the files:

1. Go to Azure Portal → App Service → **Deployment Center**
2. Click on **FTPS credentials** tab
3. Note the FTP hostname, username, and password
4. Use an FTP client (FileZilla, WinSCP) to upload:
   - `Backend/db.js`
   - `Backend/DigiCertGlobalRootCA.crt.pem`
5. Restart the App Service

## Option 4: Use Azure App Service Extension in VS Code

1. Install "Azure App Service" extension in VS Code
2. Sign in to Azure
3. Right-click on your app service
4. Select **Deploy to Web App**
5. Select the `Backend` folder

## Verify Deployment

After deployment, check the logs:

1. Azure Portal → App Service → **Log stream**
2. Look for:
   ```
   ✅ Database connection successful.
   ```

## Why Didn't It Auto-Deploy?

Azure auto-deployment requires:
- Deployment Center configured with GitHub
- GitHub Actions workflow OR Azure's built-in CI/CD
- Proper repository permissions

Check: Azure Portal → Deployment Center → ensure GitHub is connected and deployment is enabled.
