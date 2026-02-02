#!/bin/bash

# Quick Start Script for Keploy Testing
# This script provides a simple interactive menu for common Keploy tasks

echo "🧪 AI-StoryForge Keploy Testing"
echo "================================"
echo
echo "Select an option:"
echo "1) Install Keploy"
echo "2) Record new test cases"
echo "3) Run existing tests"
echo "4) Generate sample traffic"
echo "5) View test results"
echo "6) Exit"
echo

read -p "Enter your choice (1-6): " choice

case $choice in
    1)
        echo "Installing Keploy..."
        curl --silent --location "https://github.com/keploy/keploy/releases/latest/download/keploy_linux_amd64.tar.gz" | tar xz -C /tmp
        sudo mkdir -p /usr/local/bin && sudo mv /tmp/keploy /usr/local/bin
        keploy --version
        echo "✅ Keploy installed successfully!"
        ;;
    2)
        echo "Starting recording mode..."
        echo "Press Ctrl+C to stop recording"
        npm run keploy:record
        ;;
    3)
        echo "Running tests..."
        npm run keploy:test
        ;;
    4)
        echo "Open another terminal and run:"
        echo "./keploy-test.sh generate"
        ;;
    5)
        ./keploy-test.sh results
        ;;
    6)
        echo "Goodbye!"
        exit 0
        ;;
    *)
        echo "Invalid choice!"
        exit 1
        ;;
esac
