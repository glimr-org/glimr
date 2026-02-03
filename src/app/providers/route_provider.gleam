import app/http/context/ctx.{type Context}
import compiled/routes/api
import compiled/routes/web
import glimr/routing/router.{type RouteGroup}

pub fn register() -> List(RouteGroup(Context)) {
  use name: String <- router.register()

  case name {
    "api" -> api.routes
    // Register custom route groups here before the
    // default "web" group below.
    _ -> web.routes
  }
}
