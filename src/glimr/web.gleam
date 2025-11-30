import gleam/bool
import wisp

pub type Context {
  Context(static_directory: String)
}

pub fn middleware(
  req: wisp.Request,
  ctx: Context,
  handle_request: fn(wisp.Request) -> wisp.Response,
) -> wisp.Response {
  let req = wisp.method_override(req)

  use <- wisp.serve_static(req, under: "/static", from: ctx.static_directory)
  use <- wisp.log_request(req)
  use <- default_responses()
  use <- wisp.rescue_crashes
  use req <- wisp.handle_head(req)

  handle_request(req)
}

pub fn default_responses(handle_request: fn() -> wisp.Response) -> wisp.Response {
  let response = handle_request()

  use <- bool.guard(
    when: response.status >= 200 && response.status < 300,
    return: response,
  )

  case response.status {
    404 ->
      "<h1>Not Found</h1>"
      |> wisp.html_body(response, _)

    405 ->
      "<h1>Method Not Allowed</h1>"
      |> wisp.html_body(response, _)

    400 | 422 ->
      "<h1>Bad Request</h1>"
      |> wisp.html_body(response, _)

    413 ->
      "<h1>Request Entity Too Large</h1>"
      |> wisp.html_body(response, _)

    500 ->
      "<h1>Internal Server Errorsss</h1>"
      |> wisp.html_body(response, _)

    _ -> response
  }
}
