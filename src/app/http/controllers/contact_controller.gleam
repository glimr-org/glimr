import app/http/context/ctx
import glimr/routing/route
import wisp

pub fn show(_req: route.RouteRequest, _ctx: ctx.Context) -> wisp.Response {
  wisp.html_response("This is the contact page", 200)
}

pub fn store(_req: route.RouteRequest, _ctx: ctx.Context) -> wisp.Response {
  wisp.html_response("Handle contact form...", 200)
}
