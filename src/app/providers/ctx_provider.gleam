import app/http/context/ctx.{type Context}
import app/http/context/ctx_app
import config/config_db
import glimr_sqlite/http/context/ctx as ctx_sqlite

pub fn register() -> Context {
  ctx.Context(
    app: ctx_app.load(),
    db: ctx_sqlite.load(config_db.connections()),
    // Add other third-party contexts here...
  )
}
