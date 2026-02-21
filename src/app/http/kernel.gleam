//// HTTP Kernel
////
//// This is the kernel for our HTTP layer. This is where we set 
//// up our middleware groups which contain multiple middleware 
//// that we want assigned to a specific route group. By default 
//// you have "web" and "api" groups, but can define your own in 
//// the handle() method.
////
//// https://github.com/glimr-org/glimr?tab=readme-ov-file#middleware-groups
////

import app/http/context/ctx.{type Context, Context}
import config/config_app
import glimr/http/error_handler
import glimr/http/kernel.{type MiddlewareGroup}
import glimr/session/session
import glimr_auth/auth
import wisp.{type Request, type Response}

pub fn handle(
  req: Request,
  ctx: Context,
  middleware_group: MiddlewareGroup,
  router: fn(Request, Context) -> Response,
) -> Response {
  let req = wisp.method_override(req)

  case middleware_group {
    kernel.Api -> api_middleware(req, ctx, router)
    // Add custom middleware groups here...
    _ -> web_middleware(req, ctx, router)
  }
}

/// Define the middleware that always runs for the
/// web routes before or after they're resolved.
///
fn web_middleware(
  req: Request,
  ctx: Context,
  router: fn(Request, Context) -> Response,
) -> Response {
  use <- wisp.serve_static(
    req,
    under: "/static",
    from: config_app.static_directory(),
  )
  use <- wisp.log_request(req)
  use <- error_handler.default_html_responses()
  use <- wisp.rescue_crashes
  use req <- wisp.handle_head(req)
  use req, session <- session.load(req)

  let ctx = Context(..ctx, session: session, user: auth.resolve_user(session))

  router(req, ctx)
}

/// Define the middleware that always runs for the
/// api routes before or after they're resolved.
///
fn api_middleware(
  req: Request,
  ctx: Context,
  router: fn(Request, Context) -> Response,
) -> Response {
  use <- wisp.log_request(req)
  use <- error_handler.default_json_responses()
  use <- wisp.rescue_crashes
  use req <- wisp.handle_head(req)
  use req, session <- session.load(req)

  let ctx = Context(..ctx, session: session, user: auth.resolve_user(session))

  router(req, ctx)
}
