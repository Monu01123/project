# Deploy Backend to Azure with SSL Certificate
# This script ensures the SSL certificate is deployed

$appName = "skillora-hxcjbsbzd6e4h9c6"
$resourceGroup = "Ed-Tech_group"  # Update if different

Write-Host "Deploying Backend to Azure..." -ForegroundColor Cyan
Write-Host "==============================" -ForegroundColor Cyan

# Check if SSL certificate exists
$certPath = "DigiCertGlobalRootCA.crt.pem"
if (-not (Test-Path $certPath)) {
    Write-Host "ERROR: SSL certificate not found: $certPath" -ForegroundColor Red
    Write-Host "Please ensure DigiCertGlobalRootCA.crt.pem is in the Backend directory" -ForegroundColor Yellow
    exit 1
}

Write-Host "SSL certificate found" -ForegroundColor Green

# Check Azure CLI login
Write-Host "`nChecking Azure CLI login..." -ForegroundColor Yellow
az account show 2>$null
if ($LASTEXITCODE -ne 0) {
    Write-Host "Not logged in. Running az login..." -ForegroundColor Yellow
    az login
}

Write-Host "Logged in to Azure" -ForegroundColor Green

# Create a zip file for deployment
Write-Host "`nCreating deployment package..." -ForegroundColor Yellow
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$zipFile = "deploy_$timestamp.zip"

# Files to include
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

# Create zip (requires PowerShell 5.0+)
Compress-Archive -Path $filesToInclude -DestinationPath $zipFile -Force

Write-Host "Created deployment package: $zipFile" -ForegroundColor Green

# Deploy to Azure
Write-Host "`nDeploying to Azure App Service..." -ForegroundColor Yellow
az webapp deployment source config-zip `
    --resource-group $resourceGroup `
    --name $appName `
    --src $zipFile

if ($LASTEXITCODE -eq 0) {
    Write-Host "Deployment successful!" -ForegroundColor Green
    
    # Clean up zip file
    Remove-Item $zipFile
    
    Write-Host "`nRestarting app service..." -ForegroundColor Yellow
    az webapp restart --resource-group $resourceGroup --name $appName
    
    Write-Host "`nDeployment complete!" -ForegroundColor Green
    Write-Host "`nWait 30-60 seconds, then test:" -ForegroundColor Cyan
    Write-Host "https://$appName.canadacentral-01.azurewebsites.net/health" -ForegroundColor White
    
    Write-Host "`nTo view logs, run:" -ForegroundColor Cyan
    Write-Host "az webapp log tail --resource-group $resourceGroup --name $appName" -ForegroundColor White
} else {
    Write-Host "Deployment failed" -ForegroundColor Red
    Remove-Item $zipFile -ErrorAction SilentlyContinue
}
