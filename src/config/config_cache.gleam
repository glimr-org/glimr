//// Cache Config
////
//// Cache configuration module for defining your cache stores. 
//// Add your cache stores here and they will be available 
//// throughout your application via the context system.

import glimr/cache/driver.{type CacheStore}

/// ------------------------------------------------------------
/// Cache Stores
/// ------------------------------------------------------------
///
/// Returns all configured cache stores. Each store must have
/// a unique name. Load these in ctx_cache.gleam to make them
/// available throughout your application.
///
/// *File Store:*
///
/// ```gleam
/// driver.FileStore(
///   name: "main", 
///   path: "priv/storage/framework/cache/data",
/// )
/// ```
///
/// *Redis Store:*
///
/// ```gleam
/// driver.RedisStore(
///   name: "redis",
///   url: dot_env.get("REDIS_URL"),
///   pool_size: dot_env.get_int("REDIS_POOL_SIZE"),
/// )
/// ```
///
/// *Database Store:*
///
/// ```gleam
/// DatabaseStore(
///   name: "database",
///   database: "main",
///   table: "cache"
/// ),
/// ```
///
pub fn stores() -> List(CacheStore) {
  [
    driver.FileStore(name: "main", path: "priv/storage/framework/cache/data"),
    // ...
  ]
}
