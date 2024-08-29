use axum::{extract::State, http::StatusCode, response::IntoResponse, routing::post, Json, Router};
use serde::Deserialize;

use crate::stg::Storage;

#[derive(Clone, Deserialize)]
pub struct ImageData {
    pub image: String, 
    pub date_taken: String,
    pub place_name: String,
}

#[derive(Clone)]
pub struct HttpState {
    pub storage: Storage,
}

pub(crate) async fn store_data(
    State(state): State<HttpState>,
    Json(payload): axum::Json<ImageData>,
) -> impl IntoResponse{
    if !payload.image.is_empty() && !payload.date_taken.is_empty() && !payload.place_name.is_empty() {
        match state.storage.store_image(payload).await {
            Ok(_) => (StatusCode::OK, "Image stored successfully"),
            Err(e) => {
                eprintln!("Error storing image: {}", e);
                (StatusCode::INTERNAL_SERVER_ERROR, "Failed to store image")
            }
        }
    } else {
        (StatusCode::BAD_REQUEST, "Missing required fields")
    }
}

pub fn start_server(state: HttpState) -> Router {
    Router::new()
        .route("/", post(store_data))
        .with_state(state)
}