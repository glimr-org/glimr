import app/http/context/ctx_app.{type AppContext}
import glimr_sqlite/http/context/ctx.{type SqliteContext}

pub type Context {
  Context(
    app: AppContext,
    db: SqliteContext,
    // Add other third-party contexts here...
  )
}
