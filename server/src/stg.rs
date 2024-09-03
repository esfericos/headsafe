use std::path::PathBuf;
use tokio::fs::File;
use tokio::io::AsyncWriteExt;
use uuid::Uuid;

use crate::image::ImageData;

#[derive(Clone)]
pub struct Storage {
    pub base_path: PathBuf,
}

impl Storage {
    pub fn new(base_path: PathBuf) -> Self {
        Storage { base_path }
    }

    pub async fn store_image(&self, data: ImageData) -> eyre::Result<()> {
        let filename = format!("{}.bin", Uuid::new_v4());
        let file_path = self.base_path.join(&filename);

        let mut file = File::create(&filename).await?;

        file.write_all(data.image.as_bytes()).await?;

        file.write_all(b"\n").await?; 
        file.write_all(data.date_taken.as_bytes()).await?; 
        file.write_all(b"\n").await?;

        file.flush().await?;

        println!(
            "Stored image at: {:?}, taken on: {}",
            file_path, data.date_taken
        );

        Ok(())
    }
}