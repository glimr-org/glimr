import app/http/controllers/contact_controller
import app/http/controllers/home_controller
import app/http/middleware/logger.{handle as logger}
import glimr/route

// TODO: create ability for route groups.

// TODO: figure out how to have different routes. api routes, etc. ?

// TODO: figure out how we're getting routes by name

pub fn get() -> List(route.Route) {
  [
    route.get("/", home_controller.show)
      |> route.middleware([logger])
      |> route.name("home.show"),

    route.get("/contact-us", contact_controller.show)
      |> route.name("contact.show"),

    route.post("/contact-us", contact_controller.store)
      |> route.name("contact.store"),
  ]
}
