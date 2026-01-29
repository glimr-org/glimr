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
import bootstrap/shared
import glimr/routing/router
import wisp.{type Request, type Response}

/// Initializes the HTTP application and returns the request
/// handler. Configures the Wisp logger, loads environment
/// variables, registers database drivers, and sets up the router
/// with your context, routes, and middleware kernel.
///
pub fn init() -> fn(Request) -> Response {
  wisp.configure_logger()

  shared.load_env_variables()
  configure_request_handler()
}

/// Configures the request handler by wiring together the router,
/// context provider, route provider, and HTTP kernel. Returns a
/// function that handles each incoming request.
///
fn configure_request_handler() -> fn(Request) -> Response {
  router.handle(
    _,
    ctx_provider.register(),
    route_provider.register(),
    kernel.handle,
  )
}
