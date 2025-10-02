# Java Todo API with HTML Frontend

Aplikasi Todo List sederhana dengan backend Java Spring Boot dan frontend HTML yang menggunakan SQLite sebagai database.

## 🚀 Fitur

- ✅ **REST API** dengan Spring Boot
- ✅ **Database SQLite** untuk penyimpanan data
- ✅ **Frontend HTML** dengan JavaScript
- ✅ **CORS support** untuk cross-origin requests
- ✅ **CRUD operations** (Create, Read, Update, Delete)
- ✅ **Search functionality**
- ✅ **Filter by status** (All, Pending, Completed)

## 📁 Struktur File

```
7-java-html-todo-api/
├── TodoApiApplication.java    # Main Spring Boot application
├── pom.xml                    # Maven dependencies
├── src/main/resources/
│   └── application.properties # Database configuration
└── index.html                 # Frontend HTML
```

## 🛠️ Prerequisites

- Java 17 atau lebih tinggi
- Maven 3.6+
- Browser modern

## 🚀 Cara Menjalankan

### 1. Compile dan Run Backend

```bash
# Masuk ke folder project
cd /workspaces/explore-tech/7-java-html-todo-api

# Compile dengan Maven
mvn clean compile

# Run aplikasi
mvn spring-boot:run
```

Backend akan berjalan di `http://localhost:8080`

### 2. Jalankan Frontend

Buka file `index.html` di browser atau serve dengan web server:

```bash
# Dengan Python (opsional)
python3 -m http.server 3000

# Lalu buka http://localhost:3000/index.html
```

## 📡 API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/todos` | Get all todos |
| GET | `/api/todos/{id}` | Get todo by ID |
| POST | `/api/todos` | Create new todo |
| PUT | `/api/todos/{id}` | Update todo |
| DELETE | `/api/todos/{id}` | Delete todo |
| GET | `/api/todos/completed` | Get completed todos |
| GET | `/api/todos/pending` | Get pending todos |
| GET | `/api/todos/search?query=...` | Search todos |

## 🎨 Frontend Features

- **Add Todo**: Tambah todo baru dengan title dan description
- **Edit Todo**: Edit todo yang sudah ada
- **Delete Todo**: Hapus todo
- **Toggle Status**: Mark sebagai completed/pending
- **Search**: Cari todo berdasarkan title
- **Filter**: Filter berdasarkan status (All, Pending, Completed)
- **Responsive**: UI yang responsive

## 💾 Database

Aplikasi menggunakan **SQLite** dengan file database `todos.db` yang akan dibuat otomatis.

### Schema Table `todos`:

```sql
CREATE TABLE todos (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL,
    description TEXT,
    is_completed BOOLEAN DEFAULT FALSE,
    created_at DATETIME,
    updated_at DATETIME
);
```

## 🔧 Konfigurasi

### application.properties

```properties
# Database
spring.datasource.url=jdbc:sqlite:todos.db
spring.datasource.driver-class-name=org.sqlite.JDBC

# JPA
spring.jpa.database-platform=com.example.todoapi.SQLiteDialect
spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=true

# Server
server.port=8080
```

## 🎯 Testing API

### Create Todo
```bash
curl -X POST http://localhost:8080/api/todos \
  -H "Content-Type: application/json" \
  -d '{"title": "Learn Java", "description": "Study Spring Boot"}'
```

### Get All Todos
```bash
curl http://localhost:8080/api/todos
```

### Update Todo
```bash
curl -X PUT http://localhost:8080/api/todos/1 \
  -H "Content-Type: application/json" \
  -d '{"title": "Learn Java Spring", "completed": true}'
```

### Delete Todo
```bash
curl -X DELETE http://localhost:8080/api/todos/1
```

## 🚀 Development

### Menambah Fitur Baru

1. **Backend**: Tambahkan method di `TodoController` dan `TodoService`
2. **Frontend**: Tambahkan JavaScript function dan HTML elements
3. **Database**: Update entity `Todo` jika perlu schema baru

### Build JAR

```bash
mvn clean package
java -jar target/todo-api-1.0.0.jar
```

## 📝 Catatan

- Database SQLite akan dibuat otomatis saat pertama kali run
- CORS sudah dikonfigurasi untuk menerima request dari frontend
- Error handling sudah diimplementasi di backend
- Frontend menggunakan vanilla JavaScript (tanpa framework)

## 🐛 Troubleshooting

### Backend tidak bisa start
- Pastikan Java 17+ terinstall
- Pastikan Maven terinstall
- Check port 8080 tidak digunakan aplikasi lain

### Frontend tidak connect ke backend
- Pastikan backend running di port 8080
- Check CORS error di browser console
- Pastikan API_BASE URL benar

### Database error
- Hapus file `todos.db` dan restart aplikasi
- Check application.properties configuration