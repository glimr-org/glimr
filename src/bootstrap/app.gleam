//// Application Bootstrap
////
//// Entry point for the HTTP application. Initializes the
//// environment, configures the logger, and returns a request
//// handler function that processes incoming HTTP requests
//// through the router.
////

import app/http/kernel
import app/providers/app_provider
import app/providers/route_provider
import glimr/config/config
import glimr/http/context
import glimr/http/http.{type Request, type Response}
import glimr/http/kernel as glimr_kernel
import glimr/routing/router

/// Initializes the HTTP application and returns the request
/// handler. Configures the logger, loads environment variables
/// and config, registers database drivers, and sets up the
/// router with your context, routes, and middleware kernel.
///
pub fn init() -> fn(Request) -> Response {
  glimr_kernel.configure_logger()
  config.load()

  // Run register for all providers
  let app = app_provider.register()
  let route_groups = route_provider.register()

  // Run boot for providers that need it
  app_provider.boot(app)

  // Create context and handle routes
  fn(req) {
    let ctx = context.new(req, app)
    router.handle(ctx, route_groups, kernel.handle)
  }
}
