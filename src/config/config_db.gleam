//// Database Config
////
//// Database configuration module for defining database 
//// connections. Add your connections here and they'll be 
//// available throughout your application via the context system.

import dot_env/env
import glimr/db/driver.{type Connection}

/// ------------------------------------------------------------
/// Database Connections
/// ------------------------------------------------------------
///
/// Returns all configured database connections. Each connection
/// must have a unique key. Set `is_default: True` on only one 
/// connection per driver type.
///
pub fn connections() -> List(Connection) {
  [
    driver.SqliteConnection(
      name: "main",
      is_default: True,
      database: env.get_string("DB_DATABASE"),
      pool_size: env.get_int("DB_POOL_SIZE"),
    ),
    // ...
  ]
}
