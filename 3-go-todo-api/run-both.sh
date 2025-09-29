#!/bin/bash

echo "🚀 Starting Go Todo App (Frontend + Backend)..."
echo "📍 Frontend: http://localhost:3000"
echo "🔗 Backend API: http://localhost:8080"
echo ""

cd "$(dirname "$0")"

# Check if Go is installed
if ! command -v go &> /dev/null; then
    echo "❌ Go is not installed. Please install Go first."
    exit 1
fi

# Function to cleanup background processes
cleanup() {
    echo ""
    echo "🛑 Shutting down servers..."
    kill $BACKEND_PID $FRONTEND_PID 2>/dev/null
    exit 0
}

# Set trap to cleanup on script exit
trap cleanup SIGINT SIGTERM

# Start backend server in background
echo "🔧 Starting backend API server..."
go run main.go &
BACKEND_PID=$!

# Wait a moment for backend to start
sleep 2

# Start frontend server in background
echo "🌐 Starting frontend server..."
go run frontend.go &
FRONTEND_PID=$!

# Wait a moment for frontend to start
sleep 1

echo ""
echo "✅ Both servers are running!"
echo "📱 Open your browser to: http://localhost:3000"
echo "🔗 Backend API available at: http://localhost:8080/api"
echo ""
echo "Press Ctrl+C to stop both servers"

# Wait for background processes
wait