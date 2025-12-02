import glimr/context
import glimr/error_handler
import glimr/kernel
import wisp

pub fn handle(
  req: wisp.Request,
  ctx: context.Context,
  middleware_group: kernel.MiddlewareGroup,
  router: fn(wisp.Request) -> wisp.Response,
) -> wisp.Response {
  let req = wisp.method_override(req)

  case middleware_group {
    kernel.Web -> handle_web_middleware(req, ctx, router)
    kernel.Api -> handle_api_middleware(req, ctx, router)
    // Add custom middleware groups here
    // ex: kernel.Custom("admin") -> handle_admin_middleware(req, ctx, router)
    _ -> handle_web_middleware(req, ctx, router)
  }
}

fn handle_web_middleware(
  req: wisp.Request,
  ctx: context.Context,
  router: fn(wisp.Request) -> wisp.Response,
) -> wisp.Response {
  use <- wisp.serve_static(req, under: "/static", from: ctx.static_directory)
  use <- wisp.log_request(req)
  use <- error_handler.default_html_responses()
  use <- wisp.rescue_crashes
  use req <- wisp.handle_head(req)

  router(req)
}

fn handle_api_middleware(
  req: wisp.Request,
  _ctx: context.Context,
  router: fn(wisp.Request) -> wisp.Response,
) -> wisp.Response {
  use <- wisp.log_request(req)
  use <- error_handler.default_json_responses()
  use <- wisp.rescue_crashes
  use req <- wisp.handle_head(req)

  router(req)
}
