// import app/http/context/ctx_db.{type DbContext}
import app/http/context/ctx_cache.{type CacheContext}

// Application Context
//
// https://github.com/glimr-org/glimr?tab=readme-ov-file#context-system
//
// The context system provides type-safe dependency injection
// and singletons. It's passed into all controller functions, 
// middleware, form requests and validation rules. 

pub type Context {
  Context(
    cache: CacheContext,
    // db: DbContext,
    // ...
  )
}
