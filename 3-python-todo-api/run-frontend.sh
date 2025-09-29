#!/bin/bash

echo "🌐 Opening Go Todo Frontend..."
echo "📍 Frontend will open in your default browser"
echo "🔗 Make sure the backend is running on http://localhost:8080"
echo ""

# Get the absolute path to the HTML file
HTML_FILE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/index.html"

# Check if the HTML file exists
if [ ! -f "$HTML_FILE" ]; then
    echo "❌ index.html not found!"
    exit 1
fi

echo "📂 Opening: $HTML_FILE"

# Open in browser (works on Linux with xdg-open)
if command -v xdg-open &> /dev/null; then
    xdg-open "$HTML_FILE"
elif command -v open &> /dev/null; then
    open "$HTML_FILE"
elif command -v start &> /dev/null; then
    start "$HTML_FILE"
else
    echo "❌ Could not open browser automatically."
    echo "📋 Please manually open: $HTML_FILE"
fi

echo ""
echo "✅ Frontend opened! Make sure the Go backend is running."