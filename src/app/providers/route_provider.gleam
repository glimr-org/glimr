import app/app.{type App}
import compiled/routes/api
import compiled/routes/web
import glimr/http/context.{type Context}
import glimr/routing/router.{type RouteGroup}

pub fn register() -> List(RouteGroup(Context(App))) {
  use name <- router.register()

  case name {
    "api" -> api.routes
    // Register custom route groups here before the
    // default "web" group below.
    _ -> web.routes
  }
}
