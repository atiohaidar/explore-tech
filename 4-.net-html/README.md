# Todo List Project

This project consists of a .NET backend REST API with SQLite database and an HTML frontend.

## Backend

The backend is a single file `Program.cs` using ASP.NET Core minimal API with SQLite database.

### Database

- Uses SQLite database (`todos.db`)
- Data is persistent across restarts
- Table `Todos` is created automatically on first run

### Running the Backend

1. Ensure you have .NET 8+ installed.
2. Run `./run-backend.sh` or `dotnet run` in the project directory.
3. The API will be available at `http://localhost:5000` (or the port shown in the console).

### API Endpoints

- `GET /todos` - Get all todos
- `POST /todos` - Create a new todo (body: `{ "title": "string" }`)
- `PUT /todos/{id}` - Update a todo (body: `{ "title": "string", "isCompleted": bool }`)
- `DELETE /todos/{id}` - Delete a todo

## Frontend

The frontend is a single file `index.html` with embedded CSS and JavaScript.

### Running the Frontend

1. Run `./run-frontend.sh` or `python -m http.server 8080` in the project directory.
2. Open `http://127.0.0.1:8080` in your browser.
3. Make sure the backend is running first.

## Notes

- CORS is enabled for development
- SQLite database file `todos.db` will be created in the project directory