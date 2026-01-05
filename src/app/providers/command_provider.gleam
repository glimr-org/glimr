import app/console/kernel
import gleam/list
import glimr/console/command.{type Command}

pub fn register() -> List(Command) {
  list.flatten([
    kernel.commands(),
    // Add third-party commands here...
  ])
}
