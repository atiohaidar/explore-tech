# 🚀 Go Todo List API + HTML Frontend

A simple and beautiful Todo List application built with Go (backend API) and vanilla HTML/JavaScript (frontend), using SQLite as the database.

## 📋 Features

- ✅ **RESTful API** - Complete CRUD operations for todos
- 🎨 **Modern UI** - Beautiful, responsive HTML frontend
- 🗄️ **SQLite Database** - Lightweight, file-based database
- 🔄 **Real-time Updates** - Frontend updates immediately via API calls
- 📱 **Responsive Design** - Works on desktop and mobile
- 🏷️ **CORS Enabled** - API accepts requests from any origin

## 🚀 Quick Start

### Prerequisites

- Go 1.21 or higher
- Modern web browser

### Installation & Running

#### Option 1: Run Everything (Recommended)
```bash
./run-both.sh
```
This will start both the Go backend API (port 8080) and frontend server (port 3000), then open the frontend in your browser.

#### Option 2: Run Backend API Only
```bash
./run-backend.sh
```
This starts the API server on port 8080. Use this if you want to serve the frontend separately.

#### Option 3: Run Frontend Only
```bash
./run-frontend.sh
```
This starts the frontend server on port 3000. Make sure the backend API is running on port 8080 first.

#### Option 4: Manual Development
```bash
# Terminal 1 - Backend API
go run main.go

# Terminal 2 - Frontend Server
go run frontend.go

# Then open browser to: http://localhost:3000
```

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

## 📁 Project Structure

```
3-go-todo-api/
├── main.go              # Go API server (backend only)
├── frontend.go          # Go frontend server (serves HTML/CSS/JS)
├── go.mod               # Go module file
├── go.sum               # Go dependencies
├── index.html           # Frontend HTML
├── run-backend.sh       # Script to run API server only
├── run-frontend.sh      # Script to run frontend server only
├── run-both.sh          # Script to run both servers
├── run-all.sh          # Legacy script (deprecated)
├── todos.db            # SQLite database (created automatically)
├── .gitignore          # Git ignore file
└── README.md           # This file
```

## 🛠️ Development

### Install Dependencies
```bash
go mod tidy
```

### Run in Development Mode
```bash
# Terminal 1 - Backend API (port 8080)
go run main.go

# Terminal 2 - Frontend Server (port 3000)
go run frontend.go

# Then open browser to: http://localhost:3000
```

### Architecture Notes
- **Backend (main.go)**: REST API server on port 8080, handles database operations
- **Frontend (frontend.go)**: Static file server on port 3000, serves HTML/CSS/JS
- **Separation**: Frontend and backend run on different ports for better development flexibility

### Database

The application uses SQLite with a simple schema:

```sql
CREATE TABLE todos (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL,
    completed BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TEXT NOT NULL
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

## 🐛 Troubleshooting

### Backend won't start
- Ensure Go 1.21+ is installed: `go version`
- Check if port 8080 is available
- Run `go mod tidy` to install dependencies

### Frontend won't start
- Ensure Go 1.21+ is installed: `go version`
- Check if port 3000 is available
- Make sure backend API is running on port 8080

### Frontend can't connect to API
- Ensure backend is running on port 8080 (`./run-backend.sh`)
- Frontend runs on port 3000, API calls go to port 8080
- Check browser console for CORS or network errors
- Open browser to `http://localhost:3000` (not file://)

### Database issues
- Delete `todos.db` file to reset database
- Check file permissions in the directory

## 📦 Dependencies

- **gorilla/mux** - HTTP router and URL matcher
- **modernc.org/sqlite** - Pure Go SQLite driver

---

**Note:** This is the complete Go version with both API backend and HTML frontend. There's also a [Python version](https://github.com/your-repo/3-python-todo-api) available.