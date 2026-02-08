# Create Deployment Package with Startup Script
# This includes the startup.sh file

Write-Host "Creating Deployment Package with Startup Configuration" -ForegroundColor Cyan
Write-Host "======================================================" -ForegroundColor Cyan

$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$zipFile = "deploy_with_startup_$timestamp.zip"

Write-Host "`nPackaging files..." -ForegroundColor Yellow

$filesToInclude = @(
    "*.js",
    "*.json",
    "*.pem",
    "*.crt",
    "*.sh",
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
Write-Host "IMPORTANT: Configure Startup Command in Azure Portal" -ForegroundColor Yellow
Write-Host "====================================================" -ForegroundColor Yellow

Write-Host "`n1. Go to Azure Portal:" -ForegroundColor Cyan
Write-Host "   https://portal.azure.com" -ForegroundColor White

Write-Host "`n2. Navigate to your App Service:" -ForegroundColor Cyan
Write-Host "   skillora-hxcjbsbzd6e4h9c6" -ForegroundColor White

Write-Host "`n3. Click 'Configuration' → 'General settings'" -ForegroundColor Cyan

Write-Host "`n4. Set Startup Command to:" -ForegroundColor Cyan
Write-Host "   node server.js" -ForegroundColor White

Write-Host "`n5. Click 'Save' then 'Restart'" -ForegroundColor Cyan

Write-Host "`n6. Upload this ZIP file to:" -ForegroundColor Cyan
Write-Host "   https://skillora-hxcjbsbzd6e4h9c6.scm.azurewebsites.net/ZipDeployUI" -ForegroundColor White

Write-Host "`n7. Test your backend:" -ForegroundColor Cyan
Write-Host "   https://skillora-hxcjbsbzd6e4h9c6.canadacentral-01.azurewebsites.net/health" -ForegroundColor White

Write-Host "`n" -NoNewline
Write-Host "Deployment package ready!" -ForegroundColor Green
