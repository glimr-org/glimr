import app/http/controllers/contact_controller
import app/http/controllers/contact_success_controller
import app/http/controllers/user_controller
import gleam/http.{Get, Post}
import wisp

pub fn routes(path, method, req, ctx) {
  case path {
    [] -> wisp.redirect("/contact")

    ["contact"] ->
      case method {
        Get -> contact_controller.show(req, ctx)
        Post -> contact_controller.store(req, ctx)
        _ -> wisp.method_not_allowed([Get, Post])
      }

    ["contact", "success"] ->
      case method {
        Get -> contact_success_controller.show(req, ctx)
        _ -> wisp.method_not_allowed([Get])
      }

    ["users", user] ->
      case method {
        Get -> user_controller.show(user, req, ctx)
        _ -> wisp.method_not_allowed([Get])
      }

    _ -> wisp.not_found()
  }
}
