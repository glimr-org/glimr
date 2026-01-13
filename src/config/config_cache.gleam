//// Cache Config
////
//// Cache configuration module for defining cache stores. Add
//// your stores here and load them in ctx_cache.gleam.

import glimr/cache/driver.{type CacheStore}

/// ------------------------------------------------------------
/// Database Connections
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
