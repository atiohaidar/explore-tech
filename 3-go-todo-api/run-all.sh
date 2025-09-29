#!/bin/bash

echo "🚀 Starting Go Todo Application (Backend + Frontend)"
echo "=================================================="
echo ""

# Function to cleanup background processes
cleanup() {
    echo ""
    echo "🛑 Shutting down servers..."
    if [ ! -z "$BACKEND_PID" ]; then
        kill $BACKEND_PID 2>/dev/null
        echo "✅ Backend stopped"
    fi
    exit 0
}

# Set trap to cleanup on script exit
trap cleanup EXIT INT TERM

# Check if Go is installed
if ! command -v go &> /dev/null; then
    echo "❌ Go is not installed. Please install Go first."
    exit 1
fi

# Install dependencies
echo "📦 Installing Go dependencies..."
go mod tidy

# Start backend in background
echo "🔥 Starting Go backend server..."
go run main.go &
BACKEND_PID=$!

# Wait a moment for backend to start
sleep 2

# Check if backend is running
if ! kill -0 $BACKEND_PID 2>/dev/null; then
    echo "❌ Failed to start backend server"
    exit 1
fi

echo "✅ Backend running on http://localhost:8080 (PID: $BACKEND_PID)"

# Open frontend
echo "🌐 Opening frontend..."
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
echo "🎉 Application is running!"
echo "📍 Backend API: http://localhost:8080"
echo "🌐 Frontend: http://localhost:8080"
echo ""
echo "Press Ctrl+C to stop the server"

# Wait for user interrupt
wait $BACKEND_PID