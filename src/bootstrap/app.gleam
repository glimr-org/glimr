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
import dot_env
import glimr/routing/router
import wisp.{type Request, type Response}

/// Initializes the HTTP application and returns the request
/// handler. Configures the Wisp logger, loads environment
/// variables, registers database drivers, and sets up the router
/// with your context, routes, and middleware kernel.
///
pub fn init() -> fn(Request) -> Response {
  wisp.configure_logger()

  load_env_variables()
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

/// Loads environment variables from the .env file into the
/// process environment. This must be called before any
/// configuration that depends on environment variables like
/// the database configuration can be accessed.
///
fn load_env_variables() -> Nil {
  dot_env.new()
  |> dot_env.set_path(".env")
  |> dot_env.set_debug(False)
  |> dot_env.load()
}
