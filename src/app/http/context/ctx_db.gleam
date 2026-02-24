//// Database Context
////
//// This is where you can set up your database connections. You can be
//// connected to multiple databases at once if needed and access them
//// wherever the context is injected.
////
//// https://github.com/glimr-org/glimr?tab=readme-ov-file#database
////

import glimr/db/pool_connection.{type Pool}
import glimr_postgres/postgres

pub type DbContext {
  DbContext(
    main: Pool,
    // ...
  )
}

pub fn load() -> DbContext {
  DbContext(main: postgres.start("main"))
}
