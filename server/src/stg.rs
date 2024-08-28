use tokio::sync::mpsc::{self, Sender, Receiver};
use std::fs;
use std::path::PathBuf;
use uuid::Uuid;

use crate::client::ImageData;

pub struct Storage {
    pub receiver: Receiver<StorageCommand>,
    pub base_path: PathBuf, // Directory where images will be stored
}

#[derive(Clone)]
pub struct StorageHandle {
    sender: Sender<StorageCommand>,
}

pub enum StorageCommand {
    StoreImage { data: ImageData },
}

impl Storage {
    pub fn new(base_path: PathBuf) -> (StorageHandle, Storage) {
        let (sender, receiver) = mpsc::channel(100);
        (StorageHandle { sender }, Storage { receiver, base_path })
    }

    pub async fn run(mut self) {
        while let Some(command) = self.receiver.recv().await {
            match command {
                StorageCommand::StoreImage { data } => {
                    let filename = format!("{}.jpg", Uuid::new_v4());
                    let file_path = self.base_path.join(&filename);

                    if let Err(e) = fs::write(&file_path, &data.image) {
                        eprintln!("Failed to write image: {}", e);
                    } else {
                        println!(
                            "Stored image at: {:?}, taken on: {}, at: {}",
                            file_path, data.date_taken, data.place_name
                        );
                    }
                }
            }
        }
    }
}

impl StorageHandle {
    pub async fn store_image(&self,data: ImageData) {
        let _ = self.sender
            .send(StorageCommand::StoreImage { data }).await;
    }
}