import app/http/context/ctx.{type Context}
import config/config_app
import glimr/http/error_handler
import glimr/http/kernel.{type MiddlewareGroup}
import wisp.{type Request, type Response}

pub fn handle(
  req: Request,
  ctx: Context,
  middleware_group: MiddlewareGroup,
  router: fn(Request) -> Response,
) -> Response {
  let req = wisp.method_override(req)

  case middleware_group {
    kernel.Api -> handle_api_middleware(req, ctx, router)
    // Custom middleware groups
    _ -> handle_web_middleware(req, ctx, router)
  }
}

fn handle_web_middleware(
  req: Request,
  _ctx: Context,
  router: fn(Request) -> Response,
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

  router(req)
}

fn handle_api_middleware(
  req: Request,
  _ctx: Context,
  router: fn(Request) -> Response,
) -> Response {
  use <- wisp.log_request(req)
  use <- error_handler.default_json_responses()
  use <- wisp.rescue_crashes
  use req <- wisp.handle_head(req)

  router(req)
}
