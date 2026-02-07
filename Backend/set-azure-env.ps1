# Set Azure Environment Variables Script
# Run this after logging in with: az login

$appName = "skillora-hxcjbsbzd6e4h9c6"
$resourceGroup = "Ed-Tech_group"  # Replace with your actual resource group name

Write-Host "Setting environment variables for Azure App Service: $appName" -ForegroundColor Cyan
Write-Host "================================================================" -ForegroundColor Cyan

# Check if logged in
Write-Host "`nChecking Azure CLI login status..." -ForegroundColor Yellow
az account show 2>$null
if ($LASTEXITCODE -ne 0) {
    Write-Host "Not logged in to Azure. Please run: az login" -ForegroundColor Red
    exit 1
}

Write-Host "✓ Logged in to Azure" -ForegroundColor Green

# Set environment variables
Write-Host "`nSetting environment variables..." -ForegroundColor Yellow

az webapp config appsettings set `
    --resource-group $resourceGroup `
    --name $appName `
    --settings `
        DB_HOST="skillora.mysql.database.azure.com" `
        DB_USER="monumeena" `
        DB_PASSWORD="Monu8875@" `
        DB_NAME="elearning" `
        JWT_SECRET="ksdjfhkldsjhfkdhf" `
        EMAIL_USER="justryme8875@gmail.com" `
        EMAIL_PASS="yepl usyq ytuc wswg" `
        NODE_ENV="production" `
        STRIPE_SERVER_SECRET_KEY="$env:STRIPE_SERVER_SECRET_KEY" `
        ENDPOINT_SECRET="$env:ENDPOINT_SECRET" `
        CLIENT_URL="https://your-frontend-url.vercel.app"

if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ Environment variables set successfully!" -ForegroundColor Green
    
    Write-Host "`nRestarting app service..." -ForegroundColor Yellow
    az webapp restart --resource-group $resourceGroup --name $appName
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ App service restarted!" -ForegroundColor Green
        Write-Host "`nWait 30 seconds for the app to start, then test:" -ForegroundColor Cyan
        Write-Host "https://$appName.canadacentral-01.azurewebsites.net/health" -ForegroundColor White
    } else {
        Write-Host "✗ Failed to restart app service" -ForegroundColor Red
    }
} else {
    Write-Host "✗ Failed to set environment variables" -ForegroundColor Red
    Write-Host "Please check if the resource group name is correct: $resourceGroup" -ForegroundColor Yellow
}
