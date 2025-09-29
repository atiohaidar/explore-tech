#!/bin/bash

echo "🚀 Starting Python Todo API Backend..."
echo "📍 Server will run on: http://localhost:8080"
echo "📊 API endpoints:"
echo "  GET    /api/todos              - Get all todos"
echo "  POST   /api/todos              - Create new todo"
echo "  PUT    /api/todos/{id}         - Update todo"
echo "  DELETE /api/todos/{id}         - Delete todo"
echo "  PUT    /api/todos/{id}/toggle  - Toggle todo completion"
echo "  DELETE /api/todos/completed/clear - Clear completed todos"
echo ""

# Check if Python is installed
if ! command -v python3 &> /dev/null; then
    echo "❌ Python3 is not installed. Please install Python3 first."
    exit 1
fi

# Install dependencies
echo "📦 Installing Python dependencies..."
pip3 install -r requirements.txt

# Run the server
echo "🔥 Starting server..."
python3 main.py