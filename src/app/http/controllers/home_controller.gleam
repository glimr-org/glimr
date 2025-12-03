import app/http/context/ctx
import config/config_app
import glimr/routing/route
import wisp

pub fn show(_req: route.RouteRequest, _ctx: ctx.Context) -> wisp.Response {
  wisp.html_response("This is the home page for: " <> config_app.name(), 200)
}
