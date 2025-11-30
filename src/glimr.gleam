import app/config/config_app
import dot_env
import gleam/erlang/process
import glimr/request_handler
import glimr/web.{Context}
import mist
import wisp
import wisp/wisp_mist

pub fn main() -> Nil {
  wisp.configure_logger()

  dot_env.new()
  |> dot_env.set_path(".env")
  |> dot_env.set_debug(False)
  |> dot_env.load()

  let ctx = Context(static_directory: static_directory())

  let handler = request_handler.handle(_, ctx)

  // TODO: maybe a match statement on the app env, if local then 
  // starts on a port, if not then idk...

  // TODO: figure out what this mist handler key is for and if it should be 
  // called APP_KEY or if it should be something else.

  // TODO: dynamically generate the app key? maybe with a Makefile command

  let assert Ok(_) =
    wisp_mist.handler(handler, config_app.key())
    |> mist.new()
    |> mist.port(config_app.port())
    |> mist.start()

  process.sleep_forever()
}

// TODO: maybe move this somewhere else?
fn static_directory() -> String {
  let assert Ok(priv_dir) = wisp.priv_directory("glimr")

  priv_dir <> "/static"
}
