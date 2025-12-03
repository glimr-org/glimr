import config/config_api
import glimr/route

pub fn routes() -> List(List(route.Route)) {
  [
    route.group_path_prefix(config_api.route_prefix(), [
      [
        // route.get("/me", user_controller.show) ...
      ],
    ]),
  ]
}
