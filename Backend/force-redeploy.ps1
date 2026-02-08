# Force a clean redeployment to Azure
# This script stops the app, clears cache, and redeploys

$appName = "skillora-hxcjbsbzd6e4h9c6"
$resourceGroup = "Ed-Tech_group"

Write-Host "Force Redeployment to Azure" -ForegroundColor Cyan
Write-Host "============================" -ForegroundColor Cyan

# Step 1: Stop the app
Write-Host "`n1. Stopping app service..." -ForegroundColor Yellow
az webapp stop --resource-group $resourceGroup --name $appName

# Step 2: Clear deployment cache
Write-Host "`n2. Clearing deployment cache..." -ForegroundColor Yellow
az webapp deployment source delete --resource-group $resourceGroup --name $appName

# Step 3: Create fresh deployment package
Write-Host "`n3. Creating fresh deployment package..." -ForegroundColor Yellow
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$zipFile = "deploy_$timestamp.zip"

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

# Step 4: Deploy
Write-Host "`n4. Deploying to Azure..." -ForegroundColor Yellow
az webapp deployment source config-zip `
    --resource-group $resourceGroup `
    --name $appName `
    --src $zipFile

if ($LASTEXITCODE -eq 0) {
    Write-Host "Deployment successful!" -ForegroundColor Green
    Remove-Item $zipFile
    
    # Step 5: Start the app
    Write-Host "`n5. Starting app service..." -ForegroundColor Yellow
    az webapp start --resource-group $resourceGroup --name $appName
    
    # Step 6: Restart to ensure fresh start
    Write-Host "`n6. Restarting for fresh start..." -ForegroundColor Yellow
    Start-Sleep -Seconds 5
    az webapp restart --resource-group $resourceGroup --name $appName
    
    Write-Host "`n✓ Force redeployment complete!" -ForegroundColor Green
    Write-Host "`nWait 60 seconds, then test:" -ForegroundColor Cyan
    Write-Host "https://$appName.canadacentral-01.azurewebsites.net/health" -ForegroundColor White
    
    Write-Host "`nTo view live logs:" -ForegroundColor Cyan
    Write-Host "az webapp log tail --resource-group $resourceGroup --name $appName" -ForegroundColor White
} else {
    Write-Host "Deployment failed!" -ForegroundColor Red
    Remove-Item $zipFile -ErrorAction SilentlyContinue
    
    # Start the app anyway
    az webapp start --resource-group $resourceGroup --name $appName
}
