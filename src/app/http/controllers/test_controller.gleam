import app/http/context/ctx
import glimr/routing/route
import wisp

pub fn show(req: route.RouteRequest, _ctx: ctx.Context) -> wisp.Response {
  let assert Ok(id) = route.get_param(req, "id")

  wisp.html_response("<h1>User " <> id <> "</h1>", 200)
}
