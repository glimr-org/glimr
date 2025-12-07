import bootstrap/app
import config/config_app
import gleam/erlang/process
import mist
import wisp/wisp_mist

pub fn main() -> Nil {
  let assert Ok(_) =
    wisp_mist.handler(app.init(), config_app.key())
    |> mist.new()
    |> mist.port(config_app.port())
    |> mist.start()

  process.sleep_forever()
}
