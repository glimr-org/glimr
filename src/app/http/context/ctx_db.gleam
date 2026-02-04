//// Database Context
////
//// This is where you can set up your database connections. You can be
//// connected to multiple databases at once if needed and access them
//// wherever the context is injected.
////
//// https://github.com/glimr-org/glimr?tab=readme-ov-file#database
////

import glimr_postgres/db/pool.{type Pool as PostgresPool}
import glimr_postgres/postgres

pub type DbContext {
  DbContext(
    main: PostgresPool,
    // ...
  )
}

pub fn load() -> DbContext {
  DbContext(main: postgres.start("main"))
}
