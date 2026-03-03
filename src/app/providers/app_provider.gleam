import app/app.{type App}
import glimr/cache/file_cache
import glimr_postgres/postgres

pub fn register() -> app.App {
  app.App(
    db: postgres.start("main"),
    cache: file_cache.start("main"),
    // ...
  )
}

pub fn boot(app: App) -> Nil {
  postgres.start_session(app.db)

  Nil
}
