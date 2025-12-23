import glimr/db/schema.{id, nullable, string, table, text, unix_timestamps}

pub const name = "submissions"

pub fn definition() {
  table(name, [
    id(),
    string("name"),
    string("email"),
    string("avatar"),
    text("message") |> nullable(),
    unix_timestamps(),
  ])
}
