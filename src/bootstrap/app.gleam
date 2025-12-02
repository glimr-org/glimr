import dot_env
import glimr/request_handler
import glimr/web.{Context}
import wisp.{type Request, type Response}

pub fn init() -> fn(Request) -> Response {
  wisp.configure_logger()

  load_env_variables()

  configure_request_handler()
}

fn load_env_variables() {
  dot_env.new()
  |> dot_env.set_path(".env")
  |> dot_env.set_debug(False)
  |> dot_env.load()
}

fn configure_request_handler() -> fn(wisp.Request) -> wisp.Response {
  let ctx = Context(static_directory: get_static_directory())

  request_handler.handle(_, ctx)
}

fn get_static_directory() -> String {
  let assert Ok(priv_dir) = wisp.priv_directory("glimr")

  priv_dir <> "/static"
}
