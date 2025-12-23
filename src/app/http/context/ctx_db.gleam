import gleam/string
import glimr/db/db
import glimr/db/pool.{type Pool}

pub type Context {
  Context(pool: Pool)
}

pub fn load() -> Context {
  case pool.start(db.load_config()) {
    Ok(pool) -> Context(pool: pool)
    Error(err) -> {
      panic as { "Failed to start database pool: " <> string.inspect(err) }
    }
  }
}
