//// Session Context
////
//// This is where you can set up your session driver. You can use
//// postgres, sqlite, redis, file, or cookie-based sessions. The
//// session is initialized empty here and then populated through
//// the global middleware on each request.
////
//// https://github.com/glimr-org/glimr?tab=readme-ov-file#sessions
////

import glimr/db/pool_connection.{type Pool}
import glimr/session/session.{type Session}
import glimr_postgres/postgres

pub fn load(pool: Pool) -> Session {
  // You can start a session with postgres, sqlite, redis, a
  // redis equivalent store, or even a file store. Initial
  // session object will be empty and then it will be
  // initialized through our global middleware.

  postgres.start_session(pool)
}
