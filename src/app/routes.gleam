import app/controllers/contact_controller
import app/controllers/home_controller
import glimr/router

pub fn get() -> List(router.Route) {
  [
    router.get("/", home_controller.show),

    router.get("/contact-us", contact_controller.show),
    router.post("/contact-us", contact_controller.store),
  ]
}
