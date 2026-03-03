//// Application Type
////
//// Defines the app-specific state passed through the framework
//// context. Database pools, caches, and other shared resources
//// live here so controllers can access them via ctx.app.
////

import glimr/cache/cache.{type CachePool}
import glimr/db/db.{type DbPool}

pub type App {
  App(
    db: DbPool,
    cache: CachePool,
    // ...
  )
}
