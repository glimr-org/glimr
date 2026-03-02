//// Application Context
////
//// The context system provides type-safe dependency injection and 
//// app singletons. This context is  passed into all controller functions, 
//// middleware, form requests and validation rules. 
////
//// https://github.com/glimr-org/glimr?tab=readme-ov-file#context-system
////

import glimr/cache/cache.{type CachePool}
import glimr/db/db.{type DbPool}
import glimr/response/response.{type ResponseFormat}
import glimr/session/session.{type Session}

pub type Context {
  Context(
    response_format: ResponseFormat,
    db: DbPool,
    cache: CachePool,
    session: Session,
  )
}
