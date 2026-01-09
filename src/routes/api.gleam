import wisp

// Api Routes
// 
// Handles routing for API requests under the /api prefix. 
// Matches the URL path and HTTP method to the appropriate 
// controller action, returning JSON responses.

pub fn routes(path, _method, _req, _ctx) {
  case path {
    // Below resolves to /api/users/123 for example.
    // 
    // ["users", user_id] -> case method {
    //   Get -> user_controller.show(user_id, req, ctx)
    //   _ -> wisp.method_not_allowed([Get])
    // }
    _ -> wisp.not_found()
  }
}
