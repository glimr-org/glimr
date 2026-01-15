import config/config_db
import glimr_sqlite/db/pool.{type Pool as SqlitePool}
import glimr_sqlite/sqlite

// Database Context
//
// https://github.com/glimr-org/glimr?tab=readme-ov-file#database
//
// This is where you can set up your database connections. You
// can be connected to multiple databases at once if needed
// and access them wherever context is injected.

pub type DbContext {
  DbContext(
    main: SqlitePool,
    // ...
  )
}

pub fn load() -> DbContext {
  let connections = config_db.connections()

  DbContext(main: sqlite.start("main", connections))
}
