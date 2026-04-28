//// Glimr Web Application Entry Point
////
//// This module serves as the main entry point for the Glimr web
//// application. It initializes the HTTP server using Mist and Wisp,
//// configuring it with the apps routes and settings. Routes are defined
//// in controllers using annotation-based syntax within comments. If you
//// don't know where to start, take a look at a controller in the
//// app/http/controllers/ directory or read the docs below:
////
//// https://github.com/glimr-org/glimr?tab=readme-ov-file#defining-routes
//// https://github.com/glimr-org/glimr?tab=readme-ov-file#controllers
//// https://github.com/glimr-org/glimr?tab=readme-ov-file#route-groups
//// https://github.com/glimr-org/glimr?tab=readme-ov-file#loom-template-engine
////

import app/app.{type App}
import app/http/kernel
import compiled/routes/api
import compiled/routes/web
import gleam/erlang/process
import glimr/cache
import glimr/config
import glimr/http/context.{type Context}
import glimr/http/glimr_mist
import glimr/router.{type RouteGroup}
import glimr/session
import glimr_sqlite/sqlite
import mist

// ------------------------------------------------------------- Configuration

/// Initialize your global app state with all necessary shared
/// resources (database pools, caches, etc.)
///
fn app() -> App {
  app.App(
    db: sqlite.start("main"),
    cache: cache.start_file("main"),
    // ...
  )
}

/// Register your route groups by mapping group names to their
/// compiled route modules. Add new route groups here by adding
/// a case clause before the default web group.
///
fn route_groups() -> List(RouteGroup(Context(App))) {
  use name <- router.load()

  case name {
    "api" -> api.routes
    // Register custom route groups here before the
    // default "web" group below.
    _ -> web.routes
  }
}

/// Configure where session data is persisted. The session store
/// is registered globally so middleware can read and write
/// sessions on every request without threading it through the
/// pipeline. Swap to a different driver (e.g. cookie_store,
/// postgres) by changing the line below.
///
fn session_setup(app: App) {
  sqlite.session_store(app.db) |> session.setup()
}

// ------------------------------------------------------------- Main

/// Starts the Glimr web application server. Initializes the
/// Wisp HTTP handler with the application's router, configures
/// the Mist server on the specified port, and runs your app
/// indefinitely.
///
pub fn main() -> Nil {
  glimr_mist.configure_logger()
  config.load()

  let app = app()
  session_setup(app)

  let init = fn(req) {
    let ctx = context.new(req, app)
    router.handle(ctx, route_groups(), kernel.handle)
  }

  let assert Ok(_) =
    glimr_mist.handler(init, config.get_string("app.key"))
    |> mist.new()
    |> mist.port(config.listen_port())
    |> mist.start()

  process.sleep_forever()
}
