//// Console Bootstrap
////
//// Entry point for the console application. Initializes the
//// environment and runs the console kernel with your registered
//// commands and database connections.

import app/providers/command_provider
import bootstrap/bootstrap
import config/config_db
import glimr/console/kernel as glimr_kernel

/// Initializes and runs the console application. Loads 
/// environment variables first to ensure database configuration 
/// can read from .env, then starts the console kernel with 
/// registered commands.
///
pub fn init() -> Nil {
  bootstrap.load_env_variables()

  glimr_kernel.run(
    commands: command_provider.register(),
    db_connections: config_db.connections(),
  )
}
