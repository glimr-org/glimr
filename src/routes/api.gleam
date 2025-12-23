import wisp

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
