#!/bin/bash

# Rust Todo List Runner Script

echo "🚀 Starting Rust Todo List Application..."
echo "📍 URL: http://127.0.0.1:3000"
echo "🗄️  Database: todos.db (SQLite)"
echo ""

# Check if cargo is available
if ! command -v cargo &> /dev/null; then
    echo "❌ Cargo not found. Please install Rust first."
    echo "   Visit: https://rustup.rs/"
    exit 1
fi

# Run the application
source $HOME/.cargo/env
cargo run