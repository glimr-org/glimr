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

import app/http/context/ctx.{type Context}
import app/http/middleware/load_auth
import app/http/middleware/load_session
import glimr/http/kernel.{type MiddlewareGroup}
import glimr/http/middleware
import glimr/http/middleware/handle_head
import glimr/http/middleware/html_errors
import glimr/http/middleware/json_errors
import glimr/http/middleware/log_request
import glimr/http/middleware/method_override
import glimr/http/middleware/rescue_crashes
import glimr/http/middleware/serve_static
import wisp.{type Request, type Response}

pub fn handle(
  req: Request,
  ctx: Context,
  middleware_group: MiddlewareGroup,
  router: fn(Request, Context) -> Response,
) -> Response {
  case middleware_group {
    kernel.Api -> {
      [
        method_override.run,
        log_request.run,
        json_errors.run,
        rescue_crashes.run,
        handle_head.run,
        load_session.run,
        load_auth.run,
        // ...
      ]
      |> middleware.apply(req, ctx, router)
    }
    //
    // Add your custom middleware groups here before 
    // the catch-all web group below.
    //
    kernel.Web | _ -> {
      [
        serve_static.run,
        method_override.run,
        log_request.run,
        html_errors.run,
        rescue_crashes.run,
        handle_head.run,
        load_session.run,
        load_auth.run,
        // ...
      ]
      |> middleware.apply(req, ctx, router)
    }
  }
}
