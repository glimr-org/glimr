import app/http/context/ctx.{type Context}
import gleam/io
import glimr/http/kernel.{type Next}
import wisp.{type Request, type Response}

// This is an example middleware that logs requests.
// Middleware can modify both the request and context before
// passing them to the next middleware or handler.

pub fn handle(req: Request, ctx: Context, next: Next(Context)) -> Response {
  io.println("Logger middleware: Processing a request!")

  next(req, ctx)
}
