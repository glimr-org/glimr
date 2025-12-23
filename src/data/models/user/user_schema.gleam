import glimr/db/schema.{id, string, table, text, unix_timestamps}

pub const name = "users"

pub fn definition() {
  table(name, [
    id(),
    string("name"),
    string("email"),
    text("bio"),
    unix_timestamps(),
  ])
}
