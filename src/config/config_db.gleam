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
/// must have a unique name. The first connection of each driver
/// type is used as the default for console commands.
///
/// *Sqlite Connection:*
///
/// ```gleam
/// driver.SqliteConnection(
///   name: "main",
///   database: env.get_string("DB_DATABASE"),
///   pool_size: env.get_int("DB_POOL_SIZE"),
/// )
/// ```
///
/// *Postgres Connection:*
///
/// ```gleam
/// driver.PostgresConnection(
///   name: "main",
///   host: env.get_string("DB_HOST"),
///   port: env.get_int("DB_PORT"),
///   database: env.get_string("DB_DATABASE"),
///   username: env.get_string("DB_USERNAME"),
///   password: env.get_string("DB_PASSWORD"),
///   pool_size: env.get_int("DB_POOL_SIZE"),
/// )
/// ```
///
/// *Postgres Connection (URL):*
///
/// ```gleam
/// driver.PostgresUriConnection(
///   name: "main",
///   url: env.get_string("DB_URL"),
///   pool_size: env.get_int("DB_POOL_SIZE"),
/// )
/// ```
///
pub fn connections() -> List(Connection) {
  [
    driver.SqliteConnection(
      name: "main",
      database: env.get_string("DB_DATABASE"),
      pool_size: env.get_int("DB_POOL_SIZE"),
    ),
    // ...
  ]
}
