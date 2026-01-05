import app/http/context/ctx.{type Context}
import app/http/context/ctx_app
import config/config_db
import glimr/http/context/ctx_db

pub fn register() -> Context {
  ctx.Context(
    app: ctx_app.load(),
    db: ctx_db.load(config_db.connections()),
    // Add custom contexts here...
  )
}
