# Create Manual Deployment ZIP for Azure
# Use this when Azure CLI authentication isn't working

Write-Host "Creating Manual Deployment Package" -ForegroundColor Cyan
Write-Host "===================================" -ForegroundColor Cyan

$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$zipFile = "manual_deploy_$timestamp.zip"

Write-Host "`nPackaging files..." -ForegroundColor Yellow

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

Write-Host "`n✓ Created: $zipFile" -ForegroundColor Green

Write-Host "`n" -NoNewline
Write-Host "NEXT STEPS:" -ForegroundColor Cyan
Write-Host "===========" -ForegroundColor Cyan

Write-Host "`n1. Open this URL in your browser:" -ForegroundColor Yellow
Write-Host "   https://skillora-hxcjbsbzd6e4h9c6.scm.azurewebsites.net/ZipDeployUI" -ForegroundColor White

Write-Host "`n2. Login with your Azure credentials" -ForegroundColor Yellow

Write-Host "`n3. Drag and drop this file:" -ForegroundColor Yellow
Write-Host "   $zipFile" -ForegroundColor White

Write-Host "`n4. Wait for deployment to complete" -ForegroundColor Yellow

Write-Host "`n5. Go to Azure Portal and restart your app:" -ForegroundColor Yellow
Write-Host "   https://portal.azure.com" -ForegroundColor White

Write-Host "`n6. Test your backend:" -ForegroundColor Yellow
Write-Host "   https://skillora-hxcjbsbzd6e4h9c6.canadacentral-01.azurewebsites.net/health" -ForegroundColor White

Write-Host "`n" -NoNewline
Write-Host "The ZIP file is ready in the current directory!" -ForegroundColor Green
