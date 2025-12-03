import app/http/context/ctx
import app/http/context/ctx_app

pub fn register() -> ctx.Context {
  ctx.Context(
    app: ctx_app.load(),
    // load other contexts here...
  )
}
