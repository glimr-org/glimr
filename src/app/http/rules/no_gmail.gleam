import app/http/context/ctx.{type Context}
import gleam/string

pub fn run(value: String, _ctx: Context) -> Result(Nil, String) {
  case string.contains(value, "gmail") {
    False -> Ok(Nil)
    True -> Error("cannot be a Gmail address")
  }
}
