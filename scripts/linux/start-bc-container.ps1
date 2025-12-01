#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Start Business Central container and wait for it to become healthy

.DESCRIPTION
    Starts the BC container using Docker Compose and monitors its health status

.PARAMETER MaxWaitSeconds
    Maximum time to wait for container to become healthy in seconds (default: 1200 = 20 minutes)

.EXAMPLE
    ./start-bc-container.ps1
    ./start-bc-container.ps1 -MaxWaitSeconds 1200
#>

param(
    [int]$MaxWaitSeconds = 1200
)

$ErrorActionPreference = "Stop"

Write-Host "Starting Business Central container..." -ForegroundColor Cyan
Push-Location bcdev-temp

try {
    # Verify .env file exists before starting
    if (Test-Path ".env") {
        Write-Host "✓ .env file found in bcdev-temp directory" -ForegroundColor Green
        Write-Host "Contents:" -ForegroundColor Gray
        Get-Content ".env" | ForEach-Object {
            # Mask password in output
            if ($_ -match "^SA_PASSWORD=") {
                Write-Host "  SA_PASSWORD=********" -ForegroundColor Gray
            }
            else {
                Write-Host "  $_" -ForegroundColor Gray
            }
        }
    }
    else {
        Write-Host "⚠ Warning: .env file not found in bcdev-temp directory!" -ForegroundColor Yellow
        Write-Host "Environment variables may not be set correctly" -ForegroundColor Yellow
    }

    # Start the container
    docker compose up -d

    # Wait for container to become healthy (can take up to 10 minutes)
    Write-Host "Waiting for BC container to become healthy (this can take up to 10 minutes)..." -ForegroundColor Yellow
    $containerName = (docker compose ps -q | Select-Object -First 1)
    $elapsed = 0
    $healthStatus = ""
    $prevHealthStatus = ""

    while ($elapsed -lt $MaxWaitSeconds) {
        try {
            $healthStatus = docker inspect --format='{{.State.Health.Status}}' $containerName 2>$null
            if (-not $healthStatus) { $healthStatus = "unknown" }
        }
        catch {
            $healthStatus = "unknown"
        }

        if ($healthStatus -eq "healthy") {
            Write-Host "✓ BC container is healthy and ready" -ForegroundColor Green
            break
        }

        # Check if container became unhealthy (was starting, now unhealthy)
        if ($healthStatus -eq "unhealthy" -and $prevHealthStatus -ne "unhealthy") {
            Write-Host "⚠ Container became unhealthy - printing logs for investigation:" -ForegroundColor Yellow
            docker compose ps
            docker compose logs --tail=100
        }

        Write-Host "Container status: $healthStatus (waited ${elapsed}s / ${MaxWaitSeconds}s)" -ForegroundColor Gray
        $prevHealthStatus = $healthStatus
        Start-Sleep -Seconds 10
        $elapsed += 10
    }

    # Final health check after loop completes (in case timeout was reached while healthy)
    try {
        $healthStatus = docker inspect --format='{{.State.Health.Status}}' $containerName 2>$null
        if (-not $healthStatus) { $healthStatus = "unknown" }
    }
    catch {
        $healthStatus = "unknown"
    }

    if ($healthStatus -ne "healthy") {
        Write-Host "ERROR: Container did not become healthy within $MaxWaitSeconds seconds" -ForegroundColor Red
        Write-Host "Final status: $healthStatus" -ForegroundColor Red
        Write-Host "Printing full container logs:" -ForegroundColor Yellow
        docker compose ps
        docker compose logs
        exit 1
    }

    # Verify BC version in the container
    Write-Host "`nVerifying Business Central version..." -ForegroundColor Cyan
    try {
        # Try to get BC version from the container
        # BCDevOnLinux stores version info in various locations - try multiple approaches

        # Method 1: Check BC artifacts directory structure
        $bcVersionCheck = docker compose exec -T bc bash -c "ls -d /home/bcartifacts/platform/ServiceTier/* 2>/dev/null | head -1 | xargs basename" 2>$null

        if ($bcVersionCheck -and $bcVersionCheck.Trim()) {
            Write-Host "✓ BC Platform Version: $($bcVersionCheck.Trim())" -ForegroundColor Green
        }

        # Method 2: Check the artifact URL that was actually used (from container env)
        $artifactUrlInContainer = docker compose exec -T bc bash -c "echo `$BC_ARTIFACT_URL" 2>$null
        if ($artifactUrlInContainer -and $artifactUrlInContainer.Trim()) {
            Write-Host "✓ BC Artifact URL used: $($artifactUrlInContainer.Trim())" -ForegroundColor Green
        }

        # Method 3: Check BC Server executable and extract version
        $bcServerExe = docker compose exec -T bc bash -c "find /home/bcartifacts -name 'Microsoft.Dynamics.Nav.Server.exe' 2>/dev/null | head -1" 2>$null
        if ($bcServerExe -and $bcServerExe.Trim()) {
            $exePath = $bcServerExe.Trim()
            Write-Host "✓ BC Server executable found at: $exePath" -ForegroundColor Green

            # Extract version info from the executable using exiftool or wine's built-in version reader
            $versionInfo = docker compose exec -T bc bash -c "wine --version 2>/dev/null && exiftool '$exePath' 2>/dev/null | grep -E 'Product Version|File Version' || wine cmd /c ver '$exePath' 2>/dev/null" 2>$null

            # Alternative: Use PowerShell inside Wine to get file version
            if (-not $versionInfo -or $versionInfo -notmatch '\d+\.\d+') {
                $versionInfo = docker compose exec -T bc pwsh -c "(Get-Item '$exePath').VersionInfo.FileVersion" 2>$null
            }

            if ($versionInfo -and $versionInfo.Trim() -match '\d+\.\d+') {
                Write-Host "✓ BC Server Version: $($versionInfo.Trim())" -ForegroundColor Green
            }
        }
        else {
            Write-Host "⚠ BC Server executable not found in artifacts" -ForegroundColor Yellow
        }
    }
    catch {
        Write-Host "⚠ Could not verify BC version (container may still be initializing)" -ForegroundColor Yellow
    }

    # Check container status
    Write-Host "`nContainer status:" -ForegroundColor Cyan
    docker compose ps
    Write-Host "`nRecent container logs:" -ForegroundColor Cyan
    docker compose logs --tail=20
}
finally {
    Pop-Location
}

Write-Host "`n✓ BC container started successfully" -ForegroundColor Green
