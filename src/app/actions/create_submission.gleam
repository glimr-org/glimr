import app/http/context/ctx.{type Context}
import app/http/requests/contact_store_request.{type Data}
import data/models/submission/gen/submission_repository.{type CreateRow}
import glimr/db/connection.{type DbError}
import glimr/utils/unix_timestamp

pub fn run(ctx: Context, data: Data) -> Result(CreateRow, DbError) {
  let now = unix_timestamp.now()

  submission_repository.create(
    pool: ctx.db.pool,
    name: data.name,
    email: data.email,
    avatar: data.avatar.path,
    message: data.message,
    created_at: now,
    updated_at: now,
  )
}
