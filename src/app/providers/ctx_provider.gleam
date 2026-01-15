import app/http/context/ctx.{type Context}
import app/http/context/ctx_cache
import app/http/context/ctx_db

pub fn register() -> Context {
  ctx.Context(
    db: ctx_db.load(),
    cache: ctx_cache.load(),
    // ...
  )
}
