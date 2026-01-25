import gleam/json
import glimr/response/response
import glimr/routing/route

// Api Routes
//
// https://github.com/glimr-org/glimr?tab=readme-ov-file#defining-routes
// https://github.com/glimr-org/glimr?tab=readme-ov-file#api-routes
// https://github.com/gleam-lang/json?tab=readme-ov-file#encoding
//
// This is where you can register api routes for your application.
// The routes registered here are loaded within the "api"
// middleware group as defined in route_provider.gleam. Default
// error pages are automatically returned as json.

pub fn routes() {
  [
    route.get("/welcome", fn(_req, _ctx) {
      json.string("Welcome to Glimr ✨")
      |> response.json(200)
    }),
  ]
}
