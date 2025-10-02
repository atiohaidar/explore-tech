#!/bin/bash
# Run Java Todo API Application

echo "🚀 Starting Java Todo API Application"
echo "====================================="
echo ""

cd /workspaces/explore-tech/7-java-html-todo-api

# Check if Maven is installed
if ! command -v mvn &> /dev/null; then
    echo "❌ Maven not found! Please install Maven first."
    echo "Run: sudo apt update && sudo apt install maven"
    exit 1
fi

# Check if Java is installed
if ! command -v java &> /dev/null; then
    echo "❌ Java not found! Please install Java 17+ first."
    echo "Run: sudo apt update && sudo apt install openjdk-17-jdk"
    exit 1
fi

echo "📦 Building application with Maven..."
mvn clean compile -q

if [ $? -ne 0 ]; then
    echo "❌ Build failed!"
    exit 1
fi

echo "✅ Build successful!"
echo ""
echo "🌐 Starting Spring Boot application..."
echo "   Backend API: http://localhost:8080"
echo "   Frontend: Open index.html in browser"
echo ""
echo "📝 API Endpoints:"
echo "   GET  /api/todos           - Get all todos"
echo "   POST /api/todos           - Create todo"
echo "   PUT  /api/todos/{id}      - Update todo"
echo "   DELETE /api/todos/{id}    - Delete todo"
echo "   GET  /api/todos/completed - Get completed todos"
echo "   GET  /api/todos/search    - Search todos"
echo ""
echo "🗄️  Database: SQLite (todos.db will be created automatically)"
echo ""

mvn spring-boot:run