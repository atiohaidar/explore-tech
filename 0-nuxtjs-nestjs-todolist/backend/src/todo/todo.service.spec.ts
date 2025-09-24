import { Test, TestingModule } from '@nestjs/testing';
import { MongooseModule } from '@nestjs/mongoose';
import mongoose from 'mongoose';
import { TodoService } from './todo.service';
import { Todo, TodoSchema } from './schemas/todo.schema';

describe('TodoService', () => {
  let service: TodoService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      imports: [MongooseModule.forRoot('mongodb://localhost:27017/test'), MongooseModule.forFeature([{ name: Todo.name, schema: TodoSchema }])],
      providers: [TodoService],
    }).compile();

    service = module.get<TodoService>(TodoService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  describe('create', () => {
    it('should create a new todo', async () => {
      const title = 'Test Todo';
      const todo = await service.create(title);
      expect(todo).toBeDefined();
      expect(todo.title).toBe(title);
      expect(todo.completed).toBe(false);
      expect(todo.createdAt).toBeDefined();
    });
  });

  describe('findAll', () => {
    it('should return an array of todos', async () => {
      const todos = await service.findAll();
      expect(Array.isArray(todos)).toBe(true);
    });
  });

  describe('findOne', () => {
    it('should return a todo by id', async () => {
      const title = 'Test Todo for findOne';
      const createdTodo = await service.create(title);
      const foundTodo = await service.findOne((createdTodo as any)._id.toString());
      expect(foundTodo).toBeDefined();
      expect(foundTodo?.title).toBe(title);
    });

    it('should return null for non-existent id', async () => {
      const nonExistentId = new mongoose.Types.ObjectId().toString();
      const foundTodo = await service.findOne(nonExistentId);
      expect(foundTodo).toBeNull();
    });
  });

  describe('update', () => {
    it('should update a todo', async () => {
      const title = 'Test Todo for update';
      const createdTodo = await service.create(title);
      const updatedTodo = await service.update((createdTodo as any)._id.toString(), 'Updated Title', true);
      expect(updatedTodo).toBeDefined();
      expect(updatedTodo?.title).toBe('Updated Title');
      expect(updatedTodo?.completed).toBe(true);
    });

    it('should return null for non-existent id', async () => {
      const nonExistentId = new mongoose.Types.ObjectId().toString();
      const updatedTodo = await service.update(nonExistentId, 'Updated Title');
      expect(updatedTodo).toBeNull();
    });
  });

  describe('delete', () => {
    it('should delete a todo', async () => {
      const title = 'Test Todo for delete';
      const createdTodo = await service.create(title);
      const result = await service.delete((createdTodo as any)._id.toString());
      expect(result).toBeDefined();
      const foundTodo = await service.findOne((createdTodo as any)._id.toString());
      expect(foundTodo).toBeNull();
    });
  });
});
