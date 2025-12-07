import app/http/controllers/contact_controller
import app/http/controllers/contact_success_controller
import glimr/routing/route

pub fn routes() {
  [
    [
      route.redirect("/", "/contact"),
    ],

    route.group_path_prefix("/contact", [
      [
        route.get("/", contact_controller.show),
        route.post("/", contact_controller.store),
        route.get("/success", contact_success_controller.show),
      ],
    ]),
  ]
}
