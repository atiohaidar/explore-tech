# Todo List App - Enhanced Version

A beautiful and modern todo list application built with NestJS, Nuxt.js, and MongoDB.

## ✨ Features

### 🎨 Modern UI Design
- **Gradient Background**: Beautiful blue to purple gradient background
- **Glass Morphism**: Semi-transparent cards with backdrop blur effects
- **Smooth Animations**: Hover effects, transitions, and micro-interactions
- **Responsive Design**: Works perfectly on all screen sizes

### 📊 Progress Tracking
- **Visual Progress Bar**: Shows completion percentage
- **Statistics Card**: Displays completed vs total tasks
- **Real-time Updates**: Progress updates instantly

### 🎯 Enhanced UX
- **Smart Empty State**: Beautiful illustration when no tasks exist
- **Loading States**: Elegant loading indicators
- **Hover Effects**: Interactive elements with smooth transitions
- **Completion Animations**: Visual feedback when tasks are completed

### 🛠️ Advanced Features
- **Clear Completed**: Bulk delete all completed tasks
- **Date Formatting**: Smart relative dates (today, yesterday, X days ago)
- **Edit Mode**: Click pencil icon to edit tasks (UI ready)
- **Keyboard Support**: Press Enter to add tasks quickly

## 🚀 Getting Started

### Prerequisites
- Node.js 18+
- Docker (for MongoDB)
- npm or yarn

### Installation

1. **Clone and navigate to the project:**
   ```bash
   cd 0-nuxtjs-nestjs-todolist
   ```

2. **Start all services:**
   ```bash
   ./start-services.sh
   ```

   This will start:
   - MongoDB (Docker): `localhost:27017`
   - Backend (NestJS): `http://localhost:3001`
   - Frontend (Nuxt.js): `http://localhost:3000`

3. **Insert sample data (optional):**
   ```bash
   ./insert-sample-todos.sh
   ```

## 📱 Usage

### Adding Tasks
- Type your task in the input field
- Press Enter or click "Add Task" button
- Tasks appear instantly in the list

### Managing Tasks
- **Complete**: Click the checkbox to mark as done
- **Delete**: Hover over task and click trash icon
- **Clear Completed**: Use the button to remove all completed tasks

### Progress Tracking
- View your completion percentage in the stats card
- Watch the progress bar fill up as you complete tasks

## 🛠️ API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/todo` | Get all todos |
| POST | `/todo` | Create new todo |
| GET | `/todo/:id` | Get specific todo |
| PUT | `/todo/:id` | Update todo |
| DELETE | `/todo/:id` | Delete todo |

## 🧪 Testing

### Backend Tests
```bash
cd backend
npm run test
```

### Manual Testing with cURL
```bash
# Get all todos
curl http://localhost:3001/todo

# Add new todo
curl -X POST http://localhost:3001/todo \
  -H "Content-Type: application/json" \
  -d '{"title": "Test todo"}'

# Update todo (replace ID)
curl -X PUT http://localhost:3001/todo/[ID] \
  -H "Content-Type: application/json" \
  -d '{"completed": true}'

# Delete todo (replace ID)
curl -X DELETE http://localhost:3001/todo/[ID]
```

## 🎨 Design Highlights

- **Color Scheme**: Blue and purple gradients for modern look
- **Typography**: Clean, readable fonts with proper hierarchy
- **Icons**: Heroicons for consistent iconography
- **Shadows**: Subtle shadows for depth and focus
- **Spacing**: Generous whitespace for better readability
- **Animations**: Smooth transitions and hover effects

## 📁 Project Structure

```
0-nuxtjs-nestjs-todolist/
├── backend/                 # NestJS API server
│   ├── src/
│   │   ├── app.module.ts
│   │   ├── main.ts
│   │   ├── todo/
│   │   │   ├── todo.controller.ts
│   │   │   ├── todo.service.ts
│   │   │   ├── todo.module.ts
│   │   │   └── schemas/todo.schema.ts
│   │   └── ...
│   └── test/
├── frontend/                # Nuxt.js client
│   ├── pages/index.vue
│   ├── composables/useTodos.ts
│   └── ...
├── start-services.sh        # Startup script
├── insert-sample-todos.sh   # Sample data script
├── curl-commands.txt        # API testing commands
└── README-API.md           # API documentation
```

## 🔧 Technologies Used

- **Backend**: NestJS, MongoDB, Mongoose
- **Frontend**: Nuxt.js, Vue 3, TypeScript
- **UI**: @nuxt/ui, Tailwind CSS, Heroicons
- **Database**: MongoDB (Docker)
- **Testing**: Jest, Supertest

## 📝 License

This project is for educational purposes.

---

Built with ❤️ using modern web technologies