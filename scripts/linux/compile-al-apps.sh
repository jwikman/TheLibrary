#!/bin/bash
set -e

# Compile AL application (App or TestApp)
# Usage: ./compile-al-apps.sh [project_path]
# If no project_path is provided, compiles both App and TestApp in order

PROJECT_PATH="${1}"

if [ -z "$PROJECT_PATH" ]; then
    # No project specified - compile both in order
    echo "=== Compiling All AL Applications ==="

    # Compile Main App
    echo "Compiling The Library (main App)..."
    al compile /project:"./App" /packagecachepath:".alpackages"

    # Copy compiled main app to .alpackages so TestApp can reference it
    echo "Copying compiled main app to .alpackages..."
    find ./App -maxdepth 1 -name "*.app" -type f -exec cp {} .alpackages/ \;

    # Compile Test App
    echo "Compiling The Library Tester (TestApp)..."
    al compile /project:"./TestApp" /packagecachepath:".alpackages"

    echo "All apps compiled successfully"
else
    # Specific project provided
    echo "=== Compiling AL Application: $PROJECT_PATH ==="

    if al compile /project:"$PROJECT_PATH" /packagecachepath:".alpackages"; then
        echo "Compilation successful: $PROJECT_PATH"

        # If we just compiled the App, copy it to .alpackages for TestApp
        if [ "$PROJECT_PATH" = "./App" ] || [ "$PROJECT_PATH" = "App" ]; then
            echo "Copying compiled app to .alpackages..."
            find ./App -maxdepth 1 -name "*.app" -type f -exec cp {} .alpackages/ \;
        fi
    else
        echo "Compilation failed: $PROJECT_PATH (exit code: $?)"
        exit 1
    fi
fi
