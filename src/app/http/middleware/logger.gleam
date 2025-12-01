import gleam/io
import glimr/web.{type Context}
import wisp.{type Request, type Response}

pub fn handle(
  req: Request,
  _ctx: Context,
  handle_request: fn(Request) -> Response,
) -> Response {
  io.println("Logger middleware: Processing a request!")

  use <- wisp.log_request(req)

  handle_request(req)
}
