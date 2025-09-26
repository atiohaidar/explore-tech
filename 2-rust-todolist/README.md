# Rust Todo List

A beautiful and modern todo list application built with Rust, featuring SQLite database and HTML frontend.

## ✨ Features

### 🎨 Modern UI Design
- **Gradient Background**: Beautiful blue to purple gradient background
- **Glass Morphism**: Semi-transparent cards with backdrop blur effects
- **Smooth Animations**: Hover effects, transitions, and micro-interactions
- **Responsive Design**: Works perfectly on all screen sizes

### 📊 Progress Tracking
- **Visual Progress Stats**: Shows total, completed, and remaining tasks
- **Real-time Updates**: Progress updates instantly

### 🎯 Enhanced UX
- **Smart Empty State**: Beautiful illustration when no tasks exist
- **Interactive Elements**: Hover effects and smooth transitions
- **Edit Mode**: Click pencil icon to edit tasks
- **Delete Confirmation**: Prevents accidental deletions

### 🛠️ Technical Features
- **SQLite Database**: Persistent storage with automatic schema creation
- **RESTful API**: Clean HTTP routes for all operations
- **HTML Templates**: Server-side rendered templates with Askama
- **Async/Await**: Modern Rust async programming

## 🚀 Getting Started

### Prerequisites
- Rust 1.70+ (with Cargo)
- Modern web browser

### Installation & Running

1. **Make sure Rust is installed:**
   ```bash
   curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
   source $HOME/.cargo/env
   ```

2. **Run the application:**
   ```bash
   ./run.sh
   ```

3. **Or run directly with Cargo:**
   ```bash
   cargo run
   ```

4. **Open browser:**
   ```
   http://127.0.0.1:3000
   ```

## 📱 Usage

### Adding Tasks
- Type your task in the input field
- Press Enter or click "Add Task" button
- Tasks appear instantly in the list

### Managing Tasks
- **Complete**: Click the circle button to mark as done
- **Edit**: Click the pencil icon to edit task title
- **Delete**: Click the trash icon to delete (with confirmation)

### Progress Tracking
- View your statistics in the top stats cards
- See total tasks, completed tasks, and remaining tasks

## 🛠️ API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/` | Main page with all todos |
| POST | `/todos` | Create new todo |
| POST | `/todos/:id/toggle` | Toggle todo completion |
| GET | `/todos/:id/edit` | Edit todo page |
| POST | `/todos/:id/edit` | Update todo |
| POST | `/todos/:id/delete` | Delete todo |
| POST | `/todos/completed/clear` | Clear all completed todos |

## 🏗️ Project Structure

```
2-rust-todolist/
├── src/
│   └── main.rs              # Main application code
├── templates/
│   ├── index.html           # Main page template
│   └── edit.html            # Edit todo template
├── static/
│   └── css/
│       └── style.css        # Stylesheet
├── Cargo.toml               # Rust dependencies
├── todos.db                 # SQLite database (created automatically)
└── README.md               # This file
```

## 🧪 Testing

### Manual Testing
```bash
# Run the application
cargo run

# Test API endpoints with curl
curl http://127.0.0.1:3000/
```

### Development
```bash
# Run with auto-reload (requires cargo-watch)
cargo install cargo-watch
cargo watch -x run
```

## 🛠️ Tech Stack

- **Backend**: Rust with Axum web framework
- **Database**: SQLite with Rusqlite
- **Templates**: Askama for HTML templating
- **Styling**: Pure CSS with modern design
- **Async Runtime**: Tokio

## 📊 Database Schema

```sql
CREATE TABLE todos (
    id TEXT PRIMARY KEY,
    title TEXT NOT NULL,
    completed BOOLEAN NOT NULL DEFAULT FALSE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
```

## 🔧 Configuration

The application runs on `127.0.0.1:3000` by default. To change the port, modify the `main.rs` file:

```rust
let listener = tokio::net::TcpListener::bind("127.0.0.1:8080")
    .await
    .unwrap();
```

## 🚀 Deployment

### Development
```bash
cargo run
```

### Production Build
```bash
cargo build --release
./target/release/rust-todolist
```

### Docker (Optional)
```dockerfile
FROM rust:1.70-slim as builder
WORKDIR /app
COPY . .
RUN cargo build --release

FROM debian:bookworm-slim
RUN apt-get update && apt-get install -y ca-certificates && rm -rf /var/lib/apt/lists/*
COPY --from=builder /app/target/release/rust-todolist /usr/local/bin/
EXPOSE 3000
CMD ["rust-todolist"]
```

## 📝 License

This project is for educational purposes.

---

Built with ❤️ using Rust, Axum, SQLite, and modern web technologies