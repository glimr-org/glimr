import app/http/context/ctx.{type Context}
import app/http/requests/contact_store_request.{type Data}
import data/models/submission/gen/submission_repository.{type CreateRow}
import glimr/db/pool
import glimr/utils/unix_timestamp
import wisp.{type Response}

pub fn run(
  ctx: Context,
  data: Data,
  next: fn(CreateRow) -> Response,
) -> Response {
  let now = unix_timestamp.now()

  use conn <- pool.get_connection(ctx.db.pool)
  use submitter <- submission_repository.create(
    conn: conn,
    name: data.name,
    email: data.email,
    avatar: data.avatar.path,
    created_at: now,
    updated_at: now,
    message: data.message,
  )

  next(submitter)
}
