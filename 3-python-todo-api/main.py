from flask import Flask, request, jsonify
from flask_cors import CORS
import sqlite3
import json
from datetime import datetime
import os

app = Flask(__name__)
CORS(app)  # Enable CORS for all routes

DATABASE = 'todos.db'

def get_db():
    """Get database connection"""
    conn = sqlite3.connect(DATABASE)
    conn.row_factory = sqlite3.Row
    return conn

def init_db():
    """Initialize database"""
    with get_db() as conn:
        conn.execute('''
            CREATE TABLE IF NOT EXISTS todos (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                title TEXT NOT NULL,
                completed BOOLEAN NOT NULL DEFAULT FALSE,
                created_at TEXT NOT NULL
            )
        ''')
        conn.commit()

@app.route('/api/todos', methods=['GET'])
def get_todos():
    """Get all todos"""
    with get_db() as conn:
        todos = conn.execute('SELECT * FROM todos ORDER BY created_at DESC').fetchall()

    return jsonify([{
        'id': todo['id'],
        'title': todo['title'],
        'completed': bool(todo['completed']),
        'created_at': todo['created_at']
    } for todo in todos])

@app.route('/api/todos', methods=['POST'])
def create_todo():
    """Create new todo"""
    data = request.get_json()

    if not data or 'title' not in data:
        return jsonify({'error': 'Title is required'}), 400

    title = data['title'].strip()
    if not title:
        return jsonify({'error': 'Title cannot be empty'}), 400

    created_at = datetime.utcnow().isoformat()

    with get_db() as conn:
        cursor = conn.execute(
            'INSERT INTO todos (title, completed, created_at) VALUES (?, ?, ?)',
            (title, False, created_at)
        )
        todo_id = cursor.lastrowid

        todo = {
            'id': todo_id,
            'title': title,
            'completed': False,
            'created_at': created_at
        }

    return jsonify(todo), 201

@app.route('/api/todos/<int:todo_id>', methods=['PUT'])
def update_todo(todo_id):
    """Update todo"""
    data = request.get_json()

    if not data or 'title' not in data:
        return jsonify({'error': 'Title is required'}), 400

    title = data['title'].strip()
    completed = data.get('completed', False)

    if not title:
        return jsonify({'error': 'Title cannot be empty'}), 400

    with get_db() as conn:
        cursor = conn.execute(
            'UPDATE todos SET title = ?, completed = ? WHERE id = ?',
            (title, completed, todo_id)
        )

        if cursor.rowcount == 0:
            return jsonify({'error': 'Todo not found'}), 404

        todo = {
            'id': todo_id,
            'title': title,
            'completed': bool(completed),
            'created_at': datetime.utcnow().isoformat()
        }

    return jsonify(todo)

@app.route('/api/todos/<int:todo_id>', methods=['DELETE'])
def delete_todo(todo_id):
    """Delete todo"""
    with get_db() as conn:
        cursor = conn.execute('DELETE FROM todos WHERE id = ?', (todo_id,))

        if cursor.rowcount == 0:
            return jsonify({'error': 'Todo not found'}), 404

    return '', 204

@app.route('/api/todos/<int:todo_id>/toggle', methods=['PUT'])
def toggle_todo(todo_id):
    """Toggle todo completion status"""
    with get_db() as conn:
        # First get current status
        current = conn.execute('SELECT completed FROM todos WHERE id = ?', (todo_id,)).fetchone()

        if not current:
            return jsonify({'error': 'Todo not found'}), 404

        # Toggle the status
        new_status = not bool(current['completed'])
        conn.execute('UPDATE todos SET completed = ? WHERE id = ?', (new_status, todo_id))

    return '', 204

@app.route('/api/todos/completed/clear', methods=['DELETE'])
def clear_completed():
    """Clear all completed todos"""
    with get_db() as conn:
        conn.execute('DELETE FROM todos WHERE completed = ?', (True,))

    return '', 204

@app.route('/')
def serve_index():
    """Serve the main HTML page"""
    return app.send_static_file('index.html')

if __name__ == '__main__':
    init_db()
    print("🚀 Python Todo API server running on http://localhost:8080")
    print("🌐 Frontend available at: http://localhost:8080")
    print("📊 API endpoints:")
    print("  GET    /api/todos              - Get all todos")
    print("  POST   /api/todos              - Create new todo")
    print("  PUT    /api/todos/{id}         - Update todo")
    print("  DELETE /api/todos/{id}         - Delete todo")
    print("  PUT    /api/todos/{id}/toggle  - Toggle todo completion")
    print("  DELETE /api/todos/completed/clear - Clear completed todos")
    app.run(host='0.0.0.0', port=8080, debug=True)