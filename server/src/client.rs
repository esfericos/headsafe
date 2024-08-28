use axum::{extract::State, http::StatusCode, response::IntoResponse, routing::post, Json, Router};
use serde::Deserialize;

use crate::stg::StorageHandle;

#[derive(Clone, Deserialize)]
pub struct ImageData {
    pub image: String,  // Base64 encoded image
    pub date_taken: String,
    pub place_name: String,
}

#[derive(Clone)]
pub struct HttpState {
    pub storage_handle: StorageHandle,
}

pub(crate) async fn store_data(
    State(state): State<HttpState>,
    Json(payload): axum::Json<ImageData>,
) -> impl IntoResponse{

    if !payload.image.is_empty() && !payload.date_taken.is_empty() && !payload.place_name.is_empty() {
        state.storage_handle.store_image(payload).await;
        (StatusCode::OK, "Image stored successfully")
    } else {
        (StatusCode::BAD_REQUEST, "Missing required fields")
    }
}

pub fn start_server(state: HttpState) -> Router {
    Router::new()
        .route("/", post(store_data))
        .with_state(state)
}