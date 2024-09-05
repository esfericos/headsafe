use axum::{extract::State, http::StatusCode, response::IntoResponse, routing::post, Json, Router};
use serde::Deserialize;
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
                    Err(e) => {
                        error!("Failed to parse date: {}, error: {}", meta.date_taken, e);
                        false
                    }
                };
    
                let mut file_content = Vec::new();
                if let Err(e) = file.read_to_end(&mut file_content).await {
                    error!("Failed to read file: {:?}, error: {}", file_path, e);
                    continue; // Skip this file if it can't be read
                }
            })
            .collect();
            
            if new_images.is_empty() {
               return  (StatusCode::OK, "No new images available").into_response()
            } else {
               return Json(new_images).into_response()
            }

        },
        Err(e) => {
            error!("Failed to load metadata: {}", e);
            (StatusCode::INTERNAL_SERVER_ERROR, "Failed to load images").into_response()
        },
    }
}
