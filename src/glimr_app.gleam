import bootstrap/app
import config/config_app
import gleam/erlang/process
import mist
import wisp/wisp_mist

pub fn main() -> Nil {
  // TODO: maybe a match statement on the app env, if local then 
  // starts on a port, if not then idk...

  // TODO: figure out what this mist handler key is for and if it should be 
  // called APP_KEY or if it should be something else.

  // TODO: dynamically generate the app key? maybe with a Makefile command

  let assert Ok(_) =
    wisp_mist.handler(app.init(), config_app.key())
    |> mist.new()
    |> mist.port(config_app.port())
    |> mist.start()

  process.sleep_forever()
}
