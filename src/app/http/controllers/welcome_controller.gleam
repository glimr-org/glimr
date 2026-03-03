//// Welcome Controller
////
//// This is an example web controller returning a loom view. Routes are 
//// defined via annotation comments above handlers and compiled to 
//// pattern-match routers in /compiled/routes/. The default "web" route 
//// group (no specific prefix) compiles to a web.gleam file.
////
//// https://github.com/glimr-org/glimr?tab=readme-ov-file#defining-routes
//// https://github.com/glimr-org/glimr?tab=readme-ov-file#route-groups
//// https://github.com/glimr-org/glimr?tab=readme-ov-file#controllers
//// https://github.com/glimr-org/glimr?tab=readme-ov-file#loom-template-engine
////

import compiled/loom/welcome
import glimr/http/http.{type Response}
import glimr/response/response

/// Welcome to Glimr ✨
/// Build something beautiful...
///
/// @get "/"
///
pub fn show() -> Response {
  response.html(welcome.render(), 200)
}
