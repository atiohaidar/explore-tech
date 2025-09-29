#!/bin/bash

echo "🌐 Opening TensorFlow.js Demo..."
echo "📍 Opening browser to: http://localhost:8080"
echo "🔗 Make sure nginx is running on port 8080"
echo ""

# Open in browser
if command -v xdg-open &> /dev/null; then
    xdg-open "http://localhost:8080"
elif command -v open &> /dev/null; then
    open "http://localhost:8080"
elif command -v start &> /dev/null; then
    start "http://localhost:8080"
else
    echo "❌ Could not open browser automatically."
    echo "📋 Please manually open: http://localhost:8080"
fi

echo ""
echo "✅ Browser opened! Make sure nginx is running."