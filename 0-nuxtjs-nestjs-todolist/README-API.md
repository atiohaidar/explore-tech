# Todo List API - Cara Insert Data

## Persiapan
Pastikan backend sudah running di http://localhost:3001

## Cara Insert Data Todo

### 1. Menggunakan Script Otomatis
```bash
./insert-sample-todos.sh
```

### 2. Menggunakan Curl Manual

#### Create Todo Baru
```bash
curl -X POST "http://localhost:3001/todo" \
  -H "Content-Type: application/json" \
  -d '{"title": "Judul todo Anda"}'
```

#### Contoh:
```bash
# Todo 1
curl -X POST "http://localhost:3001/todo" \
  -H "Content-Type: application/json" \
  -d '{"title": "Belajar NestJS"}'

# Todo 2
curl -X POST "http://localhost:3001/todo" \
  -H "Content-Type: application/json" \
  -d '{"title": "Belajar Nuxt.js"}'

# Todo 3
curl -X POST "http://localhost:3001/todo" \
  -H "Content-Type: application/json" \
  -d '{"title": "Setup MongoDB"}'
```

### 3. Operasi Lainnya

#### Lihat Semua Todos
```bash
curl "http://localhost:3001/todo"
```

#### Lihat Todo Spesifik (ganti [ID] dengan ID sebenarnya)
```bash
curl "http://localhost:3001/todo/[ID]"
```

#### Update Todo (ganti [ID] dengan ID sebenarnya)
```bash
curl -X PUT "http://localhost:3001/todo/[ID]" \
  -H "Content-Type: application/json" \
  -d '{"title": "Judul baru", "completed": true}'
```

#### Delete Todo (ganti [ID] dengan ID sebenarnya)
```bash
curl -X DELETE "http://localhost:3001/todo/[ID]"
```

## Response Format
Setiap todo akan memiliki format:
```json
{
  "_id": "mongo_object_id",
  "title": "Judul todo",
  "completed": false,
  "createdAt": "2025-09-26T00:00:00.000Z"
}
```