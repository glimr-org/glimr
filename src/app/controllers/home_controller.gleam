import app/config/config_app
import glimr/web.{type Context}
import wisp.{type Request, type Response}

pub fn show(_req: Request, _ctx: Context) -> Response {
  wisp.html_response("This is the home page for: " <> config_app.name(), 200)
}
