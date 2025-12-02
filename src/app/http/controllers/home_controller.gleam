import config/config_app
import glimr/context.{type Context}
import glimr/route.{type RouteRequest}
import wisp.{type Response}

pub fn show(_req: RouteRequest, _ctx: Context) -> Response {
  wisp.html_response("This is the home page for: " <> config_app.name(), 200)
}
