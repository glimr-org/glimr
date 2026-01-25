import bootstrap/gen/loom/welcome
import glimr/response/response
import glimr/routing/route

// Web Routes
// 
// https://github.com/glimr-org/glimr?tab=readme-ov-file#defining-routes
// https://github.com/glimr-org/glimr?tab=readme-ov-file#loom
//
// This is where you can register web routes for your application.
// The routes registered here are loaded within the "web"
// middleware group as defined in route_provider.gleam.

pub fn routes() {
  [
    route.get("/", fn(_req, _ctx) {
      // Welcome to Glimr.
      // Build something beautiful.

      response.html(welcome.html(), 200)
    }),
  ]
}
