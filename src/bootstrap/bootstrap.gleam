//// Application Bootstrap
////
//// Entry point for the HTTP application. Initializes the
//// environment, configures the logger, and returns a request
//// handler function that processes incoming HTTP requests
//// through the router.
////

import app/http/kernel
import bootstrap/app
import bootstrap/routes
import glimr/config/config
import glimr/http/context
import glimr/http/http.{type Request, type Response}
import glimr/http/kernel as glimr_kernel
import glimr/routing/router
import glimr/session/session
import glimr_sqlite/sqlite

/// Initializes the HTTP application and returns the request
/// handler. Configures the logger, loads environment variables
/// and config, starts the app, and sets up the router with
/// your context, routes, and middleware kernel.
///
pub fn init() -> fn(Request) -> Response {
  glimr_kernel.configure_logger()
  config.load()

  let app = app.start()
  let route_groups = routes.groups()

  sqlite.session_store(app.db)
  |> session.setup()

  fn(req) {
    let ctx = context.new(req, app)
    router.handle(ctx, route_groups, kernel.handle)
  }
}
