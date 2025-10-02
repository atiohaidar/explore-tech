# Java Todo API with HTML Frontend

Aplikasi Todo List lengkap dengan backend Java Spring Boot REST API dan frontend HTML/CSS/JavaScript yang menggunakan SQLite sebagai database.

## 🚀 Fitur

- ✅ **REST API** dengan Spring Boot 3
- ✅ **Database SQLite** untuk penyimpanan data lokal
- ✅ **Frontend HTML** dengan vanilla JavaScript
- ✅ **CORS support** untuk cross-origin requests
- ✅ **CRUD operations** (Create, Read, Update, Delete)
- ✅ **Search functionality** berdasarkan title
- ✅ **Filter by status** (All, Pending, Completed)
- ✅ **Responsive design** untuk mobile dan desktop
- ✅ **Real-time updates** UI
- ✅ **Input validation** di frontend dan backend

## 📁 Struktur Project

```
7-java-html-todo-api/
├── src/
│   └── main/
│       ├── java/com/example/todoapi/
│       │   ├── TodoApiApplication.java    # Main Spring Boot application
│       │   └── SQLiteDialect.java         # Custom SQLite dialect
│       └── resources/
│           └── application.properties     # Database & server config
├── index.html                 # Frontend HTML dengan JavaScript
├── pom.xml                    # Maven dependencies & build config
├── run.sh                     # Script untuk run backend
├── run-frontend.sh            # Script untuk run frontend server
├── run-both.sh                # Script untuk run backend + frontend
├── test-api.sh                # Script untuk test API endpoints
├── README.md                  # Dokumentasi project
└── todos.db                   # SQLite database (dibuat otomatis)
```

## 🛠️ Prerequisites

- **Java 17** atau lebih tinggi
- **Maven 3.6+**
- **Browser modern** (Chrome, Firefox, Safari, Edge)

## 🚀 Cara Menjalankan

### Opsi 1: Jalankan Semuanya Sekaligus (Recommended)

```bash
# Jalankan backend dan frontend sekaligus
./run-both.sh
```

### Opsi 2: Jalankan Terpisah

#### Backend (Spring Boot API)
```bash
# Jalankan backend saja
./run.sh
```
Backend akan berjalan di `http://localhost:8080`

#### Frontend (HTML Server)
```bash
# Jalankan frontend server saja
./run-frontend.sh
```
Frontend akan berjalan di `http://localhost:3000`

### Opsi 3: Manual dengan Maven

```bash
# Compile project
mvn clean compile

# Run aplikasi
mvn spring-boot:run
```

## 🧪 Testing API

```bash
# Test semua API endpoints
./test-api.sh
```

## 📡 API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| `GET` | `/api/todos` | Get all todos |
| `GET` | `/api/todos/{id}` | Get todo by ID |
| `POST` | `/api/todos` | Create new todo |
| `PUT` | `/api/todos/{id}` | Update todo (partial update) |
| `DELETE` | `/api/todos/{id}` | Delete todo |
| `GET` | `/api/todos/completed` | Get completed todos |
| `GET` | `/api/todos/pending` | Get pending todos |
| `GET` | `/api/todos/search?query=...` | Search todos by title |

### Request/Response Examples

#### Create Todo
```bash
curl -X POST http://localhost:8080/api/todos \
  -H "Content-Type: application/json" \
  -d '{"title": "Learn Java", "description": "Study Spring Boot"}'
```

#### Update Todo (Partial)
```bash
# Update completion status only
curl -X PUT http://localhost:8080/api/todos/1 \
  -H "Content-Type: application/json" \
  -d '{"completed": true}'

# Update title and description
curl -X PUT http://localhost:8080/api/todos/1 \
  -H "Content-Type: application/json" \
  -d '{"title": "Learn Java Spring", "description": "Advanced Spring Boot"}'
```

#### Search Todos
```bash
curl "http://localhost:8080/api/todos/search?query=Java"
```

## 🎨 Frontend Features

- **📝 Add Todo**: Form untuk tambah todo baru dengan validasi
- **✏️ Edit Todo**: Modal edit dengan pre-filled data
- **🗑️ Delete Todo**: Konfirmasi sebelum hapus
- **✅ Toggle Status**: Klik checkbox untuk mark complete/pending
- **🔍 Search**: Real-time search berdasarkan title
- **🏷️ Filter**: Filter by status (All, Pending, Completed)
- **📱 Responsive**: UI yang responsive untuk semua device
- **⚡ Real-time**: UI updates tanpa refresh page
- **🎯 Status Messages**: Feedback untuk user actions

## 💾 Database Schema

Aplikasi menggunakan **SQLite** dengan schema berikut:

```sql
CREATE TABLE todos (
    id INTEGER PRIMARY KEY,           -- Manual ID generation
    title TEXT NOT NULL,              -- Required field
    description TEXT,                 -- Optional field
    is_completed BOOLEAN DEFAULT 0,   -- Completion status
    created_at DATETIME,              -- Creation timestamp
    updated_at DATETIME               -- Last update timestamp
);
```

**Catatan**: ID di-generate secara manual di application layer untuk kompatibilitas SQLite.

## 🔧 Konfigurasi

### application.properties
```properties
# Database Configuration
spring.datasource.url=jdbc:sqlite:todos.db
spring.datasource.driver-class-name=org.sqlite.JDBC

# JPA/Hibernate Configuration
spring.jpa.database-platform=com.example.todoapi.SQLiteDialect
spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=true
spring.jpa.properties.hibernate.format_sql=true

# Server Configuration
server.port=8080
```

### Custom SQLite Dialect

Project menggunakan custom `SQLiteDialect` untuk kompatibilitas dengan Hibernate:

```java
public class SQLiteDialect extends Dialect {
    // Custom implementation untuk SQLite support
}
```

## 🏗️ Architecture

### Backend Architecture
- **Controller Layer**: `TodoController` - REST endpoints
- **Service Layer**: `TodoService` - Business logic
- **Repository Layer**: `TodoRepository` - Data access
- **Entity Layer**: `Todo` - Database mapping
- **Configuration**: CORS, SQLite dialect

### Frontend Architecture
- **Vanilla JavaScript**: No frameworks, lightweight
- **Modular functions**: Separated concerns
- **Async/await**: Modern JavaScript dengan error handling
- **Responsive CSS**: Mobile-first design

## 🚀 Development

### Menambah Fitur Baru

1. **Backend Changes**:
   - Tambah method di `TodoController`
   - Implementasi logic di `TodoService`
   - Update `Todo` entity jika perlu field baru

2. **Frontend Changes**:
   - Tambah HTML elements
   - Implementasi JavaScript functions
   - Update CSS untuk styling

3. **Database Changes**:
   - Update entity annotations
   - Restart aplikasi (ddl-auto=update)

### Build JAR untuk Production

```bash
# Build executable JAR
mvn clean package

# Run JAR
java -jar target/todo-api-1.0.0.jar
```

## 📝 Catatan Teknis

- **Database**: SQLite dibuat otomatis saat pertama kali run
- **CORS**: Sudah dikonfigurasi untuk menerima semua origins
- **Validation**: Bean validation di backend, client-side validation di frontend
- **Error Handling**: Comprehensive error handling di backend
- **ID Generation**: Manual ID generation untuk menghindari SQLite limitations
- **Partial Updates**: PUT endpoint support partial updates

## 🐛 Troubleshooting

### Backend tidak bisa start
```bash
# Check Java version
java -version

# Check Maven
mvn -version

# Check port 8080
lsof -i :8080

# Clean and rebuild
mvn clean compile
```

### Frontend tidak connect ke backend
```bash
# Check backend is running
curl http://localhost:8080/api/todos

# Check browser console untuk CORS errors
# Pastikan API_BASE URL di JavaScript benar
```

### Database issues
```bash
# Hapus database dan restart
rm todos.db
mvn spring-boot:run

# Check application.properties
cat src/main/resources/application.properties
```

### Build issues
```bash
# Force clean build
mvn clean install -DskipTests

# Check Maven dependencies
mvn dependency:tree
```

## 📊 Tech Stack

- **Backend**: Java 17, Spring Boot 3, Spring Data JPA, Hibernate
- **Database**: SQLite 3
- **Frontend**: HTML5, CSS3, Vanilla JavaScript (ES6+)
- **Build Tool**: Maven
- **Testing**: cURL scripts untuk API testing

## 🎯 Performance

- **Lightweight**: No heavy frameworks
- **Fast startup**: Spring Boot optimization
- **Efficient queries**: JPA dengan custom queries
- **Minimal bundle**: Vanilla JavaScript, no npm dependencies

---

**Ready to use!** Jalankan `./run-both.sh` dan buka `http://localhost:3000` di browser Anda.