//// Application Context
////
//// The context system provides type-safe dependency injection and 
//// app singletons. This context is  passed into all controller functions, 
//// middleware, form requests and validation rules. 
////
//// https://github.com/glimr-org/glimr?tab=readme-ov-file#context-system
////

import data/main/models/user/gen/user
import gleam/option.{type Option}
import glimr/cache/cache.{type CachePool}
import glimr/db/pool_connection.{type Pool}
import glimr/response/response.{type ResponseFormat}
import glimr/session/session.{type Session}

pub type Context {
  Context(
    response_format: ResponseFormat,
    cache: CachePool,
    db: Pool,
    session: Session,
    user: Option(user.User),
  )
}
