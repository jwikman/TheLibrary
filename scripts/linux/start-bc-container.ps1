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

        # Also verify the file will be read by docker compose
        Write-Host "`nVerifying docker compose can read .env file:" -ForegroundColor Gray
        docker compose config | Select-String -Pattern "BC_ARTIFACT_URL|SA_PASSWORD" | ForEach-Object {
            $line = $_.Line
            if ($line -match "SA_PASSWORD") {
                Write-Host "  (SA_PASSWORD found in config)" -ForegroundColor Gray
            }
            else {
                Write-Host "  $line" -ForegroundColor Gray
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

    # Check container status
    Write-Host "`nContainer status:" -ForegroundColor Cyan
    docker compose ps
    Write-Host "`nRecent container logs:" -ForegroundColor Cyan
    docker compose logs --tail=20

    # Verify BC version in the container
    Write-Host "`nVerifying Business Central version..." -ForegroundColor Cyan
    try {
        # Method 1: Check the artifact URL that was actually used (from container env)
        $artifactUrlInContainer = docker compose exec -T bc bash -c 'echo $BC_ARTIFACT_URL' 2>$null
        if ($artifactUrlInContainer -and $artifactUrlInContainer.Trim()) {
            Write-Host "✓ BC Artifact URL in container: $($artifactUrlInContainer.Trim())" -ForegroundColor Green

            # Extract version from URL (e.g., sandbox/27.1.41698.42876/w1)
            if ($artifactUrlInContainer -match '/(\d+\.\d+\.\d+\.\d+)/') {
                Write-Host "✓ BC Version from URL: $($matches[1])" -ForegroundColor Green
            }
            elseif ($artifactUrlInContainer -match '/(\d+\.\d+)/') {
                Write-Host "✓ BC Version from URL: $($matches[1])" -ForegroundColor Green
            }
        }
        else {
            Write-Host "⚠ BC_ARTIFACT_URL not set in container" -ForegroundColor Yellow
        }

        # Method 2: Check BC artifacts directory structure for platform version
        $bcPlatformDir = docker compose exec -T bc bash -c "ls -d /home/bcartifacts/platform/ServiceTier/* 2>/dev/null | head -1 | xargs basename" 2>$null
        if ($bcPlatformDir -and $bcPlatformDir.Trim()) {
            Write-Host "✓ BC Platform directory: $($bcPlatformDir.Trim())" -ForegroundColor Green
        }

        # Method 3: Check if BC Server executable exists
        $bcServerExe = docker compose exec -T bc bash -c "find /home/bcartifacts/platform -name 'Microsoft.Dynamics.Nav.Server.exe' -type f 2>/dev/null | head -1" 2>$null
        if ($bcServerExe -and $bcServerExe.Trim()) {
            Write-Host "✓ BC Server executable confirmed" -ForegroundColor Green
        }
        else {
            Write-Host "⚠ BC Server executable not found" -ForegroundColor Yellow
        }
    }
    catch {
        Write-Host "⚠ Could not verify BC version: $_" -ForegroundColor Yellow
    }

}
finally {
    Pop-Location
}

Write-Host "`n✓ BC container started successfully" -ForegroundColor Green
