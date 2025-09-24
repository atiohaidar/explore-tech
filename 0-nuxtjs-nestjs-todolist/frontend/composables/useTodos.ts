import { ref, onMounted } from 'vue'

interface Todo {
  _id: string
  title: string
  completed: boolean
  createdAt: string
}

export const useTodos = () => {
  const apiBase = 'http://localhost:3001'

  const todos = ref<Todo[]>([])
  const loading = ref(false)

  const fetchTodos = async () => {
    loading.value = true
    try {
      const response = await fetch(`${apiBase}/todo`)
      todos.value = await response.json()
    } catch (error) {
      console.error('Error fetching todos:', error)
    } finally {
      loading.value = false
    }
  }

  const addTodo = async (title: string) => {
    try {
      const response = await fetch(`${apiBase}/todo`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ title })
      })
      const newTodo = await response.json()
      todos.value.push(newTodo)
    } catch (error) {
      console.error('Error adding todo:', error)
    }
  }

  const updateTodo = async (id: string, updates: { title?: string; completed?: boolean }) => {
    try {
      const response = await fetch(`${apiBase}/todo/${id}`, {
        method: 'PUT',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(updates)
      })
      const updatedTodo = await response.json()
      const index = todos.value.findIndex(t => t._id === id)
      if (index !== -1) {
        todos.value[index] = updatedTodo
      }
    } catch (error) {
      console.error('Error updating todo:', error)
    }
  }

  const deleteTodo = async (id: string) => {
    try {
      await fetch(`${apiBase}/todo/${id}`, {
        method: 'DELETE'
      })
      todos.value = todos.value.filter(t => t._id !== id)
    } catch (error) {
      console.error('Error deleting todo:', error)
    }
  }

  onMounted(() => {
    fetchTodos()
  })

  return {
    todos,
    loading,
    fetchTodos,
    addTodo,
    updateTodo,
    deleteTodo
  }
}