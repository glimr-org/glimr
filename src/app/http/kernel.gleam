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

import app/app.{type App}
import glimr/http/context.{type Context}
import glimr/http/http.{type Response}
import glimr/http/kernel.{type MiddlewareGroup}
import glimr/http/middleware
import glimr/http/middleware/expects_html
import glimr/http/middleware/expects_json
import glimr/http/middleware/handle_head
import glimr/http/middleware/load_session
import glimr/http/middleware/log_request
import glimr/http/middleware/method_override
import glimr/http/middleware/rescue_crashes
import glimr/http/middleware/serve_static

pub fn handle(
  ctx: Context(App),
  middleware_group: MiddlewareGroup,
  router: fn(Context(App)) -> Response,
) -> Response {
  case middleware_group {
    kernel.Api -> {
      [
        expects_json.run,
        method_override.run,
        log_request.run,
        rescue_crashes.run,
        handle_head.run,
        load_session.run,
        // ...
      ]
      |> middleware.apply(ctx, router)
    }
    //
    // Add your custom middleware groups here before
    // the catch-all web group below.
    //
    kernel.Web | _ -> {
      [
        expects_html.run,
        serve_static.run,
        method_override.run,
        log_request.run,
        rescue_crashes.run,
        handle_head.run,
        load_session.run,
        // ...
      ]
      |> middleware.apply(ctx, router)
    }
  }
}
