import gleam/http/response.{type Response}
import glimr/web.{type Context}
import wisp.{type Body, type Request}

pub fn show(_req: Request, _ctx: Context) -> Response(Body) {
  wisp.html_response("This is the contact page", 200)
}

pub fn store(_req: Request, _ctx: Context) -> Response(Body) {
  wisp.html_response("Handle contact form...", 200)
}
