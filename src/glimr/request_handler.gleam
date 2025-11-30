import app/routes
import gleam/http
import gleam/http/response.{Response}
import gleam/list
import gleam/string
import glimr/web.{type Context}
import wisp.{type Request, type Response, Text}

pub fn handle(req: Request, ctx: Context) -> Response {
  use req <- web.middleware(req, ctx)

  let path: String = "/" <> string.join(wisp.path_segments(req), "/")
  let method: http.Method = req.method

  case
    routes.get()
    |> list.find(fn(route) { route.path == path && route.method == method })
  {
    Ok(route) -> route.handler(req, ctx)
    Error(_) -> {
      case
        routes.get()
        |> list.any(fn(route) { route.path == path })
      {
        True -> Response(405, [], Text(""))
        False -> Response(404, [], Text(""))
      }
    }
  }
}
