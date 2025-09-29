#!/bin/bash

echo "🚀 Starting Go Todo API Backend..."
echo "📍 Server will run on: http://localhost:8080"
echo "📊 API endpoints:"
echo "  GET    /api/todos              - Get all todos"
echo "  POST   /api/todos              - Create new todo"
echo "  PUT    /api/todos/{id}         - Update todo"
echo "  DELETE /api/todos/{id}         - Delete todo"
echo "  PUT    /api/todos/{id}/toggle  - Toggle todo completion"
echo "  DELETE /api/todos/completed/clear - Clear completed todos"
echo ""

# Check if Go is installed
if ! command -v go &> /dev/null; then
    echo "❌ Go is not installed. Please install Go first."
    exit 1
fi

# Install dependencies
echo "📦 Installing Go dependencies..."
go mod tidy

# Run the server
echo "🔥 Starting server..."
go run main.go