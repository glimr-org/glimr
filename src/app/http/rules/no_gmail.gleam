import gleam/string

pub fn run(value: String) -> Result(Nil, String) {
  case string.contains(value, "gmail") {
    False -> Ok(Nil)
    True -> Error("cannot be a Gmail address")
  }
}
