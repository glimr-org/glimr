import config/config_api
import glimr/routing/route

pub fn routes() {
  [
    route.prefix_path(config_api.route_prefix(), [
      [
        // route.get("/me", user_controller.show) ...
      ],
    ]),
  ]
}
