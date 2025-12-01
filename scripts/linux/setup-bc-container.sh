#!/bin/bash
set -e

# Setup Business Central container using BCDevOnLinux
# Usage: ./setup-bc-container.sh <BCDEV_REPO> <BCDEV_BRANCH>

BCDEV_REPO="${1:-https://github.com/StefanMaron/BCDevOnLinux.git}"
BCDEV_BRANCH="${2:-main}"

echo "=== Setting up Business Central Container ==="

# Verify Docker is available
echo "Verifying Docker installation..."
docker --version
docker compose version

# Clone BCDevOnLinux repository
echo "Cloning BCDevOnLinux repository..."
git clone --branch "$BCDEV_BRANCH" --depth 1 "$BCDEV_REPO" bcdev-temp

# Pull BC Wine Base Image
echo "Pulling BC Wine base image..."
docker pull stefanmaronbc/bc-wine-base:latest

# Build BC Container with Docker Compose
echo "Building Business Central container..."
cd bcdev-temp
docker compose build
cd ..
