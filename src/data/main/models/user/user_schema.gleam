import glimr/db/schema.{id, string, table, unix_timestamps}

pub const name = "users"

pub fn definition() {
  table(name, [
    id(),
    string("email"),
    string("password"),
    unix_timestamps(),
  ])
}
