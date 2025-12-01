import app/http/controllers/contact_controller
import app/http/controllers/home_controller
import app/http/controllers/test_controller
import app/http/middleware/logger.{handle as logger}
import gleam/list
import glimr/route

pub fn routes() -> List(route.Route) {
  list.flatten([
    route.group_middleware([logger], fn() {
      [
        route.get("/", home_controller.show)
          |> route.middleware([logger])
          |> route.name("home.show"),

        route.get("/contact-us", contact_controller.show)
          |> route.name("contact.show"),
      ]
    }),

    route.group_path_prefix("/api", fn() {
      [
        route.get("/testing", home_controller.show),
        route.get("/testing-2", home_controller.show),
        route.get("/testing-3", home_controller.show),
      ]
    }),

    [
      route.post("/contact-us", contact_controller.store)
        |> route.name("contact.store"),

      route.get("/test/{id}", test_controller.show),
    ],
  ])
}
