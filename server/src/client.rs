use std::sync::Arc;

use axum::{extract::State, http::{HeaderMap, Request, StatusCode}, response::IntoResponse, routing::post, Json, Router};
use chrono::{DateTime, Utc};
use serde::Deserialize;
use tokio::sync::RwLock;
use tracing::{self, info};
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
    pub subscribers: Arc<RwLock<(Option<String>, Option<DateTime<Utc>>)>>,
}

pub async fn store_data(
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
        .route("/hello", post(hello_handle))
        .with_state(state)
}

/// The client will request connection to the server
/// the sever will reply with new availiable images
/// if there's any. 
pub async fn hello_handle(
    State(state): State<HttpState>,
    req: Request<axum::body::Body>,
    ) -> impl IntoResponse {
    info!("Adding new subscriber");
    let headers = req.headers();
    info!("{:#?}", headers);
    let client_ip = get_client_ip(headers);

    info!("{}", client_ip);

    // Update subscribers tuple.
    let mut subscribers = state.subscribers.write().await;
    subscribers.0 = Some(client_ip.to_string());
    subscribers.1 = Some(Utc::now());

    info!("Client IP: {}", client_ip);
    info!("Subscriber added: {:?}", subscribers.0);
    info!("Last request date: {:?}", subscribers.1);

    StatusCode::OK
}

fn get_client_ip(headers: &HeaderMap) -> &str {
    if let Some(forwarded_for) = headers.get("X-Forwarded-For") {
        if let Ok(value) = forwarded_for.to_str() {
            if let Some(ip) = value.split(',').next() {
                return ip.trim();
            }
        }
    }
    
    if let Some(real_ip) = headers.get("X-Real-IP") {
        if let Ok(value) = real_ip.to_str() {
            return value;
        }
    }
    
    // If neither header is available, fall back to "unknown"
    "unknown"
}