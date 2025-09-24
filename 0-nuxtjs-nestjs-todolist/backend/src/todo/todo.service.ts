import { Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { Todo, TodoDocument } from './schemas/todo.schema';

@Injectable()
export class TodoService {
    constructor(
        @InjectModel(Todo.name) private todoModel: Model<TodoDocument>,
    ) { }

    async create(title: string): Promise<Todo> {
        const createdTodo = new this.todoModel({ title });
        return createdTodo.save();
    }

    async findAll(): Promise<Todo[]> {
        return this.todoModel.find().exec();
    }

    async findOne(id: string): Promise<TodoDocument | null> {
        return this.todoModel.findById(id).exec();
    }

    async update(id: string, title?: string, completed?: boolean): Promise<TodoDocument | null> {
        return this.todoModel.findByIdAndUpdate(id, { title, completed }, { new: true }).exec();
    }

    async delete(id: string): Promise<any> {
        return this.todoModel.findByIdAndDelete(id).exec();
    }

}
