// TODO: module docs

import app/http/context/ctx_app.{type AppContext}
import glimr/http/context/ctx_db.{type DbContext}

pub type Context {
  Context(
    app: AppContext,
    db: DbContext,
    // Add third-party contexts here...
  )
}
