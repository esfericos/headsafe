use serde::{Serialize, Deserialize};

#[derive(Serialize)]
pub struct ImageResponse {
    pub images: Vec<Image>,
}

/// Image as base64.
#[derive(Clone, Debug, Serialize, Deserialize)]
pub struct Image {
    pub image: String, 
    pub date_taken: String,
}

#[derive(Serialize, Deserialize)]
pub struct ImageMetadata {
    pub file_path: String,
    pub date_taken: String,
}