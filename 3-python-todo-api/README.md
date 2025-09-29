# 🚀 Python Todo List API + HTML Frontend

A simple and beautiful Todo List application built with Python Flask (backend API) and vanilla HTML/JavaScript (frontend), using SQLite as the database.

**Note:** There's also a [Go version](https://github.com/your-repo/3-go-todo-api) of this API available.

## 📋 Features

- ✅ **RESTful API** - Complete CRUD operations for todos
- 🎨 **Modern UI** - Beautiful, responsive HTML frontend
- 🗄️ **SQLite Database** - Lightweight, file-based database
- 🔄 **Real-time Updates** - Frontend updates immediately via API calls
- 📱 **Responsive Design** - Works on desktop and mobile
- 🏷️ **CORS Enabled** - API accepts requests from any origin

## 🏗️ Architecture

```
┌─────────────────┐    HTTP     ┌─────────────────┐
│   HTML Frontend │ ──────────► │   Go API Server │
│                 │             │                 │
│ - index.html    │             │ - RESTful API   │
│ - JavaScript    │             │ - SQLite DB     │
│ - CSS Styling   │             │ - CORS enabled  │
└─────────────────┘             └─────────────────┘
```

## 🚀 Quick Start

### Prerequisites

- Python 3.8 or higher
- pip (Python package installer)
- Modern web browser

### Installation & Running

#### Option 1: Run Everything (Recommended)
```bash
./run-all.sh
```
This will start both the Go backend and open the frontend in your browser.

#### Option 2: Run Backend Only
```bash
./run-backend.sh
```
Then open `index.html` in your browser manually.

#### Option 3: Run Frontend Only
```bash
./run-frontend.sh
```
Make sure the backend is running on port 8080 first.

## 📡 API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/todos` | Get all todos |
| POST | `/api/todos` | Create new todo |
| PUT | `/api/todos/{id}` | Update todo |
| DELETE | `/api/todos/{id}` | Delete todo |
| PUT | `/api/todos/{id}/toggle` | Toggle completion status |
| DELETE | `/api/todos/completed/clear` | Clear all completed todos |

### API Examples

#### Create Todo
```bash
curl -X POST http://localhost:8080/api/todos \
  -H "Content-Type: application/json" \
  -d '{"title": "Learn Go"}'
```

#### Get All Todos
```bash
curl http://localhost:8080/api/todos
```

#### Update Todo
```bash
curl -X PUT http://localhost:8080/api/todos/1 \
  -H "Content-Type: application/json" \
  -d '{"title": "Learn Go programming", "completed": true}'
```

## 📁 Project Structure

```
3-python-todo-api/
├── main.py              # Python Flask API server
├── requirements.txt     # Python dependencies
├── index.html           # Frontend HTML
├── run-backend.sh       # Script to run Python server
├── run-frontend.sh      # Script to open HTML in browser
├── run-all.sh          # Script to run both backend & frontend
├── todos.db            # SQLite database (created automatically)
└── README.md           # This file
```

## 🛠️ Development

### Install Dependencies
```bash
pip3 install -r requirements.txt
```

### Run in Development Mode
```bash
# Terminal 1 - Backend
python3 main.py

# Terminal 2 - Frontend
# Open index.html in browser or use:
./run-frontend.sh
```

### Database

The application uses SQLite with a simple schema:

```sql
CREATE TABLE todos (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL,
    completed BOOLEAN NOT NULL DEFAULT FALSE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
```

Database file `todos.db` is created automatically on first run.

## 🎨 Frontend Features

- **Add Todos** - Type and press Enter or click "Add Task"
- **Mark Complete** - Click checkbox to toggle completion
- **Edit Todos** - Click "Edit" button to modify title
- **Delete Todos** - Click "Delete" button to remove
- **Clear Completed** - Remove all completed todos at once
- **Statistics** - Shows total, completed, and remaining counts
- **Responsive** - Works on all screen sizes

## 🔧 Configuration

### Server Port
The server runs on port 8080 by default. To change:

```go
// In main.go, line ~140
log.Fatal(http.ListenAndServe(":8080", r))
```

### CORS
CORS is enabled for all origins. To restrict:

```go
// In main.go, modify enableCORS function
w.Header().Set("Access-Control-Allow-Origin", "http://localhost:3000")
```

## 🐛 Troubleshooting

### Backend won't start
- Ensure Python 3.8+ is installed: `python3 --version`
- Check if port 8080 is available
- Install dependencies: `pip3 install -r requirements.txt`

### Frontend can't connect to API
- Ensure backend is running on port 8080
- Check browser console for CORS errors
- Verify API_BASE URL in index.html

### Database issues
- Delete `todos.db` file to reset database
- Check file permissions in the directory

## 📦 Dependencies

- **Flask** - Web framework for Python
- **Flask-CORS** - CORS support for Flask

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 License

This project is open source and available under the MIT License.

---

**Happy coding! 🎉**