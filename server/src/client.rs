use axum::{extract::State, http::StatusCode, response::IntoResponse, routing::post, Json, Router};
use base64::Engine;
use serde::Deserialize;
use serde_json::json;
use tokio::fs::File;
use tokio::io::AsyncReadExt;
use tracing::{self, error, info};

use crate::stg::Storage;
use crate::image::*;

#[derive(Clone, Deserialize, Debug)]
pub struct LastRequest {
    pub last_req: String,
}

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
    Json(payload): axum::Json<Image>,
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
    Json(lr): axum::Json<LastRequest>,
    ) -> impl IntoResponse {
    let last_request_time = match chrono::NaiveDateTime::parse_from_str(&lr.last_req, "%Y-%m-%d %H:%M") {
        Ok(date) => date,
        Err(_) => return (StatusCode::BAD_REQUEST, "Invalid date format").into_response(),
    };

    match state.storage.load_metadata().await {
        Ok(m) => {
            let new_images: Vec<_> = m
                .into_iter()
                .filter(|meta| {
                    // Parse the date_taken to compare with last_request_time
                    chrono::NaiveDateTime::parse_from_str(&meta.date_taken, "%Y-%m-%d %H:%M")
                        .map(|date_taken| date_taken > last_request_time)
                        .unwrap_or(false)
                })
                .collect();
            
            if new_images.is_empty() {
                return (StatusCode::OK, "No new images available").into_response();
            }
    
            let mut image_responses = Vec::new();
    
            for meta in new_images {
                // Read the file contents for the selected images
                let file_path = meta.file_path;
                let mut file = match File::open(&file_path).await {
                    Ok(f) => f,
                    Err(e) => {
                        error!("Failed to open file: {:?}, error: {}", file_path, e);
                        continue; 
                    }
                };
    
                let mut file_content = Vec::new();
                if let Err(e) = file.read_to_end(&mut file_content).await {
                    error!("Failed to read file: {:?}, error: {}", file_path, e);
                    continue; // Skip this file if it can't be read
                }
    
                // Add the file content and metadata to the response
                image_responses.push(json!({
                    "date_taken": meta.date_taken,
                    "image_content": base64::engine::general_purpose::STANDARD.encode(file_content) // Convert binary content to base64
                }));
            }
    
            // Return only the selected images as a JSON response
            Json(image_responses).into_response()
        },
        Err(e) => {
            error!("Failed to load metadata: {}", e);
            (StatusCode::INTERNAL_SERVER_ERROR, "Failed to load images").into_response()
        }
    }
}
