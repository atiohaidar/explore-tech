use axum::{
    extract::{Path, State},
    http::StatusCode,
    response::{Html, Redirect},
    Form,
};
use askama::Template;
use crate::models::{AppState, CreateTodo, Todo, UpdateTodo};
use crate::database;
use uuid::Uuid;

#[derive(Template)]
#[template(path = "index.html")]
struct IndexTemplate {
    todos: Vec<Todo>,
    completed_count: usize,
    total_count: usize,
}

#[derive(Template)]
#[template(path = "edit.html")]
struct EditTemplate {
    todo: Todo,
}

pub async fn index(State(state): State<AppState>) -> Html<String> {
    let db = state.db.lock().await;
    let todos = database::get_all_todos(&db).unwrap_or_default();
    let completed_count = todos.iter().filter(|t| t.completed).count();
    let total_count = todos.len();
    let template = IndexTemplate { todos, completed_count, total_count };
    Html(template.render().unwrap())
}

pub async fn create_todo(
    State(state): State<AppState>,
    Form(create_todo): Form<CreateTodo>,
) -> Redirect {
    if create_todo.title.trim().is_empty() {
        return Redirect::to("/");
    }

    let todo = Todo {
        id: Uuid::new_v4().to_string(),
        title: create_todo.title.trim().to_string(),
        completed: false,
        created_at: chrono::Utc::now().to_rfc3339(),
    };

    let db = state.db.lock().await;
    let _ = database::create_todo(&db, &todo);

    Redirect::to("/")
}

pub async fn toggle_todo(
    State(state): State<AppState>,
    Path(id): Path<String>,
) -> Redirect {
    let db = state.db.lock().await;
    if let Ok(Some(mut todo)) = database::get_todo_by_id(&db, &id) {
        todo.completed = !todo.completed;
        let _ = database::update_todo(&db, &id, &todo.title, todo.completed);
    }

    Redirect::to("/")
}

pub async fn delete_todo(
    State(state): State<AppState>,
    Path(id): Path<String>,
) -> Redirect {
    let db = state.db.lock().await;
    let _ = database::delete_todo(&db, &id);

    Redirect::to("/")
}

pub async fn edit_todo_form(
    State(state): State<AppState>,
    Path(id): Path<String>,
) -> Result<Html<String>, StatusCode> {
    let db = state.db.lock().await;
    match database::get_todo_by_id(&db, &id) {
        Ok(Some(todo)) => {
            let template = EditTemplate { todo };
            Ok(Html(template.render().unwrap()))
        }
        _ => Err(StatusCode::NOT_FOUND),
    }
}

pub async fn update_todo(
    State(state): State<AppState>,
    Path(id): Path<String>,
    Form(update_todo): Form<UpdateTodo>,
) -> Redirect {
    let db = state.db.lock().await;
    let _ = database::update_todo(&db, &id, &update_todo.title, update_todo.completed);

    Redirect::to("/")
}

pub async fn clear_completed(State(state): State<AppState>) -> Redirect {
    let db = state.db.lock().await;
    // Delete all completed todos
    let todos = database::get_all_todos(&db).unwrap_or_default();
    for todo in todos.iter().filter(|t| t.completed) {
        let _ = database::delete_todo(&db, &todo.id);
    }

    Redirect::to("/")
}