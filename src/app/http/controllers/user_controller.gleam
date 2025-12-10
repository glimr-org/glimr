import app/http/context/ctx.{type Context}
import wisp.{type Request, type Response}

pub fn show(user_id: String, _req: Request, _ctx: Context) -> Response {
  wisp.html_response("user id is " <> user_id, 200)
}
