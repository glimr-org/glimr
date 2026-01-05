import app/http/requests/contact_store_request.{type Data}
import data/default/models/submission/gen/submission_repository.{type CreateRow}
import glimr/db/pool.{type Pool}
import glimr/db/pool_connection.{type DbError}
import glimr/utils/unix_timestamp

pub fn run(pool: Pool, data: Data) -> Result(CreateRow, DbError) {
  let now = unix_timestamp.now()

  submission_repository.create(
    pool: pool,
    name: data.name,
    email: data.email,
    avatar: data.avatar.path,
    message: data.message,
    created_at: now,
    updated_at: now,
  )
}
