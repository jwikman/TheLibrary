#!/bin/bash
set -e

# Setup .NET 8.0 and AL Language development tools
# Usage: ./setup-dotnet-and-al.sh <AL_VERSION>

AL_VERSION="${1:-17.0.28.6483-beta}"

echo "Installing .NET 8.0 SDK..."
SETUP_START=$(date +%s.%N)

# .NET SDK is pre-installed on ubuntu-latest runners
# Just verify it's available
dotnet --version

# Install AL Language development tools
echo "Installing BC Development Tools (version $AL_VERSION)..."
dotnet tool install -g Microsoft.Dynamics.BusinessCentral.Development.Tools.Linux --version "$AL_VERSION"

# Ensure dotnet tools are in PATH
export PATH="$PATH:$HOME/.dotnet/tools"
echo "$HOME/.dotnet/tools" >> "$GITHUB_PATH"

# Verify BC Development Tools installation
echo "Verifying BC Development Tools installation..."
# Test AL command directly (ignore exit code since al --version returns 1)
al --version || true

SETUP_END=$(date +%s.%N)
SETUP_DURATION=$(echo "$SETUP_END - $SETUP_START" | bc -l | sed 's/^\./0./')
echo "Setup (.NET + AL tools + verification) took: $SETUP_DURATION seconds"
