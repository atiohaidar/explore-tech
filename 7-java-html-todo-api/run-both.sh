#!/bin/bash
# Run Both Backend and Frontend

echo "🚀 Starting Todo App (Backend + Frontend)"
echo "=========================================="
echo ""

cd /workspaces/explore-tech/7-java-html-todo-api

# Function to cleanup background processes
cleanup() {
    echo ""
    echo "🛑 Stopping servers..."
    kill $BACKEND_PID $FRONTEND_PID 2>/dev/null
    exit 0
}

# Set trap to cleanup on script exit
trap cleanup EXIT INT TERM

echo "🔧 Starting Backend (Spring Boot)..."
./run.sh &
BACKEND_PID=$!

echo "⏳ Waiting 10 seconds for backend to start..."
sleep 10

echo "🌐 Starting Frontend (HTTP Server)..."
./run-frontend.sh &
FRONTEND_PID=$!

echo ""
echo "✅ Both servers started!"
echo ""
echo "🔗 URLs:"
echo "   Frontend: http://localhost:3000/index.html"
echo "   Backend:  http://localhost:8080"
echo ""
echo "📝 API Documentation: http://localhost:8080/swagger-ui.html (if enabled)"
echo ""
echo "🛑 Press Ctrl+C to stop both servers"
echo ""

# Wait for background processes
wait