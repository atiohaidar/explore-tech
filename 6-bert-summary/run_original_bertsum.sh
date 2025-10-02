#!/bin/bash
# Run Original BertSum App (using pretrained models)

echo "🚀 Starting Original BertSum Web App"
echo "===================================="
echo "Using pretrained models without training!"
echo ""

cd /workspaces/explore-tech/6-bert-summary

# Check if Python file exists
if [ ! -f "original_bertsum_app.py" ]; then
    echo "❌ Error: original_bertsum_app.py not found!"
    exit 1
fi

# Make executable
chmod +x original_bertsum_app.py

echo "📦 Starting server..."
echo "🌐 Open http://localhost:5001 in your browser"
echo ""
echo "🎯 Available methods:"
echo "   • Extractive: BERT + clustering (like simplified BertSum)"
echo "   • Abstractive: T5/BART pretrained models"
echo "   • Hybrid: Extractive selection + Abstractive refinement"
echo ""

python3 original_bertsum_app.py