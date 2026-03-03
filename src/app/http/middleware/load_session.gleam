import app/http/context/ctx.{type Context}
import glimr/http/kernel.{type Next, type Request, type Response}
import glimr/session/session

pub fn run(req: Request, ctx: Context, next: Next(Context)) -> Response {
  use req, session <- session.load(req)
  let ctx = ctx.Context(..ctx, session: session)

  next(req, ctx)
}
