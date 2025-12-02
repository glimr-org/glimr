import gleam/io
import glimr/context.{type Context}
import wisp.{type Request, type Response}

pub fn handle(
  req: Request,
  _ctx: Context,
  next: fn(Request) -> Response,
) -> Response {
  io.println("Logger middleware: Processing a request!")

  use <- wisp.log_request(req)

  next(req)
}
