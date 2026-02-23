//// Application Context
////
//// The context system provides type-safe dependency injection and 
//// app singletons. This context is  passed into all controller functions, 
//// middleware, form requests and validation rules. 
////
//// https://github.com/glimr-org/glimr?tab=readme-ov-file#context-system
////

import app/http/context/ctx_cache.{type CacheContext}
import app/http/context/ctx_db.{type DbContext}
import data/main/models/user/gen/user
import gleam/option.{type Option}
import glimr/response/response.{type ResponseFormat}
import glimr/session/session.{type Session}

pub type Context {
  Context(
    response_format: ResponseFormat,
    cache: CacheContext,
    db: DbContext,
    session: Session,
    user: Option(user.User),
  )
}
