use client::HttpState;
use eyre;
use tokio::task::JoinSet;
use crate::stg::Storage;

mod stg;
mod client;

#[tokio::main]
async fn main() -> eyre::Result<()> {
    const BASE_PATH: &str = "./images";
    const ADDRESS: &str = "0.0.0.0:3030";

    let mut bag = JoinSet::new();

    let storage = Storage::new(BASE_PATH.into());


    // Spawn server routine
    let state = HttpState{storage};
    bag.spawn(async move {
        let app = client::start_server(state);
        let listener = tokio::net::TcpListener::bind(ADDRESS).await.unwrap();
        axum::serve(listener, app).await.unwrap();
        println!("Server runnning on {ADDRESS}");
    });

    while let Some(res) = bag.join_next().await {
        res?;
    }
    
    Ok(())
}