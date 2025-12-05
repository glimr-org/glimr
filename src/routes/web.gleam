import app/http/controllers/contact_controller
import app/http/controllers/home_controller
import glimr/routing/route

pub fn routes() {
  [
    [
      route.get("/", home_controller.show),
      route.post("/contact", contact_controller.store),
    ],
  ]
}
