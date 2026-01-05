import dot_env/env
import glimr/db/driver.{type Connection}

pub fn connections() -> List(Connection) {
  [
    default(),
    // Add other database connections here...
  ]
}

pub fn default() -> Connection {
  driver.SqliteConnection(
    name: "default",
    database: env.get_string("DB_DATABASE"),
    pool_size: env.get_int("DB_POOL_SIZE"),
  )
}

pub fn postgres() -> Connection {
  driver.PostgresConnection(
    name: "example",
    host: env.get_string("DB_HOST"),
    port: env.get_int("DB_PORT"),
    database: env.get_string("DB_DATABASE"),
    username: env.get_string("DB_USERNAME"),
    password: env.get_string("DB_PASSWORD"),
    pool_size: env.get_int("DB_POOL_SIZE"),
  )
}

pub fn postgres_uri() -> Connection {
  driver.PostgresUriConnection(
    name: "example",
    url: env.get_string("DB_URL"),
    pool_size: env.get_int("DB_POOL_SIZE"),
  )
}
