# Test Azure Backend Endpoints
$baseUrl = "https://skillora-hxcjbsbzd6e4h9c6.canadacentral-01.azurewebsites.net"

Write-Host "Testing Azure Backend Endpoints..." -ForegroundColor Cyan
Write-Host "=================================" -ForegroundColor Cyan

# Test 1: Health Check (root endpoint)
Write-Host "`n1. Testing root endpoint..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "$baseUrl/" -Method GET -ErrorAction Stop
    Write-Host "✓ Root endpoint responded: $($response.StatusCode)" -ForegroundColor Green
    Write-Host "Response: $($response.Content)" -ForegroundColor Gray
} catch {
    Write-Host "✗ Root endpoint failed: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "Status Code: $($_.Exception.Response.StatusCode.value__)" -ForegroundColor Red
}

# Test 2: Categories endpoint
Write-Host "`n2. Testing /categories endpoint..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "$baseUrl/categories" -Method GET -ErrorAction Stop
    Write-Host "✓ Categories endpoint responded: $($response.StatusCode)" -ForegroundColor Green
    $categories = $response.Content | ConvertFrom-Json
    Write-Host "Found $($categories.Count) categories" -ForegroundColor Gray
} catch {
    Write-Host "✗ Categories endpoint failed: $($_.Exception.Message)" -ForegroundColor Red
    if ($_.Exception.Response) {
        $statusCode = $_.Exception.Response.StatusCode.value__
        Write-Host "Status Code: $statusCode" -ForegroundColor Red
        
        # Try to read error response
        $reader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
        $errorBody = $reader.ReadToEnd()
        Write-Host "Error Response: $errorBody" -ForegroundColor Red
    }
}

# Test 3: Login endpoint
Write-Host "`n3. Testing /auth/login endpoint..." -ForegroundColor Yellow
$loginData = @{
    email = "test@example.com"
    password = "testpassword123"
} | ConvertTo-Json

try {
    $response = Invoke-WebRequest -Uri "$baseUrl/auth/login" -Method POST -Body $loginData -ContentType "application/json" -ErrorAction Stop
    Write-Host "✓ Login endpoint responded: $($response.StatusCode)" -ForegroundColor Green
} catch {
    Write-Host "✗ Login endpoint failed: $($_.Exception.Message)" -ForegroundColor Red
    if ($_.Exception.Response) {
        $statusCode = $_.Exception.Response.StatusCode.value__
        Write-Host "Status Code: $statusCode" -ForegroundColor Red
        
        # Try to read error response
        $reader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
        $errorBody = $reader.ReadToEnd()
        Write-Host "Error Response: $errorBody" -ForegroundColor Red
    }
}

# Test 4: Swagger docs
Write-Host "`n4. Testing /api-docs endpoint..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "$baseUrl/api-docs" -Method GET -ErrorAction Stop
    Write-Host "✓ Swagger docs available: $($response.StatusCode)" -ForegroundColor Green
} catch {
    Write-Host "✗ Swagger docs failed: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n=================================" -ForegroundColor Cyan
Write-Host "Test completed!" -ForegroundColor Cyan
