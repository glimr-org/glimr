import app/http/context/ctx
import app/http/controllers/contact_controller
import app/http/controllers/home_controller
import app/http/controllers/test_controller
import app/http/middleware/logger.{handle as logger}
import glimr/routing/route

pub fn routes() -> List(List(route.Route(ctx.Context))) {
  [
    route.group_middleware([logger], [
      [
        route.get("/", home_controller.show)
          |> route.middleware([logger])
          |> route.name("home.show"),

        route.get("/contact-us", contact_controller.show)
          |> route.name("contact.show"),
      ],
    ]),

    [
      route.post("/contact-us", contact_controller.store)
        |> route.name("contact.store"),

      route.get("/test/{id}", test_controller.show),
    ],
  ]
}
