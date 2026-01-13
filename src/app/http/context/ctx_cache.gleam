import config/config_cache
import glimr/cache/file
import glimr/cache/file/pool.{type Pool as FilePool}

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
