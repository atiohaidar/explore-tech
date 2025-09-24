import { Test, TestingModule } from '@nestjs/testing';
import { MongooseModule } from '@nestjs/mongoose';
import { INestApplication } from '@nestjs/common';
import request from 'supertest';
import { TodoController } from './todo.controller';
import { TodoService } from './todo.service';
import { Todo, TodoSchema } from './schemas/todo.schema';

describe('TodoController (e2e)', () => {
  let app: INestApplication;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      imports: [MongooseModule.forRoot('mongodb://localhost:27017/test'), MongooseModule.forFeature([{ name: Todo.name, schema: TodoSchema }])],
      controllers: [TodoController],
      providers: [TodoService],
    }).compile();

    app = module.createNestApplication();
    await app.init();
  });

  afterEach(async () => {
    await app.close();
  });

  it('/todo (GET)', () => {
    return request(app.getHttpServer())
      .get('/todo')
      .expect(200)
      .expect((res) => {
        expect(Array.isArray(res.body)).toBe(true);
      });
  });

  it('/todo (POST)', () => {
    return request(app.getHttpServer())
      .post('/todo')
      .send({ title: 'Test Todo' })
      .expect(201)
      .expect((res) => {
        expect(res.body).toHaveProperty('_id');
        expect(res.body.title).toBe('Test Todo');
        expect(res.body.completed).toBe(false);
      });
  });

  it('/todo/:id (GET) not found', () => {
    const nonExistentId = '507f1f77bcf86cd799439011'; // valid ObjectId format
    return request(app.getHttpServer())
      .get(`/todo/${nonExistentId}`)
      .expect(404);
  });

  it('/todo/:id (PUT) not found', () => {
    const nonExistentId = '507f1f77bcf86cd799439011';
    return request(app.getHttpServer())
      .put(`/todo/${nonExistentId}`)
      .send({ title: 'Updated Title' })
      .expect(404);
  });

  it('/todo/:id (DELETE)', async () => {
    const createResponse = await request(app.getHttpServer())
      .post('/todo')
      .send({ title: 'Test Todo for DELETE' });

    const todoId = createResponse.body._id;

    await request(app.getHttpServer())
      .delete(`/todo/${todoId}`)
      .expect(200);

    return request(app.getHttpServer())
      .get(`/todo/${todoId}`)
      .expect(404);
  });
});
