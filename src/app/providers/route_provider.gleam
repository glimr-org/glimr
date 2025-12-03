import gleam/list
import glimr/kernel
import glimr/route
import routes/api
import routes/web

// TODO: document this
pub fn register() -> List(route.RouteGroup) {
  [
    route.RouteGroup(
      middleware_group: kernel.Web,
      routes: list.flatten(web.routes()),
    ),

    route.RouteGroup(
      middleware_group: kernel.Api,
      routes: list.flatten(api.routes()),
    ),
  ]
}
