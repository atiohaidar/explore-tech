#!/bin/bash
# Run Frontend Server for Todo App

echo "🌐 Starting Frontend Server"
echo "==========================="
echo ""

cd /workspaces/explore-tech/7-java-html-todo-api

PORT=3000

echo "📁 Serving files from: $(pwd)"
echo "🌐 Frontend URL: http://localhost:$PORT/index.html"
echo "🔗 Backend API: http://localhost:8080"
echo ""
echo "📝 Make sure backend is running first:"
echo "   ./run.sh"
echo ""

# Check if Python is available
if command -v python3 &> /dev/null; then
    python3 -m http.server $PORT
elif command -v python &> /dev/null; then
    python -m http.server $PORT
else
    echo "❌ Python not found! Please install Python or use another web server."
    exit 1
fi