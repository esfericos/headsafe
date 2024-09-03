use serde::{Serialize, Deserialize};

#[derive(Serialize)]
pub struct ImageResponse {
    pub images: Vec<ImageData>,
}

#[derive(Clone, Serialize, Deserialize)]
pub struct ImageData {
    pub image: String, 
    pub date_taken: String,
}