import app/http/context/ctx.{type Context}
import app/http/requests/contact_request
import glimr/response/redirect
import glimr/response/view
import resources/views/contact/show
import wisp.{type Request, type Response}

pub fn show(_req: Request, _ctx: Context) -> Response {
  let model = show.init(Nil)

  view.build()
  |> view.lustre(show.view(model))
  |> view.render()
}

pub fn store(req: Request, _ctx: Context) -> Response {
  use _form <- contact_request.validate(req)

  redirect.build()
  |> redirect.to("/contact/success")
  |> redirect.flash([#("success.message", "Great job!")])
  |> redirect.go()
}
