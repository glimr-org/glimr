//// Bootstrap
////
//// Shared bootstrap utilities used by both the HTTP application
//// and console commands. Contains common initialization logic
//// that needs to run before either entry point starts.
////

import dot_env

/// Loads environment variables from the .env file into the
/// process environment. This must be called before any
/// configuration that depends on environment variables like
/// the database configuration can be accessed.
///
pub fn load_env_variables() -> Nil {
  dot_env.new()
  |> dot_env.set_path(".env")
  |> dot_env.set_debug(False)
  |> dot_env.load()
}
