import app/http/context/ctx
import gleam/list
import glimr/http/kernel
import glimr/routing/route
import routes/api
import routes/web

// TODO: document this
pub fn register() -> List(route.RouteGroup(ctx.Context)) {
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
