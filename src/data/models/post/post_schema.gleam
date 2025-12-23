import glimr/db/schema.{foreign, id, string, table, text, unix_timestamps}

pub const name = "posts"

pub fn definition() {
  table(name, [
    id(),
    foreign("user_id", "users"),
    string("title"),
    text("body"),
    string("status"),
    unix_timestamps(),
  ])
}
