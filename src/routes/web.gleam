import app/http/controllers/contact_controller
import app/http/controllers/contact_success_controller
import gleam/http.{Get, Post}
import wisp

// Web Routes
//
// Handles routing for web browser requests. Matches the URL 
// path and HTTP method to the appropriate controller action, 
// returning the response to be sent to the client.

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

    _ -> wisp.not_found()
  }
}
