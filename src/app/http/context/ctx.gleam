import app/http/context/ctx_app.{type AppContext}
import app/http/context/ctx_cache.{type CacheContext}
import app/http/context/ctx_db.{type DbContext}

pub type Context {
  Context(
    app: AppContext,
    db: DbContext,
    cache: CacheContext,
    // ...
  )
}
