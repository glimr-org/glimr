import app/http/context/ctx.{type Context}
import config/config_app
import glimr/response/view
import wisp.{type Request, type Response}

pub fn show(_req: Request, _ctx: Context) -> Response {
  view.build()
  |> view.html("contact/success.html")
  |> view.data([#("title", config_app.name())])
  |> view.render()
}
