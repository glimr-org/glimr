import app/http/controllers/contact_controller
import app/http/controllers/contact_success_controller
import app/http/controllers/user_controller
import app/http/middleware/logger.{handle as logger}
import gleam/http.{Get, Post}
import glimr/http/middleware
import wisp

pub fn routes(path, method, req, ctx) {
  case path {
    [] -> wisp.redirect("/contact")

    ["contact"] ->
      case method {
        Get -> contact_controller.show(req, ctx)
        Post -> contact_controller.store(req, ctx)
        _ -> wisp.response(405)
      }

    ["contact", "success"] ->
      case method {
        Get -> contact_success_controller.show(req, ctx)
        _ -> wisp.response(405)
      }

    ["users", user] ->
      case method {
        Get -> {
          use _req <- middleware.apply([logger], req, ctx)
          user_controller.show(user, req, ctx)
        }
        _ -> wisp.response(405)
      }

    _ -> wisp.not_found()
  }
}
