import app/http/context/ctx.{type Context}
import app/http/context/ctx_cache
import app/http/context/ctx_db
import app/http/context/ctx_session
import gleam/option
import glimr/response/response

pub fn register() -> Context {
  let db = ctx_db.load()
  let cache = ctx_cache.load()
  let session = ctx_session.load(db.main)

  ctx.Context(
    response_format: response.HTML,
    cache: cache,
    db: db,
    session: session,
    user: option.None,
  )
}
