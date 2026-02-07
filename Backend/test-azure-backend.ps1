#!/usr/bin/env pwsh
# Azure Backend Health Check Script
# This script tests the Azure backend endpoints to diagnose issues

$BACKEND_URL = "https://skillora-hxcjbsbzd6e4h9c6.canadacentral-01.azurewebsites.net"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Azure Backend Health Check" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Test 1: Check if backend is reachable
Write-Host "[1/4] Testing backend connectivity..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri $BACKEND_URL -Method GET -TimeoutSec 10 -ErrorAction Stop
    Write-Host "✓ Backend is reachable (Status: $($response.StatusCode))" -ForegroundColor Green
} catch {
    Write-Host "✗ Backend is not reachable" -ForegroundColor Red
    Write-Host "  Error: $($_.Exception.Message)" -ForegroundColor Red
}
Write-Host ""

# Test 2: Check /categories endpoint
Write-Host "[2/4] Testing GET /categories..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "$BACKEND_URL/categories" -Method GET -TimeoutSec 10 -ErrorAction Stop
    Write-Host "✓ Categories endpoint working (Status: $($response.StatusCode))" -ForegroundColor Green
    $categories = $response.Content | ConvertFrom-Json
    Write-Host "  Found $($categories.Count) categories" -ForegroundColor Gray
} catch {
    $statusCode = $_.Exception.Response.StatusCode.value__
    Write-Host "✗ Categories endpoint failed (Status: $statusCode)" -ForegroundColor Red
    if ($statusCode -eq 500) {
        Write-Host "  → This is a 500 Internal Server Error" -ForegroundColor Red
        Write-Host "  → Likely cause: Database connection or missing environment variables" -ForegroundColor Yellow
    }
}
Write-Host ""

# Test 3: Check /auth/login endpoint (with invalid credentials to test if it's working)
Write-Host "[3/4] Testing POST /auth/login..." -ForegroundColor Yellow
try {
    $body = @{
        email = "test@example.com"
        password = "testpassword123"
    } | ConvertTo-Json

    $response = Invoke-WebRequest -Uri "$BACKEND_URL/auth/login" -Method POST -Body $body -ContentType "application/json" -TimeoutSec 10 -ErrorAction Stop
    Write-Host "✓ Login endpoint working (Status: $($response.StatusCode))" -ForegroundColor Green
} catch {
    $statusCode = $_.Exception.Response.StatusCode.value__
    if ($statusCode -eq 401) {
        Write-Host "✓ Login endpoint working (Status: 401 - Invalid credentials expected)" -ForegroundColor Green
    } elseif ($statusCode -eq 500) {
        Write-Host "✗ Login endpoint failed (Status: 500)" -ForegroundColor Red
        Write-Host "  → This is a 500 Internal Server Error" -ForegroundColor Red
        Write-Host "  → Likely cause: Database connection or missing environment variables" -ForegroundColor Yellow
    } else {
        Write-Host "✗ Login endpoint failed (Status: $statusCode)" -ForegroundColor Red
    }
}
Write-Host ""

# Test 4: Check Swagger documentation
Write-Host "[4/4] Testing Swagger documentation..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "$BACKEND_URL/api-docs" -Method GET -TimeoutSec 10 -ErrorAction Stop
    Write-Host "✓ Swagger docs accessible (Status: $($response.StatusCode))" -ForegroundColor Green
    Write-Host "  Visit: $BACKEND_URL/api-docs" -ForegroundColor Gray
} catch {
    Write-Host "✗ Swagger docs not accessible" -ForegroundColor Red
}
Write-Host ""

# Summary
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Summary" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "If you see 500 errors above, follow these steps:" -ForegroundColor Yellow
Write-Host "1. Configure environment variables in Azure Portal" -ForegroundColor White
Write-Host "2. Enable 'Allow Azure services' in MySQL firewall" -ForegroundColor White
Write-Host "3. Check Azure App Service logs for detailed errors" -ForegroundColor White
Write-Host ""
Write-Host "See azure_500_error_diagnosis.md for detailed instructions" -ForegroundColor Cyan
