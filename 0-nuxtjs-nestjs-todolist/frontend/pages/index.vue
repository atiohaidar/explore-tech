<template>
  <div class="container mx-auto p-4 max-w-2xl">
    <UCard class="mb-6">
      <template #header>
        <h1 class="text-2xl font-bold">Todo List</h1>
      </template>

      <div class="space-y-4">
        <div class="flex gap-2">
          <UInput
            v-model="newTodoTitle"
            placeholder="Add a new todo..."
            @keyup.enter="addTodoHandler"
            class="flex-1"
          />
          <UButton @click="addTodoHandler" :disabled="!newTodoTitle.trim()">
            Add
          </UButton>
        </div>

        <div v-if="loading" class="text-center py-4">
          <UIcon name="i-heroicons-arrow-path" class="animate-spin" />
          Loading...
        </div>

        <div v-else-if="todos.length === 0" class="text-center py-8 text-gray-500">
          No todos yet. Add one above!
        </div>

        <div v-else class="space-y-2">
          <div
            v-for="todo in todos"
            :key="todo._id"
            class="flex items-center gap-3 p-3 border rounded-lg"
          >
            <UCheckbox
              :model-value="todo.completed"
              @update:model-value="toggleTodo(todo._id, $event)"
            />
            <span
              :class="{
                'line-through text-gray-500': todo.completed,
                'text-gray-900': !todo.completed
              }"
              class="flex-1"
            >
              {{ todo.title }}
            </span>
            <UButton
              variant="ghost"
              color="red"
              size="sm"
              @click="deleteTodo(todo._id)"
            >
              <UIcon name="i-heroicons-trash" />
            </UButton>
          </div>
        </div>
      </div>
    </UCard>
  </div>
</template>

<script setup lang="ts">
const { todos, loading, addTodo, updateTodo, deleteTodo } = useTodos()

const newTodoTitle = ref('')

const addTodoHandler = async () => {
  if (newTodoTitle.value.trim()) {
    await addTodo(newTodoTitle.value.trim())
    newTodoTitle.value = ''
  }
}

const toggleTodo = async (id: string, completed: boolean) => {
  await updateTodo(id, { completed })
}
</script>