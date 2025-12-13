//// ------------------------------------------------------------
//// Application Config
//// ------------------------------------------------------------
//// 
//// Application configuration module for managing environment 
//// settings loaded from the .env file or hardcoded here
////

import dot_env/env
import gleam/int
import gleam/result
import wisp

/// ------------------------------------------------------------
/// Application Name (Default: Glimr)
/// ------------------------------------------------------------
/// 
/// The name that's used when displaying your app in responses 
/// and error pages. This value is used throughout the entire 
/// framework and it Defaults to "Glimr" if it's not set
///
pub fn name() -> String {
  env.get_string("APP_NAME") |> result.unwrap("Glimr")
}

/// ------------------------------------------------------------
/// Application Port (Default: 8000)
/// ------------------------------------------------------------
/// 
/// The network port the web server listens on for incoming HTTP 
/// requests. Reads from APP_PORT, and it defaults to 8000.
///
pub fn port() -> Int {
  env.get_int("APP_PORT") |> result.unwrap(8000)
}

/// ------------------------------------------------------------
/// Application Debug Mode (Default: False)
/// ------------------------------------------------------------
///
/// Controls whether detailed error messages and stack traces are 
/// shown. Enable in development with APP_DEBUG=true, disable in 
/// production. Never expose debug info in production.
///
pub fn debug() -> Bool {
  env.get_bool("APP_DEBUG") |> result.unwrap(False)
}

/// ------------------------------------------------------------
/// Application URL (Default: http://localhost:8000)
/// ------------------------------------------------------------
///
/// The base URL used for generating links, redirects, and absolute 
/// URLs. Reads from APP_URL, defaults to http://localhost:8000.
///
pub fn url() -> String {
  env.get_string("APP_URL")
  |> result.unwrap("http://localhost:" <> int.to_string(port()))
}

/// ------------------------------------------------------------
/// Application Key
/// ------------------------------------------------------------
///
/// A secret string for encrypting sessions, signing tokens, and
/// security. Required value from APP_KEY. Application panics
/// if this value is not configured. Critical for security.
///
pub fn key() -> String {
  let assert Ok(key) = env.get_string("APP_KEY")

  key
}

/// ------------------------------------------------------------
/// Static Directory
/// ------------------------------------------------------------
///
/// The filesystem directory where static assets (CSS, 
/// JavaScript, images, etc.) are stored. This is served by the 
/// static file middleware.
///
pub fn static_directory() -> String {
  let assert Ok(priv_dir) = wisp.priv_directory("glimr_app")

  priv_dir <> "/static"
}
