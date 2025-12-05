import app/providers/ctx_provider
import bootstrap/router
import dot_env
import wisp.{type Request, type Response}

pub fn init() -> fn(Request) -> Response {
  wisp.configure_logger()

  load_env_variables()

  configure_request_handler()
}

fn load_env_variables() -> Nil {
  dot_env.new()
  |> dot_env.set_path(".env")
  |> dot_env.set_debug(False)
  |> dot_env.load()
}

fn configure_request_handler() -> fn(Request) -> Response {
  router.handle(_, ctx_provider.register())
}
