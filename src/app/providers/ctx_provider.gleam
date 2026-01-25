// import app/http/context/ctx_db
import app/http/context/ctx.{type Context}
import app/http/context/ctx_cache

pub fn register() -> Context {
  ctx.Context(
    cache: ctx_cache.load(),
    // db: ctx_db.load(),
  )
}
