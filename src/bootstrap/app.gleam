import bootstrap/router
import dot_env
import glimr/context
import wisp

pub fn init() -> fn(wisp.Request) -> wisp.Response {
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
  let ctx = context.Context(static_directory: get_static_directory())

  router.handle(_, ctx)
}

fn get_static_directory() -> String {
  let assert Ok(priv_dir) = wisp.priv_directory("glimr")

  priv_dir <> "/static"
}
