import gleam/http/response.{type Response}
import glimr/route.{type RouteRequest}
import glimr/web.{type Context}
import wisp.{type Body}

pub fn show(_req: RouteRequest, _ctx: Context) -> Response(Body) {
  wisp.html_response("This is the contact page", 200)
}

pub fn store(_req: RouteRequest, _ctx: Context) -> Response(Body) {
  wisp.html_response("Handle contact form...", 200)
}
