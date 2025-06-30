#[macro_use] extern crate rocket;

use rocket::serde::{json::Json, Deserialize};
use rocket::http::Status;

#[derive(Debug, Deserialize)]
struct Message {
    data: serde_json::Value,
}

#[post("/", data = "<message>")]
fn post(message: Json<String>) /*-> Status*/ {
    println!("Received: {:?}", message.0)
    //Status::Created
}

#[rocket::main]
async fn main() -> Result<(), rocket::Error> {
    let rocket = rocket::build()
        .mount("/", routes![post])
        .launch()
        .await?;

    Ok(())
}
