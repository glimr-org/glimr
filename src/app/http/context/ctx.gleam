import app/http/context/ctx_app

pub type Context {
  Context(
    app: ctx_app.Context,
    // add other third-party contexts here
    // ex.
    // custom_package: custom_package.Context
  )
}
