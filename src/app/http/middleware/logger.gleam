import app/http/context/ctx.{type Context}
import gleam/io
import wisp.{type Request, type Response}

// This is an example middleware...

pub fn handle(
  req: Request,
  _ctx: Context,
  next: fn(Request) -> Response,
) -> Response {
  io.println("Logger middleware: Processing a request!")

  next(req)
}
