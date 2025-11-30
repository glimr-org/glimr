import app/config/config_app
import gleam/http/response.{type Response}
import glimr/web.{type Context}
import wisp.{type Body, type Request}

pub fn show(_req: Request, _ctx: Context) -> Response(Body) {
  wisp.html_response("This is the home page for: " <> config_app.name(), 200)
}
