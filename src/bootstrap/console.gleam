//// Console Bootstrap
////
//// Entry point for the console application. Initializes the
//// environment and runs the console kernel with your registered
//// commands.
////

import app/providers/command_provider
import bootstrap/shared
import config/config_cache
import glimr/console/kernel as glimr_kernel

/// Initializes and runs the console application. Loads
/// environment variables first to ensure database configuration
/// can read from .env, then starts the console kernel with
/// registered commands.
///
pub fn init() -> Nil {
  shared.load_env_variables()

  glimr_kernel.run(
    commands: command_provider.register(),
    cache_stores: config_cache.stores(),
  )
}
