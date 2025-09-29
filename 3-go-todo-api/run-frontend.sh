#!/bin/bash

echo "🚀 Starting Go Frontend Server..."
echo "📍 Frontend will be served on: http://localhost:3000"
echo "🔗 Backend API should be running on: http://localhost:8080"
echo ""

cd "$(dirname "$0")"

# Check if Go is installed
if ! command -v go &> /dev/null; then
    echo "❌ Go is not installed. Please install Go first."
    exit 1
fi

# Run the frontend server
go run frontend.go