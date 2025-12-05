import app/http/context/ctx.{type Context}
import app/http/context/ctx_app

pub fn register() -> Context {
  ctx.Context(
    app: ctx_app.load(),
    // load other contexts here...
  )
}
