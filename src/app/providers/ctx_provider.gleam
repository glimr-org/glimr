import app/http/context/ctx.{type Context}
import app/http/context/ctx_cache
import app/http/context/ctx_db
import app/http/context/ctx_session

pub fn register() -> Context {
  let db = ctx_db.load()
  let cache = ctx_cache.load()
  let session = ctx_session.load(db.main)

  ctx.Context(
    cache: cache,
    db: db,
    session: session,
    // ...
  )
}
