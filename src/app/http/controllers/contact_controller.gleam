import app/http/actions/store_submission_action
import app/http/context/ctx.{type Context}
import app/http/requests/contact_store_request
import config/config_app
import glimr/response/redirect
import glimr/response/view
import wisp.{type Request, type Response}

pub fn show(_req: Request, _ctx: Context) -> Response {
  view.build()
  |> view.html("contact/show.html")
  |> view.layout("app.html")
  |> view.data([#("title", config_app.name())])
  |> view.render()
}

pub fn store(req: Request, ctx: Context) -> Response {
  use validated <- contact_store_request.validate(req, ctx)
  use submitter <- store_submission_action.run(ctx, validated)

  redirect.build()
  |> redirect.to("/contact/success")
  |> redirect.flash([#("message", "Thanks " <> submitter.name <> "!")])
  |> redirect.go()
}
