import glimr/db/schema.{boolean, foreign, id, table, text, unix_timestamps}

pub const name = "comments"

pub fn definition() {
  table(name, [
    id(),
    foreign("user_id", "users"),
    foreign("post_id", "posts"),
    text("body"),
    boolean("is_approved"),
    unix_timestamps(),
  ])
}
