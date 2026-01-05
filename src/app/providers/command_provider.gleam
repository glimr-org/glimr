import app/console/kernel
import gleam/list
import glimr/console/command.{type Command}
import glimr/console/kernel as glimr_kernel

pub fn register() -> List(Command) {
  list.flatten([
    kernel.commands(),
    glimr_kernel.commands(),
    // Add third-party commands here...
  ])
}
