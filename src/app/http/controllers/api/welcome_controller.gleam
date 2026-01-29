//// Welcome (API) Controller
////
//// This is an example API controller returning JSON. Routes are defined 
//// via annotation comments above handlers and compiled to pattern-match 
//// routers in /compiled/routes/. The default "api" route group 
//// (/api prefix) compiles to an api.gleam file.
////
//// https://github.com/glimr-org/glimr?tab=readme-ov-file#defining-routes
//// https://github.com/glimr-org/glimr?tab=readme-ov-file#route-groups
//// https://github.com/glimr-org/glimr?tab=readme-ov-file#controllers
//// https://github.com/gleam-lang/json
////

import app/http/context/ctx.{type Context}
import gleam/json
import glimr/response/response
import wisp.{type Request, type Response}

/// Welcome to Glimr ✨
/// Build something beautiful...
///
/// @get "/api/welcome"
///
pub fn show(_req: Request, _ctx: Context) -> Response {
  json.string("Welcome to Glimr ✨") |> response.json(200)
}
