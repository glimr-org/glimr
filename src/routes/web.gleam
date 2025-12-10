import app/http/controllers/contact_controller
import app/http/controllers/contact_success_controller
import app/http/middleware/logger.{handle as logger}
import gleam/http.{Get, Post}
import glimr/http/middleware
import wisp

pub fn routes(path, method, req, ctx) {
  case path, method {
    [], Get -> wisp.redirect("/contact")

    ["contact"], Get -> contact_controller.show(req, ctx)
    ["contact"], Post -> contact_controller.store(req, ctx)

    ["test"], Post -> wisp.html_response("Hello", 200)

    ["contact", "success"], Get -> {
      use req <- middleware.apply([logger], req, ctx)
      contact_success_controller.show(req, ctx)
    }

    _, _ -> wisp.response(404)
  }
}
