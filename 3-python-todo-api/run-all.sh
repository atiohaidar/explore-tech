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

# Check if Python is installed
if ! command -v python3 &> /dev/null; then
    echo "❌ Python3 is not installed. Please install Python3 first."
    exit 1
fi

# Install dependencies
echo "📦 Installing Python dependencies..."
pip3 install -r requirements.txt

# Start backend in background
echo "🔥 Starting Python backend server..."
python3 main.py &
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
HTML_FILE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/index.html"

if command -v xdg-open &> /dev/null; then
    xdg-open "$HTML_FILE" 2>/dev/null &
elif command -v open &> /dev/null; then
    open "$HTML_FILE" 2>/dev/null &
elif command -v start &> /dev/null; then
    start "$HTML_FILE" 2>/dev/null &
else
    echo "❌ Could not open browser automatically."
    echo "📋 Please manually open: $HTML_FILE"
fi

echo ""
echo "🎉 Application is running!"
echo "📍 Backend API: http://localhost:8080"
echo "🌐 Frontend: $HTML_FILE"
echo ""
echo "Press Ctrl+C to stop both servers"

# Wait for user interrupt
wait $BACKEND_PID