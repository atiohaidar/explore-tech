<template>
  <div class="min-h-screen bg-gradient-to-br from-blue-50 via-white to-purple-50 py-8 px-4">
    <div class="container mx-auto max-w-4xl">
      <!-- Header Section -->
      <div class="text-center mb-8">
        <div class="inline-flex items-center gap-3 mb-4">
          <div class="p-3 bg-gradient-to-r from-blue-500 to-purple-600 rounded-full shadow-lg">
            <UIcon name="i-heroicons-check-circle" class="w-8 h-8 text-white" />
          </div>
          <h1 class="text-4xl font-bold bg-gradient-to-r from-blue-600 to-purple-600 bg-clip-text text-transparent">
            Todo List App
          </h1>
        </div>
        <p class="text-gray-600 text-lg">Stay organized and get things done!</p>
      </div>

      <!-- Simple Test Card -->
      <div class="bg-white rounded-lg shadow-lg p-6 mb-6">
        <h2 class="text-2xl font-bold text-blue-600 mb-4">CSS Test</h2>
        <p class="text-gray-700 mb-4">Jika Anda melihat styling ini, berarti CSS berfungsi!</p>
        <div class="bg-blue-500 text-white p-4 rounded-lg mb-4">
          <strong>Background biru dengan text putih</strong>
        </div>
        <div class="bg-green-500 text-white p-4 rounded-lg mb-4">
          <strong>Background hijau dengan text putih</strong>
        </div>
        <button class="bg-purple-500 hover:bg-purple-700 text-white font-bold py-2 px-4 rounded">
          Tombol Test
        </button>
      </div>

      <!-- Add Todo Card -->
      <UCard class="mb-6 shadow-lg border-0 bg-white/80 backdrop-blur-sm">
        <template #header>
          <div class="flex items-center gap-2">
            <UIcon name="i-heroicons-plus-circle" class="w-5 h-5 text-blue-500" />
            <h2 class="text-xl font-semibold text-gray-800">Add New Task</h2>
          </div>
        </template>

        <div class="flex gap-3">
          <UInput
            v-model="newTodoTitle"
            placeholder="What needs to be done?"
            @keyup.enter="addTodoHandler"
            class="flex-1 text-lg"
            size="lg"
          />
          <UButton
            @click="addTodoHandler"
            :disabled="!newTodoTitle.trim()"
            size="lg"
            class="px-8 bg-gradient-to-r from-blue-500 to-purple-600 hover:from-blue-600 hover:to-purple-700 shadow-lg"
          >
            <UIcon name="i-heroicons-plus" class="w-5 h-5 mr-2" />
            Add Task
          </UButton>
        </div>
      </UCard>

      <!-- Loading State -->
      <div v-if="loading" class="text-center py-12">
        <div class="inline-flex items-center gap-3 px-6 py-4 bg-white rounded-full shadow-lg">
          <UIcon name="i-heroicons-arrow-path" class="w-6 h-6 animate-spin text-blue-500" />
          <span class="text-gray-600 font-medium">Loading your tasks...</span>
        </div>
      </div>

      <!-- Empty State -->
      <div v-else-if="todos.length === 0" class="text-center py-16">
        <div class="max-w-md mx-auto">
          <div class="p-6 bg-gradient-to-br from-gray-50 to-gray-100 rounded-2xl shadow-lg mb-6">
            <UIcon name="i-heroicons-clipboard-document-list" class="w-16 h-16 text-gray-400 mx-auto mb-4" />
            <h3 class="text-xl font-semibold text-gray-700 mb-2">No tasks yet</h3>
            <p class="text-gray-500">Start by adding your first task above!</p>
          </div>
        </div>
      </div>

      <!-- Todo List -->
      <div v-else class="space-y-3">
        <div class="flex items-center justify-between mb-4">
          <h2 class="text-xl font-semibold text-gray-800 flex items-center gap-2">
            <UIcon name="i-heroicons-queue-list" class="w-5 h-5" />
            Your Tasks ({{ todos.length }})
          </h2>
        </div>

        <div class="grid gap-3">
          <div
            v-for="todo in todos"
            :key="todo._id"
            class="bg-white rounded-xl shadow-md hover:shadow-xl transition-all duration-300 border border-gray-100 overflow-hidden p-4"
          >
            <div class="flex items-center gap-4">
              <!-- Checkbox -->
              <UCheckbox
                :model-value="todo.completed"
                @update:model-value="toggleTodo(todo._id, $event)"
                class="w-5 h-5"
              />

              <!-- Todo Content -->
              <div class="flex-1 min-w-0">
                <p
                  class="text-lg font-medium transition-all duration-300"
                  :class="{
                    'line-through text-gray-400': todo.completed,
                    'text-gray-900': !todo.completed
                  }"
                >
                  {{ todo.title }}
                </p>
                <p class="text-sm text-gray-500 mt-1">
                  Created {{ formatDate(todo.createdAt) }}
                </p>
              </div>

              <!-- Actions -->
              <UButton
                variant="ghost"
                size="sm"
                @click="deleteTodo(todo._id)"
                class="text-red-500 hover:text-red-700 hover:bg-red-50"
              >
                <UIcon name="i-heroicons-trash" class="w-4 h-4" />
              </UButton>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
const { todos, loading, addTodo, updateTodo, deleteTodo } = useTodos()

const newTodoTitle = ref('')

// Computed properties
const completedTodos = computed(() => todos.value.filter(todo => todo.completed).length)

// Methods
const addTodoHandler = async () => {
  if (newTodoTitle.value.trim()) {
    await addTodo(newTodoTitle.value.trim())
    newTodoTitle.value = ''
  }
}

const toggleTodo = async (id: string, completed: boolean) => {
  await updateTodo(id, { completed })
}

const formatDate = (dateString: string) => {
  const date = new Date(dateString)
  const now = new Date()
  const diffTime = Math.abs(now.getTime() - date.getTime())
  const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24))

  if (diffDays === 1) return 'today'
  if (diffDays === 2) return 'yesterday'
  if (diffDays <= 7) return `${diffDays - 1} days ago`
  return date.toLocaleDateString()
}
</script>