import app/http/context/ctx
import gleam/io
import wisp.{type Request, type Response}

pub fn handle(
  req: Request,
  _ctx: ctx.Context,
  next: fn(Request) -> Response,
) -> Response {
  io.println("Logger middleware: Processing a request!")

  use <- wisp.log_request(req)

  next(req)
}
