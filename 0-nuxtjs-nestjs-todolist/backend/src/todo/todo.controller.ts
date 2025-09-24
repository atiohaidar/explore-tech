import { Controller, Get, Post, Put, Delete, Body, Param, NotFoundException } from '@nestjs/common';
import { TodoService } from './todo.service';
import { Todo } from './schemas/todo.schema';

@Controller('todo')
export class TodoController {
  constructor(private readonly todoService: TodoService) {}

  @Post()
  async create(@Body('title') title: string): Promise<Todo> {
    return this.todoService.create(title);
  }

  @Get()
  async findAll(): Promise<Todo[]> {
    return this.todoService.findAll();
  }

  @Get(':id')
  async findOne(@Param('id') id: string): Promise<Todo> {
    const todo = await this.todoService.findOne(id);
    if (!todo) {
      throw new NotFoundException('Todo not found');
    }
    return todo;
  }

  @Put(':id')
  async update(
    @Param('id') id: string,
    @Body() updateData: { title?: string; completed?: boolean },
  ): Promise<Todo> {
    const todo = await this.todoService.update(id, updateData.title, updateData.completed);
    if (!todo) {
      throw new NotFoundException('Todo not found');
    }
    return todo;
  }

  @Delete(':id')
  async delete(@Param('id') id: string): Promise<any> {
    return this.todoService.delete(id);
  }
}
