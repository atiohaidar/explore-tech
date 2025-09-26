#!/bin/bash

# Start MongoDB using Docker
echo "Starting MongoDB with Docker..."
docker run -d --name mongodb-todolist -p 27017:27017 mongo:latest

# Wait for MongoDB to start
echo "Waiting for MongoDB to be ready..."
sleep 10

# Start backend
echo "Starting backend..."
cd backend
npm install
npm run start:dev &
BACKEND_PID=$!
cd ..

# Start frontend
echo "Starting frontend..."
cd frontend
npm install
npm run dev &
FRONTEND_PID=$!
cd ..

echo "All services started!"
echo "Frontend: http://localhost:3000"
echo "Backend: http://localhost:3001"
echo "MongoDB: localhost:27017"
echo ""
echo "Press Ctrl+C to stop all services."

# Function to cleanup on exit
cleanup() {
    echo ""
    echo "Stopping services..."
    kill $BACKEND_PID 2>/dev/null
    kill $FRONTEND_PID 2>/dev/null
    docker stop mongodb-todolist 2>/dev/null
    docker rm mongodb-todolist 2>/dev/null
    echo "All services stopped."
    exit 0
}

# Set trap to cleanup on exit
trap cleanup SIGINT SIGTERM

# Wait for all processes
wait