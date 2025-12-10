import app/http/context/ctx.{type Context}
import config/config_api
import glimr/http/kernel
import glimr/routing/router.{type RouteGroup}
import routes/api
import routes/web

pub fn register() -> List(RouteGroup(Context)) {
  [
    router.RouteGroup(
      prefix: config_api.route_prefix(),
      middleware_group: kernel.Api,
      routes: api.routes,
    ),
    // 
    // Add your custom route groups here, before the
    // default web group that has no prefix. The default\
    // web group below must always be last.
    //
    router.RouteGroup(
      prefix: "",
      middleware_group: kernel.Web,
      routes: web.routes,
    ),
  ]
}
