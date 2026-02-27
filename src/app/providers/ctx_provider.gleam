import app/http/context/ctx.{type Context}
import gleam/option
import glimr/cache/file
import glimr/response/response
import glimr_postgres/postgres

pub fn register() -> Context {
  let db = postgres.start("main")
  let cache = file.start("main")
  let session = postgres.start_session(db)

  ctx.Context(
    response_format: response.HTML,
    cache: cache,
    db: db,
    session: session,
    user: option.None,
  )
}
