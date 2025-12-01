#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Setup Business Central container using BCDevOnLinux

.DESCRIPTION
    Clones BCDevOnLinux repository and builds the BC container using Docker Compose

.PARAMETER BCDevRepo
    BCDevOnLinux repository URL (default: https://github.com/StefanMaron/BCDevOnLinux.git)

.PARAMETER BCDevBranch
    BCDevOnLinux repository branch (default: main)

.PARAMETER BCArtifactUrl
    BC Artifact URL to use for the container (mandatory)

.EXAMPLE
    ./setup-bc-container.ps1
    ./setup-bc-container.ps1 -BCDevRepo "https://github.com/StefanMaron/BCDevOnLinux.git" -BCDevBranch "main"
    ./setup-bc-container.ps1 -BCArtifactUrl "https://bcartifacts.azureedge.net/sandbox/27.1/w1"
#>

param(
    [Parameter(Mandatory = $false)]
    [string]$BCDevRepo = "https://github.com/StefanMaron/BCDevOnLinux.git",
    [Parameter(Mandatory = $false)]
    [string]$BCDevBranch = "main",
    [Parameter(Mandatory = $true)]
    [string]$BCArtifactUrl
)

$ErrorActionPreference = "Stop"

Write-Host "=== Setting up Business Central Container ===" -ForegroundColor Cyan

# Verify Docker is available
Write-Host "Verifying Docker installation..." -ForegroundColor Yellow
docker --version
docker compose version

# Clone BCDevOnLinux repository
Write-Host "Cloning BCDevOnLinux repository..." -ForegroundColor Yellow
git clone --branch $BCDevBranch --depth 1 $BCDevRepo bcdev-temp

# Pull BC Wine Base Image
Write-Host "Pulling BC Wine base image..." -ForegroundColor Yellow
docker pull stefanmaronbc/bc-wine-base:latest

# Clean up any existing BC artifacts volume to force fresh download
Write-Host "Cleaning up any existing BC artifacts volume..." -ForegroundColor Yellow
docker volume rm bcdev-temp_bc_artifacts -f 2>$null
Write-Host "✓ BC artifacts volume removed (will be recreated fresh)" -ForegroundColor Green

# Build BC Container with Docker Compose
Write-Host "Building Business Central container..." -ForegroundColor Yellow
Push-Location bcdev-temp
try {
    # Create .env file with BC configuration
    $envContent = @()

    if ($BCArtifactUrl) {
        Write-Host "Using BC Artifact URL: $BCArtifactUrl" -ForegroundColor Cyan
        $envContent += "BC_ARTIFACT_URL=$BCArtifactUrl"
    }
    else {
        Write-Host "No BC artifact URL specified - using BCDevOnLinux defaults" -ForegroundColor Yellow
    }

    # Add SA_PASSWORD from environment if available
    if ($env:SA_PASSWORD) {
        Write-Host "Setting SQL SA password from environment" -ForegroundColor Gray
        $envContent += "SA_PASSWORD=$env:SA_PASSWORD"
    }

    if ($envContent.Count -gt 0) {
        # Remove any existing .env files to ensure clean state
        if (Test-Path ".env") {
            Remove-Item ".env" -Force
            Write-Host "Removed existing .env file" -ForegroundColor Gray
        }
        if (Test-Path ".env.example") {
            Remove-Item ".env.example" -Force
            Write-Host "Removed .env.example file" -ForegroundColor Gray
        }

        # Write .env file using Set-Content for better cross-platform compatibility
        Set-Content -Path ".env" -Value $envContent -Encoding utf8NoBOM -Force
        Write-Host "Created .env file with configuration:" -ForegroundColor Cyan
        foreach ($line in $envContent) {
            # Mask password in output
            if ($line -match "^SA_PASSWORD=") {
                Write-Host "  SA_PASSWORD=********" -ForegroundColor Gray
            }
            else {
                Write-Host "  $line" -ForegroundColor Gray
            }
        }
    }

    # Build with environment variables explicitly passed to ensure they're available during build
    # The --build-arg approach ensures BC_ARTIFACT_URL reaches the cache-artifacts.ps1 script
    Write-Host "Building container with BC_ARTIFACT_URL environment variable..." -ForegroundColor Yellow

    $buildEnv = @{}
    if ($BCArtifactUrl) {
        $buildEnv['BC_ARTIFACT_URL'] = $BCArtifactUrl
    }
    if ($env:SA_PASSWORD) {
        $buildEnv['SA_PASSWORD'] = $env:SA_PASSWORD
    }

    # Set environment variables for the build process
    foreach ($key in $buildEnv.Keys) {
        [Environment]::SetEnvironmentVariable($key, $buildEnv[$key], [EnvironmentVariableTarget]::Process)
    }

    # CRITICAL FIX: BCDevOnLinux's compose.yml doesn't include BC_ARTIFACT_URL in the bc service environment
    # We need to add it so cache-artifacts.ps1 can read it at runtime
    if ($BCArtifactUrl -and (Test-Path "compose.yml")) {
        Write-Host "Modifying compose.yml to add BC_ARTIFACT_URL to bc service environment..." -ForegroundColor Yellow

        $composeContent = Get-Content "compose.yml" -Raw

        # Find the bc service environment section and add BC_ARTIFACT_URL
        # The environment section for bc service currently has:
        #   environment:
        #     - SA_PASSWORD=${SA_PASSWORD:-P@ssw0rd123!}
        #     - SQL_SERVER=sql
        #     ...

        # We'll add BC_ARTIFACT_URL after SA_PASSWORD
        $pattern = '(environment:\s+- SA_PASSWORD=\$\{SA_PASSWORD:-P@ssw0rd123!\})'
        $replacement = "`$1`n      - BC_ARTIFACT_URL=`${BC_ARTIFACT_URL}"

        $modifiedContent = $composeContent -replace $pattern, $replacement

        if ($modifiedContent -ne $composeContent) {
            Set-Content -Path "compose.yml" -Value $modifiedContent -Encoding utf8NoBOM -Force
            Write-Host "✓ Added BC_ARTIFACT_URL to compose.yml bc service environment" -ForegroundColor Green
        }
        else {
            Write-Host "⚠ Could not modify compose.yml - pattern not found" -ForegroundColor Yellow
            Write-Host "BC_ARTIFACT_URL may not be passed to container" -ForegroundColor Yellow
        }
    }

    docker compose build
}
finally {
    Pop-Location
}

Write-Host "Business Central container setup completed successfully" -ForegroundColor Green
