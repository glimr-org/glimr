import gleam/json
import glimr/routing/route
import wisp

// Api Routes
//
// https://github.com/glimr-org/glimr?tab=readme-ov-file#defining-routes
// https://github.com/glimr-org/glimr?tab=readme-ov-file#api-routes
//
// This is where you can register api routes for your application.
// The routes registered here are loaded within the "api"
// middleware group as defined in route_provider.gleam. Default
// error pages are automatically returned as json.

pub fn routes() {
  [
    route.get("/welcome", fn(_req, _ctx) {
      let json = json.to_string(json.string("Welcome to Glimr ✨"))

      wisp.json_response(json, 200)
    }),
  ]
}
