import app/http/context/ctx_app.{type Context as AppContext}
import app/http/context/ctx_db.{type Context as DbContext}

pub type Context {
  Context(app: AppContext, db: DbContext)
}
