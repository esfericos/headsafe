use std::path::PathBuf;
use tokio::fs::{File, OpenOptions};
use tokio::io::AsyncWriteExt;
use tracing::info;
use uuid::Uuid;

use crate::image::{Image, ImageMetadata};

#[derive(Clone)]
pub struct Storage {
    pub base_path: PathBuf,
}

impl Storage {
    pub fn new(base_path: PathBuf) -> Self {
        Storage { base_path }
    }

    pub async fn store_image(&self, image: Image) -> eyre::Result<()> {
        let filename = format!("{}.bin", Uuid::new_v4());
        let file_path = self.base_path.join(&filename);

        let mut file = File::create(&file_path).await?;
        file.write_all(image.image.as_bytes()).await?;
        file.write_all(b"\n").await?;
        file.flush().await?;

        let metadata = ImageMetadata {
            file_path: file_path.to_string_lossy().into_owned(),
            date_taken: image.date_taken,
        };

        let metadata_path = self.base_path.join("metadata.json");
        let mut metadata_file = OpenOptions::new()
            .create(true)
            .append(true)
            .open(metadata_path)
            .await?;
        
        let metadata_json = serde_json::to_string(&metadata)?;
        metadata_file.write_all(metadata_json.as_bytes()).await?;
        metadata_file.write_all(b"\n").await?;
        metadata_file.flush().await?;

        info!(
            "Stored image at: {:?}, taken on: {}",
            file_path, metadata.date_taken
        );

        Ok(())
    }

    pub async fn load_metadata(&self) -> eyre::Result<Vec<ImageMetadata>> {
        let metadata_path = self.base_path.join("metadata.json");
        let content = tokio::fs::read_to_string(metadata_path).await?;
        let metadata: Vec<ImageMetadata> = content
            .lines()
            .filter_map(|line| serde_json::from_str::<ImageMetadata>(line).ok())
            .collect();
        Ok(metadata)
    }
}