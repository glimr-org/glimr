import config/config_api
import gleam/list
import glimr/route

pub fn routes() -> List(route.Route) {
  route.group_path_prefix(config_api.route_prefix(), fn() {
    list.flatten([
      [
        // route.get("/me", user_controller.show) ...
      ],
    ])
  })
}
