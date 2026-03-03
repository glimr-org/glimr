import app/http/context/ctx.{type Context}
import glimr/http/error_handler
import glimr/http/kernel.{type Next, type Request, type Response}
import glimr/response/response

pub fn run(req: Request, ctx: Context, next: Next(Context)) -> Response {
  let ctx = ctx.Context(..ctx, response_format: response.HTML)
  use <- error_handler.default_responses(response.HTML)

  next(req, ctx)
}
