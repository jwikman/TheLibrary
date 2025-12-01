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

.EXAMPLE
    ./setup-bc-container.ps1
    ./setup-bc-container.ps1 -BCDevRepo "https://github.com/StefanMaron/BCDevOnLinux.git" -BCDevBranch "main"
#>

param(
    [string]$BCDevRepo = "https://github.com/StefanMaron/BCDevOnLinux.git",
    [string]$BCDevBranch = "main"
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

# Build BC Container with Docker Compose
Write-Host "Building Business Central container..." -ForegroundColor Yellow
Push-Location bcdev-temp
try {
    docker compose build
}
finally {
    Pop-Location
}

Write-Host "Business Central container setup completed successfully" -ForegroundColor Green
