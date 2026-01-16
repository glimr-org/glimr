import app/console/kernel
import gleam/list
import glimr/console/command.{type Command}
import glimr_postgres/console/kernel as kernel_postgres

pub fn register() -> List(Command) {
  list.flatten([
    kernel.commands(),
    kernel_postgres.commands(),
    // ...
  ])
}
