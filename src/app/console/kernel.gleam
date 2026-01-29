//// Console Kernel
////
//// This is the kernel for our Console layer. This is where you register 
//// your own custom console commands. You can use the console command 
//// `./glimr make:command` to get started and register your new command.
//// here in the `commands` function.
////
//// https://github.com/glimr-org/glimr?tab=readme-ov-file#context-system
////

import glimr/console/command.{type Command}

pub fn commands() -> List(Command) {
  [
    // Add your commands here...
  ]
}
