import dot_env/env
import gleam/result

pub type AppConfig {
  AppConfig(
    name: String,
    port: Int,
    key: String,
    debug: Bool,
    env: Environment,
    url: String,
  )
}

pub type Environment {
  Local
  Staging
  Production
}

pub fn load() -> Result(AppConfig, String) {
  use name <- result.try(env.get_string("APP_NAME"))
  use port <- result.try(env.get_int("APP_PORT"))
  use key <- result.try(env.get_string("APP_KEY"))
  use debug <- result.try(env.get_bool("APP_DEBUG"))
  use url <- result.try(env.get_string("APP_URL"))

  let env =
    env.get_string("APP_ENV")
    |> result.unwrap("local")
    |> parse_environment()

  Ok(AppConfig(
    name: name,
    port: port,
    key: key,
    debug: debug,
    env: env,
    url: url,
  ))
}

fn parse_environment(env: String) -> Environment {
  case env {
    "local" -> Local
    "staging" -> Staging
    "production" -> Production
    _ -> Local
  }
}

pub fn is_local(app: AppConfig) -> Bool {
  app.env == Local
}

pub fn is_staging(app: AppConfig) -> Bool {
  app.env == Staging
}

pub fn is_production(app: AppConfig) -> Bool {
  app.env == Production
}
