using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.DependencyInjection;
using System.Collections.Generic;
using System.Linq;
using Microsoft.Data.Sqlite;

namespace TodoList
{
    // Define Todo model
    public record Todo(int Id, string Title, bool IsCompleted);

    // DTO for creating/updating todos
    public record TodoDto(string Title, bool IsCompleted = false);

    public class Program
    {
        private static string ConnectionString = "Data Source=todos.db";

        public static void Main(string[] args)
        {
            InitializeDatabase();

            var builder = WebApplication.CreateBuilder(args);

            // Add services to the container.
            // Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
            builder.Services.AddEndpointsApiExplorer();
            builder.Services.AddSwaggerGen();
            builder.Services.AddCors(options =>
            {
                options.AddDefaultPolicy(builder =>
                {
                    builder.AllowAnyOrigin()
                           .AllowAnyMethod()
                           .AllowAnyHeader();
                });
            });

            var app = builder.Build();

            // Configure the HTTP request pipeline.
            if (app.Environment.IsDevelopment())
            {
                app.UseSwagger();
                app.UseSwaggerUI();
            }

            app.UseHttpsRedirection();
            app.UseCors();

            // GET /todos - Get all todos
            app.MapGet("/todos", () => GetTodos());

            // GET /todos/{id} - Get a specific todo
            app.MapGet("/todos/{id}", (int id) => GetTodo(id));

            // POST /todos - Create a new todo
            app.MapPost("/todos", (TodoDto todoDto) =>
            {
                var todo = AddTodo(todoDto.Title);
                return Results.Created($"/todos/{todo.Id}", todo);
            });

            // PUT /todos/{id} - Update a todo
            app.MapPut("/todos/{id}", (int id, TodoDto todoDto) =>
            {
                var updatedTodo = UpdateTodo(id, todoDto.Title, todoDto.IsCompleted);
                return updatedTodo != null ? Results.Ok(updatedTodo) : Results.NotFound();
            });

            // DELETE /todos/{id} - Delete a todo
            app.MapDelete("/todos/{id}", (int id) =>
            {
                return DeleteTodo(id) ? Results.NoContent() : Results.NotFound();
            });

            app.Run();
        }

        private static void InitializeDatabase()
        {
            using var connection = new SqliteConnection(ConnectionString);
            connection.Open();
            var command = connection.CreateCommand();
            command.CommandText = @"
                CREATE TABLE IF NOT EXISTS Todos (
                    Id INTEGER PRIMARY KEY AUTOINCREMENT,
                    Title TEXT NOT NULL,
                    IsCompleted INTEGER NOT NULL
                );
            ";
            command.ExecuteNonQuery();
        }

        private static List<Todo> GetTodos()
        {
            var todos = new List<Todo>();
            using var connection = new SqliteConnection(ConnectionString);
            connection.Open();
            var command = connection.CreateCommand();
            command.CommandText = "SELECT Id, Title, IsCompleted FROM Todos";
            using var reader = command.ExecuteReader();
            while (reader.Read())
            {
                todos.Add(new Todo(reader.GetInt32(0), reader.GetString(1), reader.GetBoolean(2)));
            }
            return todos;
        }

        private static Todo? GetTodo(int id)
        {
            using var connection = new SqliteConnection(ConnectionString);
            connection.Open();
            var command = connection.CreateCommand();
            command.CommandText = "SELECT Id, Title, IsCompleted FROM Todos WHERE Id = @id";
            command.Parameters.AddWithValue("@id", id);
            using var reader = command.ExecuteReader();
            if (reader.Read())
            {
                return new Todo(reader.GetInt32(0), reader.GetString(1), reader.GetBoolean(2));
            }
            return null;
        }

        private static Todo AddTodo(string title)
        {
            using var connection = new SqliteConnection(ConnectionString);
            connection.Open();
            var command = connection.CreateCommand();
            command.CommandText = "INSERT INTO Todos (Title, IsCompleted) VALUES (@title, 0); SELECT last_insert_rowid();";
            command.Parameters.AddWithValue("@title", title);
            var id = (long)command.ExecuteScalar();
            return new Todo((int)id, title, false);
        }

        private static Todo? UpdateTodo(int id, string title, bool isCompleted)
        {
            using var connection = new SqliteConnection(ConnectionString);
            connection.Open();
            var command = connection.CreateCommand();
            command.CommandText = "UPDATE Todos SET Title = @title, IsCompleted = @isCompleted WHERE Id = @id";
            command.Parameters.AddWithValue("@id", id);
            command.Parameters.AddWithValue("@title", title);
            command.Parameters.AddWithValue("@isCompleted", isCompleted ? 1 : 0);
            var rowsAffected = command.ExecuteNonQuery();
            if (rowsAffected > 0)
            {
                return new Todo(id, title, isCompleted);
            }
            return null;
        }

        private static bool DeleteTodo(int id)
        {
            using var connection = new SqliteConnection(ConnectionString);
            connection.Open();
            var command = connection.CreateCommand();
            command.CommandText = "DELETE FROM Todos WHERE Id = @id";
            command.Parameters.AddWithValue("@id", id);
            var rowsAffected = command.ExecuteNonQuery();
            return rowsAffected > 0;
        }
    }
}