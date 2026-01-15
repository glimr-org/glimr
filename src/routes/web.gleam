import glimr/response/view
import glimr/routing/route

// Web Routes
//
// https://github.com/glimr-org/glimr?tab=readme-ov-file#defining-routes
//
// This is where you can register web routes for your application.
// The routes registered here are loaded within the "web"
// middleware group as defined in route_provider.gleam.

pub fn routes() {
  [
    route.get("/", fn(_req, _ctx) {
      view.build()
      |> view.html("welcome.html")
      |> view.render()
    }),
  ]
}
