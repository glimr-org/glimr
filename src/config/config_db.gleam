//// ------------------------------------------------------------
//// Database Config
//// ------------------------------------------------------------
////
//// Database configuration module for defining database 
//// connections. Add your connections here and they'll be 
//// available throughout your application via the context system.
////

import dot_env/env
import glimr/db/driver.{type Connection}

/// ------------------------------------------------------------
/// Database Connections
/// ------------------------------------------------------------
///
/// Returns all configured database connections. Each connection
/// must have a unique name. Set `is_default: True` on one 
/// connection per driver type to make it accessible via 
/// `ctx.db.pool`. Access non-default connections with 
/// `ctx.db.pool_for("name")`.
///
pub fn connections() -> List(Connection) {
  [
    main(),
    // Add other database connections here...
  ]
}

// ------------------------------------------------------------ Connections

fn main() -> Connection {
  driver.SqliteConnection(
    name: "main",
    is_default: True,
    database: env.get_string("DB_DATABASE"),
    pool_size: env.get_int("DB_POOL_SIZE"),
  )
}
// fn postgres() -> Connection {
//   driver.PostgresConnection(
//     name: "example",
//     is_default: False,
//     host: env.get_string("DB_HOST"),
//     port: env.get_int("DB_PORT"),
//     database: env.get_string("DB_DATABASE"),
//     username: env.get_string("DB_USERNAME"),
//     password: env.get_string("DB_PASSWORD"),
//     pool_size: env.get_int("DB_POOL_SIZE"),
//   )
// }

// fn postgres_uri() -> Connection {
//   driver.PostgresUriConnection(
//     name: "example",
//     is_default: False,
//     url: env.get_string("DB_URL"),
//     pool_size: env.get_int("DB_POOL_SIZE"),
//   )
// }
