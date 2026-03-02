import app/http/context/ctx.{type Context}
import glimr/cache/file_cache
import glimr/response/response
import glimr_postgres/postgres

pub fn register() -> Context {
  let db = postgres.start("main")
  let cache = file_cache.start("main")
  let session = postgres.start_session(db)

  ctx.Context(
    response_format: response.HTML,
    db: db,
    cache: cache,
    session: session,
  )
}
