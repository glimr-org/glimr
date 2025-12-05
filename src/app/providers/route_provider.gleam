import app/http/context/ctx.{type Context}
import gleam/list
import glimr/http/kernel
import glimr/routing/route.{type RouteGroup}
import routes/api
import routes/web

pub fn register() -> List(RouteGroup(Context)) {
  [
    route.RouteGroup(
      middleware_group: kernel.Web,
      routes: list.flatten(web.routes()),
    ),

    route.RouteGroup(
      middleware_group: kernel.Api,
      routes: list.flatten(api.routes()),
    ),
    // register other route groups here...
  ]
}
