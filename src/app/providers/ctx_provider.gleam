import app/http/context/ctx.{type Context}
import app/http/context/ctx_app
import app/http/context/ctx_cache
import app/http/context/ctx_db

pub fn register() -> Context {
  ctx.Context(
    app: ctx_app.load(),
    db: ctx_db.load(),
    cache: ctx_cache.load(),
    // ...
  )
}
