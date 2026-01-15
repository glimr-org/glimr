import app/http/context/ctx_cache.{type CacheContext}
import app/http/context/ctx_db.{type DbContext}

// Application Context
//
// https://github.com/glimr-org/glimr?tab=readme-ov-file#context-system
//
// The context system provides type-safe dependency injection
// and singletons. It's passed into all controller functions, 
// middleware, form requests and validation rules. 

pub type Context {
  Context(
    db: DbContext,
    cache: CacheContext,
    // ...
  )
}
