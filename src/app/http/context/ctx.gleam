import app/http/context/ctx_app.{type Context as AppContext}

pub type Context {
  Context(
    app: AppContext,
    // add other third-party contexts here
    // ex.
    // custom_package: CustomPackageContext
  )
}
