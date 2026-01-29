//// Glimr Console Application Entry Point
////
//// This module serves as the main entry point for the Glimr console CLI 
//// application. It provides access to helpful framework commands such as 
//// generating db migrations. These commands are ran using `./glimr`, for 
//// example to create a controller, use `./glimr make:controller`. Read
//// the docs below for more information
////
//// https://github.com/glimr-org/glimr?tab=readme-ov-file#console-commands
//// https://github.com/glimr-org/glimr?tab=readme-ov-file#creating-commands
//// https://github.com/glimr-org/glimr?tab=readme-ov-file#commands-with-database-access
////

import bootstrap/console

/// Initializes and runs the Glimr console application. Parses
/// command-line arguments and dispatches to the appropriate
/// console command handler.
///
pub fn main() -> Nil {
  console.init()
}
