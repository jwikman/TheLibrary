#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Publish AL apps to BC container via API

.DESCRIPTION
    Publishes the main app and test app to a Business Central container using the Development API

.PARAMETER BaseUrl
    Base URL of the BC container (default: http://localhost:7049/BC)

.PARAMETER Username
    Username for authentication (required)

.EXAMPLE
    $env:BC_PASSWORD = "Admin123!"
    ./publish-apps-to-container.ps1 -Username "admin"

.EXAMPLE
    $env:BC_PASSWORD = "Admin123!"
    ./publish-apps-to-container.ps1 -BaseUrl "http://localhost:7049/BC" -Username "admin"

.NOTES
    Requires environment variable:
    - BC_PASSWORD: Business Central admin user password
#>

param(
    [string]$BaseUrl = "http://localhost:7049/BC",

    [Parameter(Mandatory = $true)]
    [string]$Username
)

$ErrorActionPreference = "Stop"

# Get password from environment variable
if (-not $env:BC_PASSWORD) {
    Write-Host "ERROR: BC_PASSWORD environment variable not set" -ForegroundColor Red
    Write-Host "Set it with: `$env:BC_PASSWORD = 'YourPassword'" -ForegroundColor Yellow
    exit 1
}
$Password = $env:BC_PASSWORD

Write-Host "=== Publishing Apps to BC Container ===" -ForegroundColor Cyan

# Create Basic auth header
$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes("${Username}:${Password}"))
$Headers = @{
    "Authorization" = "Basic $base64AuthInfo"
}

# Publish Main App
Write-Host "Publishing The Library (main app) to BC container..." -ForegroundColor Yellow

# Find the main app file
$appFile = Get-ChildItem -Path "./App" -Filter "*.app" -File -Depth 0 | Select-Object -First 1
if (-not $appFile) {
    Write-Host "ERROR: No main app file found for publishing" -ForegroundColor Red
    exit 1
}

Write-Host "Publishing app file: $($appFile.FullName)" -ForegroundColor Gray

# Publish extension to BC container using API (using multipart/form-data like curl -F)
$uri = "$BaseUrl/dev/apps?tenant=default&SchemaUpdateMode=synchronize&DependencyPublishingOption=default"

# Read file content
$fileBytes = [System.IO.File]::ReadAllBytes($appFile.FullName)
$boundary = [System.Guid]::NewGuid().ToString()

# Create multipart/form-data body
$LF = "`r`n"
$bodyLines = (
    "--$boundary",
    "Content-Disposition: form-data; name=`"file`"; filename=`"$($appFile.Name)`"",
    "Content-Type: application/octet-stream$LF",
    [System.Text.Encoding]::GetEncoding("ISO-8859-1").GetString($fileBytes),
    "--$boundary--$LF"
) -join $LF

$response = Invoke-WebRequest -Uri $uri -Method Post -Headers $Headers `
    -Body $bodyLines -ContentType "multipart/form-data; boundary=$boundary" `
    -UseBasicParsing -AllowUnencryptedAuthentication

if ($response.StatusCode -ne 200 -and $response.StatusCode -ne 204) {
    Write-Host "ERROR: Failed to publish main app. Status: $($response.StatusCode)" -ForegroundColor Red
    exit 1
}

# Publish Test App
Write-Host "Publishing The Library Tester (test app) to BC container..." -ForegroundColor Yellow

# Find the test app file (excluding .dep.app files)
$testAppFile = Get-ChildItem -Path "./TestApp" -Filter "*.app" -File -Depth 0 |
    Where-Object { $_.Name -notlike "*.dep.app" } |
    Select-Object -First 1

if (-not $testAppFile) {
    Write-Host "ERROR: No test app file found for publishing" -ForegroundColor Red
    exit 1
}

Write-Host "Publishing test app file: $($testAppFile.FullName)" -ForegroundColor Gray

# Publish extension to BC container using API (using multipart/form-data like curl -F)
# Read file content
$fileBytes = [System.IO.File]::ReadAllBytes($testAppFile.FullName)
$boundary = [System.Guid]::NewGuid().ToString()

# Create multipart/form-data body
$LF = "`r`n"
$bodyLines = (
    "--$boundary",
    "Content-Disposition: form-data; name=`"file`"; filename=`"$($testAppFile.Name)`"",
    "Content-Type: application/octet-stream$LF",
    [System.Text.Encoding]::GetEncoding("ISO-8859-1").GetString($fileBytes),
    "--$boundary--$LF"
) -join $LF

$response = Invoke-WebRequest -Uri $uri -Method Post -Headers $Headers `
    -Body $bodyLines -ContentType "multipart/form-data; boundary=$boundary" `
    -UseBasicParsing -AllowUnencryptedAuthentication

if ($response.StatusCode -ne 200 -and $response.StatusCode -ne 204) {
    Write-Host "ERROR: Failed to publish test app. Status: $($response.StatusCode)" -ForegroundColor Red
    exit 1
}

Write-Host "✓ All apps published successfully" -ForegroundColor Green
