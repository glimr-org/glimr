import config/config_db
import glimr_sqlite/db/pool.{type Pool as SqlitePool}
import glimr_sqlite/sqlite

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
