import app/http/context/ctx.{type Context}
import config/config_api
import gleam/list
import glimr/http/kernel
import glimr/routing/route.{type RouteGroup}
import routes/api
import routes/web

pub fn register() -> List(RouteGroup(Context)) {
  [
    route.RouteGroup(
      prefix: config_api.route_prefix(),
      middleware_group: kernel.Api,
      routes: fn() { list.flatten(api.routes()) },
    ),

    // register other route groups here, before the web group.
    //
    route.RouteGroup(prefix: "", middleware_group: kernel.Web, routes: fn() {
      list.flatten(web.routes())
    }),
  ]
}
