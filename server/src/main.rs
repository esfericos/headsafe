use std::fs;
use client::HttpState;
use stg::Storage;
use tokio::{self, task::JoinSet};

mod client;
mod stg;


#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    const BASE_PATH: &str = "./images";
    const ADDRESS: &str = "0.0.0.0:3000";

    let (stg_handle, stg) = Storage::new(BASE_PATH.into());
    fs::create_dir_all(&stg.base_path).expect("Failed to create storage directory");

    let mut bag = JoinSet::new();
    let state = HttpState { storage_handle: stg_handle.clone() };

    bag.spawn(async move {
        stg.run().await;
    });

    bag.spawn(async move {
        let app = client::start_server(state);
        let listener = tokio::net::TcpListener::bind(ADDRESS).await.unwrap();
        let _ = axum::serve(listener, app);
        println!("Server starting at: {ADDRESS}");
    });

    while let Some(res) = bag.join_next().await {
        res?;
    }
    Ok(())
}