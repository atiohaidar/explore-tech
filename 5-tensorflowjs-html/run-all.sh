#!/bin/bash

echo "🚀 Starting TensorFlow.js Demo (Nginx + Browser)"
echo "==============================================="
echo ""

# Function to cleanup background processes
cleanup() {
    echo ""
    echo "🛑 Shutting down nginx..."
    sudo nginx -s stop 2>/dev/null || true
    exit 0
}

# Set trap to cleanup on script exit
trap cleanup EXIT INT TERM

# Check if nginx is installed
if ! command -v nginx &> /dev/null; then
    echo "❌ Nginx is not installed. Installing nginx..."
    apt update && apt install -y nginx
fi

# Get the absolute path to the project directory
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_FILE="$PROJECT_DIR/nginx.conf"

# Stop any existing nginx processes
echo "🛑 Stopping any existing nginx processes..."
sudo pkill -f nginx || true
sleep 1

# Start nginx with custom config
echo "🔥 Starting nginx server..."
sudo nginx -c "$CONFIG_FILE" -p "$PROJECT_DIR"

# Check if nginx started successfully
sleep 2
if pgrep -f nginx > /dev/null; then
    echo "✅ Nginx started successfully on port 8080"
else
    echo "❌ Failed to start nginx"
    exit 1
fi

# Open browser
echo "🌐 Opening browser..."
if command -v xdg-open &> /dev/null; then
    xdg-open "http://localhost:8080" 2>/dev/null &
elif command -v open &> /dev/null; then
    open "http://localhost:8080" 2>/dev/null &
elif command -v start &> /dev/null; then
    start "http://localhost:8080" 2>/dev/null &
else
    echo "❌ Could not open browser automatically."
    echo "📋 Please manually open: http://localhost:8080"
fi

echo ""
echo "🎉 TensorFlow.js demo is running!"
echo "📍 Server: http://localhost:8080"
echo "🧠 Demo: Interactive TensorFlow.js linear regression"
echo ""
echo "Press Ctrl+C to stop the server"

# Wait for user interrupt
wait