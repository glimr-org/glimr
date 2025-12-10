import wisp

pub fn routes(path, method, _req, _ctx) {
  case path, method {
    // ["users"], Get -> user_controller.index(req, ctx)
    // ["users", user_id], Get -> user_controller.show(user_id, req, ctx)
    _, _ -> wisp.response(404)
  }
}
