import app/http/context/ctx.{type Context}
import gleam/option
import glimr/http/kernel.{type Next}
import glimr/response/redirect
import wisp.{type Request, type Response}

/// Where to redirect authenticated users.
const auth_redirect = "/dashboard"

pub fn run(req: Request, ctx: Context, next: Next(Context)) -> Response {
  case ctx.user {
    option.None -> next(req, ctx)
    option.Some(_) -> redirect.to(auth_redirect)
  }
}
