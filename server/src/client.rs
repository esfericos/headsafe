use std::fs;

use axum::{extract::State, http::StatusCode, response::IntoResponse, routing::post, Json, Router};
use serde::Deserialize;
use tracing::{self, error, info};

use crate::stg::Storage;
use crate::image::*;

#[derive(Clone, Deserialize, Debug)]
pub struct LastRequest(pub String);

#[derive(Clone)]
pub struct HttpState {
    pub storage: Storage,
}

pub fn start_server(state: HttpState) -> Router {
    Router::new()
        .route("/", post(store_data))
        .route("/hello", post(hello_handle))
        .with_state(state)
}

pub async fn store_data(
    State(state): State<HttpState>,
    Json(payload): axum::Json<ImageData>,
) -> impl IntoResponse{
    if !payload.image.is_empty() && !payload.date_taken.is_empty() {
        info!("Payload arrived: {:#?}", payload);
        match state.storage.store_image(payload).await {
            Ok(_) => (StatusCode::OK, "Image stored successfully"),
            Err(e) => {
                error!("Error storing image: {}", e);
                (StatusCode::INTERNAL_SERVER_ERROR, "Failed to store image")
            }
        }
    } else {
        (StatusCode::BAD_REQUEST, "Missing required fields")
    }
}

/// The client will request connection to the server
/// the sever will reply with new availiable images if there's any.
pub async fn hello_handle(
    State(state): State<HttpState>,
    Json(last_req): axum::Json<LastRequest>,
    ) -> impl IntoResponse {
    info!("New subscriber joined");
    info!("{:#?}", last_req);
    StatusCode::OK
}
