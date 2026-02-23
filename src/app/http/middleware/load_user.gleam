import app/http/context/ctx.{type Context}
import data/main/models/user/gen/user
import gleam/int
import gleam/option
import gleam/result
import glimr/http/kernel.{type Next}
import glimr_auth/auth
import wisp.{type Request, type Response}

pub const session_key = "_auth_user_id"

pub fn run(req: Request, ctx: Context, next: Next(Context)) -> Response {
  let user =
    auth.id(ctx.session, session_key)
    |> result.try(int.parse)
    |> result.try(fn(id) {
      user.find(pool: ctx.db.main, id: id) |> result.replace_error(Nil)
    })
    |> option.from_result

  let ctx = ctx.Context(..ctx, user: user)

  next(req, ctx)
}
