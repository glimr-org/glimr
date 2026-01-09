//// Glimr Console Entry Point
////
//// This module serves as the main entry point for the Glimr 
//// console CLI application. It provides access to helpful
//// framework commands such as generating db migrations.

import bootstrap/console

/// Initializes and runs the Glimr console application. Parses
/// command-line arguments and dispatches to the appropriate
/// console command handler.
///
pub fn main() -> Nil {
  console.init()
}
