//// Cache Context
////
//// This is where you can set up your different cache stores. You can be
//// connected to multiple cache stores at once if needed and access them
//// wherever context is injected.
////
//// https://github.com/glimr-org/glimr?tab=readme-ov-file#cache
////

import glimr/cache/cache.{type CachePool}
import glimr/cache/file

pub type CacheContext {
  CacheContext(
    main: CachePool,
    // ...
  )
}

pub fn load() -> CacheContext {
  CacheContext(main: file.start("main"))
}
