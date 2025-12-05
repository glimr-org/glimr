import app/http/context/ctx.{type Context}
import glimr/routing/route.{type RouteRequest}
import wisp.{type Response}

pub fn show(req: RouteRequest, _ctx: Context) -> Response {
  let assert Ok(id) = route.get_param(req, "id")

  wisp.html_response("<h1>User " <> id <> "</h1>", 200)
}
