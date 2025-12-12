import app/http/context/ctx.{type Context}
import app/http/middleware/logger.{handle as logger}
import glimr/http/middleware
import wisp.{type Request, type Response}

pub fn show(user_id: String, req: Request, ctx: Context) -> Response {
  use _req <- middleware.apply([logger], req, ctx)

  wisp.html_response("user id is " <> user_id, 200)
}
