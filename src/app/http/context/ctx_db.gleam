import config/config_db
import glimr_postgres/db/pool.{type Pool as PostgresPool}
import glimr_postgres/postgres

// Database Context
//
// https://github.com/glimr-org/glimr?tab=readme-ov-file#database
//
// This is where you can set up your database connections. You
// can be connected to multiple databases at once if needed
// and access them wherever context is injected.

pub type DbContext {
  DbContext(
    main: PostgresPool,
    // ...
  )
}

pub fn load() -> DbContext {
  let connections = config_db.connections()

  DbContext(main: postgres.start("main", connections))
}
