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

import bootstrap/app
import config/config_app
import gleam/erlang/process
import glimr/http/glimr_mist
import mist

/// Starts the Glimr web application server. Initializes the
/// Wisp HTTP handler with the application's router, configures
/// the Mist server on the specified port, and runs indefinitely.
///
pub fn main() -> Nil {
  let assert Ok(_) =
    glimr_mist.handler(app.init(), config_app.key())
    |> mist.new()
    |> mist.port(config_app.port())
    |> mist.start()

  process.sleep_forever()
}
