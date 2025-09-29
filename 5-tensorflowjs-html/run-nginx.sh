#!/bin/bash

echo "🚀 Starting TensorFlow.js Demo with Nginx..."
echo "📍 Server will run on: http://localhost:8080"
echo "🌐 TensorFlow.js interactive demo available at: http://localhost:8080"
echo ""

# Check if nginx is installed
if ! command -v nginx &> /dev/null; then
    echo "❌ Nginx is not installed. Installing nginx..."
    apt update && apt install -y nginx
fi

# Create nginx log directories if they don't exist
sudo mkdir -p /var/log/nginx

# Get the absolute path to the project directory
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_FILE="$PROJECT_DIR/nginx.conf"

# Check if config file exists
if [ ! -f "$CONFIG_FILE" ]; then
    echo "❌ nginx.conf not found!"
    exit 1
fi

echo "📁 Using config file: $CONFIG_FILE"
echo "📂 Serving files from: $PROJECT_DIR"

# Stop any existing nginx processes
echo "🛑 Stopping any existing nginx processes..."
sudo pkill -f nginx || true

# Wait a moment
sleep 1

# Start nginx with custom config
echo "🔥 Starting nginx..."
sudo nginx -c "$CONFIG_FILE" -p "$PROJECT_DIR"

# Check if nginx started successfully
sleep 2
if pgrep -f nginx > /dev/null; then
    echo "✅ Nginx started successfully!"
    echo ""
    echo "🎉 TensorFlow.js demo is running!"
    echo "🌐 Open your browser to: http://localhost:8080"
    echo ""
    echo "📋 Available endpoints:"
    echo "  GET  / - Main TensorFlow.js demo page"
    echo ""
    echo "Press Ctrl+C to stop the server"
    echo ""

    # Wait for user interrupt
    trap 'echo ""; echo "🛑 Stopping nginx..."; sudo nginx -s stop; exit 0' INT TERM
    wait
else
    echo "❌ Failed to start nginx"
    exit 1
fi