import app/http/context/ctx.{type Context}
import gleam/option
import glimr/http/kernel.{type Next}
import glimr/response/redirect
import wisp.{type Request, type Response}

/// Where to redirect users who visit a protected route
/// while they are unauthenticated.
///
const guest_redirect = "/login"

pub fn run(req: Request, ctx: Context, next: Next(Context)) -> Response {
  case ctx.user {
    option.Some(_) -> next(req, ctx)
    option.None -> redirect.to(guest_redirect)
  }
}
