use rusqlite::{params, Connection, Result};
use crate::models::Todo;

pub fn setup_database() -> Result<Connection> {
    let conn = Connection::open("todos.db")?;

    conn.execute(
        "CREATE TABLE IF NOT EXISTS todos (
            id TEXT PRIMARY KEY,
            title TEXT NOT NULL,
            completed BOOLEAN NOT NULL DEFAULT 0,
            created_at TEXT NOT NULL
        )",
        [],
    )?;

    Ok(conn)
}

pub fn get_all_todos(conn: &Connection) -> Result<Vec<Todo>> {
    let mut stmt = conn.prepare("SELECT id, title, completed, created_at FROM todos ORDER BY created_at DESC")?;
    let todo_iter = stmt.query_map([], |row| {
        Ok(Todo {
            id: row.get(0)?,
            title: row.get(1)?,
            completed: row.get(2)?,
            created_at: row.get(3)?,
        })
    })?;

    let mut todos = Vec::new();
    for todo in todo_iter {
        todos.push(todo?);
    }
    Ok(todos)
}

pub fn create_todo(conn: &Connection, todo: &Todo) -> Result<()> {
    conn.execute(
        "INSERT INTO todos (id, title, completed, created_at) VALUES (?1, ?2, ?3, ?4)",
        params![todo.id, todo.title, todo.completed, todo.created_at],
    )?;
    Ok(())
}

pub fn get_todo_by_id(conn: &Connection, id: &str) -> Result<Option<Todo>> {
    let mut stmt = conn.prepare("SELECT id, title, completed, created_at FROM todos WHERE id = ?1")?;
    let mut rows = stmt.query_map(params![id], |row| {
        Ok(Todo {
            id: row.get(0)?,
            title: row.get(1)?,
            completed: row.get(2)?,
            created_at: row.get(3)?,
        })
    })?;

    match rows.next() {
        Some(todo) => Ok(Some(todo?)),
        None => Ok(None),
    }
}

pub fn update_todo(conn: &Connection, id: &str, title: &str, completed: bool) -> Result<()> {
    conn.execute(
        "UPDATE todos SET title = ?1, completed = ?2 WHERE id = ?3",
        params![title, completed, id],
    )?;
    Ok(())
}

pub fn delete_todo(conn: &Connection, id: &str) -> Result<()> {
    conn.execute("DELETE FROM todos WHERE id = ?1", params![id])?;
    Ok(())
}