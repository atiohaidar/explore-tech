use serde::{Deserialize, Serialize};

#[derive(Clone)]
pub struct AppState {
    pub db: std::sync::Arc<tokio::sync::Mutex<rusqlite::Connection>>,
}

#[derive(Serialize, Deserialize, Debug, Clone)]
pub struct Todo {
    pub id: String,
    pub title: String,
    pub completed: bool,
    pub created_at: String,
}

#[derive(Deserialize)]
pub struct CreateTodo {
    pub title: String,
}

#[derive(Deserialize)]
pub struct UpdateTodo {
    pub title: String,
    pub completed: bool,
}