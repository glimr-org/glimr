import app/config/app.{type AppConfig}
import gleam/result

pub type Config {
  Config(app: AppConfig)
}

pub fn load() -> Result(Config, String) {
  use app <- result.try(app.load())

  Ok(Config(
    app: app,
    // add your own configs here
  ))
}
