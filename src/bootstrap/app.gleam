//// Application Start
////
//// Creates the App instance with all shared resources
//// (database pools, caches). Pure — no side effects.
////

import app/app
import glimr/cache/file_cache
import glimr_postgres/postgres

/// Creates the App with its database pool and cache.
///
pub fn start() -> app.App {
  app.App(
    db: postgres.start("main"),
    cache: file_cache.start("main"),
    // ...
  )
}
