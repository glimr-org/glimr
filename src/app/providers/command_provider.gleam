import app/console/kernel
import gleam/list
import glimr/console/command.{type Command}
import glimr_sqlite/console/kernel as kernel_sqlite

pub fn register() -> List(Command) {
  list.flatten([
    kernel.commands(),
    kernel_sqlite.commands(),
    // Add other third-party commands here...
  ])
}
