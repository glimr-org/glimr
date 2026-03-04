//// Glimr Web Application Entry Point
////
//// This module serves as the main entry point for the Glimr web
//// application. It initializes the HTTP server using Mist and Wisp,
//// configuring it with the apps routes and settings. Routes are defined
//// in controllers using annotation-based syntax within comments. If you
//// don't know where to start, take a look at a controller in the
//// app/http/controllers/ directory or read the docs below:
////
//// https://github.com/glimr-org/glimr?tab=readme-ov-file#defining-routes
//// https://github.com/glimr-org/glimr?tab=readme-ov-file#controllers
//// https://github.com/glimr-org/glimr?tab=readme-ov-file#route-groups
//// https://github.com/glimr-org/glimr?tab=readme-ov-file#loom-template-engine
////

import bootstrap/bootstrap
import dot_env/env
import gleam/erlang/process
import glimr/config/config
import glimr/http/glimr_mist
import mist

/// Starts the Glimr web application server. Initializes the
/// Wisp HTTP handler with the application's router, configures
/// the Mist server on the specified port, and runs indefinitely.
///
pub fn main() -> Nil {
  let assert Ok(_) =
    glimr_mist.handler(bootstrap.init(), config.get_string("app.key"))
    |> mist.new()
    |> mist.port(get_port())
    |> mist.start()

  process.sleep_forever()
}

/// The network port the web server listens on. When running
/// via ./glimr run, uses DEV_PROXY_PORT so the dev proxy can
/// handle the main APP_PORT.
///
fn get_port() -> Int {
  case env.get_string("_GLIMR_RUN") {
    Ok("true") -> {
      config.dev_proxy_port()
    }
    _ -> {
      config.get_int("app.port")
    }
  }
}
