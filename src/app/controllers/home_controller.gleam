import gleam/http/response.{type Response}
import glimr/web.{type Context}
import wisp.{type Body, type Request}

pub fn show(_req: Request, ctx: Context) -> Response(Body) {
  wisp.html_response("This is the home page for: " <> ctx.config.app.name, 200)
}
