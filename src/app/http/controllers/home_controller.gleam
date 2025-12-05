import app/http/context/ctx.{type Context}
import config/config_app
import glimr/routing/route.{type RouteRequest}
import wisp.{type Response}

pub fn show(_req: RouteRequest, _ctx: Context) -> Response {
  wisp.html_response("This is the home page for: " <> config_app.name(), 200)
}
