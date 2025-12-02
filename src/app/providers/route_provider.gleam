import glimr/kernel
import glimr/route
import routes/api
import routes/web

pub fn register() -> List(route.RouteGroup) {
  [
    route.RouteGroup(middleware_group: kernel.Web, routes: web.routes()),
    route.RouteGroup(middleware_group: kernel.Api, routes: api.routes()),
    // add your custom route files here...
  ]
}
