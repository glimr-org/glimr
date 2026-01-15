import config/config_cache
import glimr/cache/file
import glimr/cache/file/pool.{type Pool as FilePool}

// Cache Context
//
// https://github.com/glimr-org/glimr?tab=readme-ov-file#cache
//
// This is where you can set up your different cache stores. You
// can be connected to multiple cache stores at once if needed
// and access them wherever context is injected.

pub type CacheContext {
  CacheContext(
    main: FilePool,
    // ...
  )
}

pub fn load() -> CacheContext {
  let stores = config_cache.stores()

  CacheContext(main: file.start("main", stores))
}
