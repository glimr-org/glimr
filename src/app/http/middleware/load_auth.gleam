import app/http/context/ctx.{type Context}
import glimr/http/kernel.{type Next}
import glimr_auth/auth
import wisp.{type Request, type Response}

pub fn run(req: Request, ctx: Context, next: Next(Context)) -> Response {
  let ctx = ctx.Context(..ctx, user: auth.resolve_user(ctx.session))

  next(req, ctx)
}
