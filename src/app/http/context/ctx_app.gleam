import wisp

pub type Context {
  Context(static_directory: String)
}

pub fn load() -> Context {
  Context(static_directory: get_static_directory())
}

fn get_static_directory() -> String {
  let assert Ok(priv_dir) = wisp.priv_directory("glimr")

  priv_dir <> "/static"
}
