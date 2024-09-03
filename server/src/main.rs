use std::process::exit;

use client::HttpState;
use eyre;
use tokio::task::JoinSet;
use tracing::info;
use crate::stg::Storage;
mod stg;
mod client;
mod image;

#[tokio::main]
async fn main() -> eyre::Result<()> {
    tracing_subscriber::fmt::init();

    const BASE_PATH: &str = "./images";
    const ADDRESS: &str = "0.0.0.0:3030";

    let mut bag = JoinSet::new();

    let storage = Storage::new(BASE_PATH.into());
    
    // Spawn server routine
    let state = HttpState{ storage };
    bag.spawn(async move {
        info!("Started server routine");
        let app = client::start_server(state);
        let listener = match tokio::net::TcpListener::bind(ADDRESS).await {
            Ok(l) => l,
            Err(e) => {
                eprintln!("Failed to bind to address {}: {:?}", ADDRESS, e);
                exit(1);
            }
        };

        if let Err(e) = axum::serve(listener, app).await {
            eprintln!("Server error: {:?}", e);
        }
        info!("Server running on {}", ADDRESS);
    });

    while let Some(res) = bag.join_next().await {
        res?;
    }
    
    Ok(())
}