//// Application Bootstrap
////
//// Entry point for the HTTP application. Initializes the
//// environment, configures the logger, and returns a request
//// handler function that processes incoming HTTP requests
//// through the router.
////

import app/http/kernel
import app/providers/ctx_provider
import app/providers/route_provider
import glimr/config/config
import glimr/routing/router
import wisp.{type Request, type Response}

/// Initializes the HTTP application and returns the request
/// handler. Configures the Wisp logger, loads environment
/// variables and config, registers database drivers, and sets
/// up the router with your context, routes, and middleware
/// kernel.
///
pub fn init() -> fn(Request) -> Response {
  wisp.configure_logger()
  config.load()

  router.handle(
    _,
    ctx_provider.register(),
    route_provider.register(),
    kernel.handle,
  )
}
