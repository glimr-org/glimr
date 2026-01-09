//// Glimr Web Application Entry Point
////
//// This module serves as the main entry point for the Glimr 
//// web application. It initializes the HTTP server using Mist 
//// and Wisp, configuring it with the apps routes and settings.

import bootstrap/app
import config/config_app
import gleam/erlang/process
import mist
import wisp/wisp_mist

/// Starts the Glimr web application server. Initializes the 
/// Wisp HTTP handler with the application's router, configures
/// the Mist server on the specified port, and runs indefinitely.
///
pub fn main() -> Nil {
  let assert Ok(_) =
    wisp_mist.handler(app.init(), config_app.key())
    |> mist.new()
    |> mist.port(config_app.port())
    |> mist.start()

  process.sleep_forever()
}
