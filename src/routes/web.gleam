import app/http/controllers/contact_controller
import app/http/controllers/contact_success_controller
import app/http/controllers/user_controller
import app/http/middleware/logger.{handle as logger}
import gleam/http.{Get, Post}
import glimr/http/middleware
import glimr/routing/router
import wisp

pub fn routes(path, method, req, ctx) {
  case path {
    [] -> wisp.redirect("/contact")

    ["contact"] ->
      router.match(method, [
        #(Get, fn() { contact_controller.show(req, ctx) }),
        #(Post, fn() { contact_controller.store(req, ctx) }),
      ])

    ["contact", "success"] ->
      router.match(method, [
        #(Get, fn() {
          use req <- middleware.apply([logger], req, ctx)
          contact_success_controller.show(req, ctx)
        }),
      ])

    ["users", user_id] ->
      router.match(method, [
        #(Get, fn() { user_controller.show(user_id, req, ctx) }),
      ])

    _ -> wisp.response(404)
  }
}
