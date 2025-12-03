//// --------------------------------------------------------------------------
//// Application Config
//// --------------------------------------------------------------------------
//// 
//// Application configuration module for managing environment settings
//// which provides access to configuration values loaded from the
//// .env file and used throughout for runtime configuration.
////

import dot_env/env
import gleam/result

/// --------------------------------------------------------------------------
/// Application Name (Default: Glimr)
/// --------------------------------------------------------------------------
/// 
/// The name that's used when displaying your app in responses and error 
/// pages. This value is used throughout the entire framework where the
/// the app name is displayed. Defaults to "Glimr" if it's not set.
///
pub fn name() -> String {
  env.get_string("APP_NAME") |> result.unwrap("Glimr")
}

/// --------------------------------------------------------------------------
/// Application Port (Default: 8000)
/// --------------------------------------------------------------------------
/// 
/// The network port the web server listens on for incoming HTTP requests.
/// Reads from APP_PORT, defaults to 8000, a common development port.
/// This port typically doesn't require administrator privileges.
///
pub fn port() -> Int {
  env.get_int("APP_PORT") |> result.unwrap(8000)
}

/// --------------------------------------------------------------------------
/// Application Debug Mode (Default: False)
/// --------------------------------------------------------------------------
///
/// Controls whether detailed error messages and stack traces are shown.
/// Enable in development with APP_DEBUG=true, disable in production.
/// Defaults to false. Never expose debug info in production.
///
pub fn debug() -> Bool {
  env.get_bool("APP_DEBUG") |> result.unwrap(False)
}

/// --------------------------------------------------------------------------
/// Application URL (Default: http://localhost:8000)
/// --------------------------------------------------------------------------
///
/// The base URL used for generating links, redirects, and absolute URLs.
/// Should match how users access your app: localhost or production.
/// Reads from APP_URL, defaults to http://localhost:8000 locally.
///
pub fn url() -> String {
  env.get_string("APP_URL") |> result.unwrap("http://localhost:8000")
}

/// --------------------------------------------------------------------------
/// Application Key
/// --------------------------------------------------------------------------
///
/// A secret string for encrypting sessions, signing tokens, and security.
/// Required value from APP_KEY. Application panics if not configured.
/// Critical for security - never run in production without this.
///
pub fn key() -> String {
  let assert Ok(key) = env.get_string("APP_KEY")

  key
}
