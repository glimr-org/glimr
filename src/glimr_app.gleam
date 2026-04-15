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

import app/http/kernel
import bootstrap/app
import bootstrap/routes
import dot_env/env
import gleam/erlang/process
import glimr/config/config
import glimr/http/context
import glimr/http/glimr_mist
import glimr/http/request.{type Request}
import glimr/http/response.{type Response}
import glimr/routing/router
import glimr/session
import glimr_sqlite/sqlite
import mist

/// Starts the Glimr web application server. Initializes the
/// Wisp HTTP handler with the application's router, configures
/// the Mist server on the specified port, and runs indefinitely.
///
pub fn main() -> Nil {
  let assert Ok(_) =
    glimr_mist.handler(init(), config.get_string("app.key"))
    |> mist.new()
    |> mist.port(get_port())
    |> mist.start()

  process.sleep_forever()
}

/// Initializes the HTTP application and returns the request
/// handler. Configures the logger, loads environment variables
/// and config, starts the app, and sets up the router with
/// your context, routes, and middleware kernel.
///
pub fn init() -> fn(Request) -> Response {
  glimr_mist.configure_logger()
  config.load()

  let app = app.start()
  let route_groups = routes.groups()

  sqlite.session_store(app.db) |> session.setup()

  fn(req) {
    let ctx = context.new(req, app)
    router.handle(ctx, route_groups, kernel.handle)
  }
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
