mod models;
mod database;
mod handlers;

use axum::{
    routing::{get, post},
    Router,
};
use std::sync::Arc;
use tokio::sync::Mutex;
use tower_http::services::ServeDir;

use models::AppState;
use handlers::{index, create_todo, toggle_todo, delete_todo, edit_todo_form, update_todo, clear_completed};

#[tokio::main]
async fn main() {
    // Initialize database
    let db = database::setup_database().expect("Failed to setup database");
    let state = AppState { db: Arc::new(Mutex::new(db)) };

    // Build the application
    let app = Router::new()
        .route("/", get(index))
        .route("/todos", post(create_todo))
        .route("/todos/:id/toggle", post(toggle_todo))
        .route("/todos/:id/edit", get(edit_todo_form).post(update_todo))
        .route("/todos/:id/delete", post(delete_todo))
        .route("/todos/completed/clear", post(clear_completed))
        .nest_service("/static", ServeDir::new("static"))
        .with_state(state);

    // Run the server
    let listener = tokio::net::TcpListener::bind("127.0.0.1:3000")
        .await
        .unwrap();
    println!("🚀 Server running on http://127.0.0.1:3000");
    axum::serve(listener, app).await.unwrap();
}
