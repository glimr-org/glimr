//// Route Groups
////
//// Registers route groups by mapping group names to their
//// compiled route modules. Add new route groups here by
//// adding a case clause before the default web group.
////

import app/app.{type App}
import compiled/routes/api
import compiled/routes/web
import glimr/http/context.{type Context}
import glimr/routing/router.{type RouteGroup}

/// Returns the list of route groups for the application.
/// Each group maps a name to its compiled route module.
///
pub fn groups() -> List(RouteGroup(Context(App))) {
  use name <- router.load()

  case name {
    "api" -> api.routes
    // Register custom route groups here before the
    // default "web" group below.
    _ -> web.routes
  }
}
