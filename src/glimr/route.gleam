import gleam/http.{type Method}
import gleam/list
import gleam/string
import glimr/web.{type Context}
import wisp.{type Request, type Response}

// TODO: document all this

type RouteHandler =
  fn(Request, Context) -> Response

pub type Middleware =
  fn(Request, Context, fn(Request) -> Response) -> Response

pub type Route {
  Route(
    method: Method,
    path: String,
    handler: RouteHandler,
    middleware: List(Middleware),
    name: String,
  )
}

pub fn get(path: String, handler: RouteHandler) -> Route {
  Route(
    method: http.Get,
    path: normalize_path(path),
    handler: handler,
    middleware: [],
    name: "",
  )
}

pub fn post(path: String, handler: RouteHandler) -> Route {
  Route(
    method: http.Post,
    path: normalize_path(path),
    handler: handler,
    middleware: [],
    name: "",
  )
}

pub fn put(path: String, handler: RouteHandler) -> Route {
  Route(
    method: http.Put,
    path: normalize_path(path),
    handler: handler,
    middleware: [],
    name: "",
  )
}

pub fn delete(path: String, handler: RouteHandler) -> Route {
  Route(
    method: http.Delete,
    path: normalize_path(path),
    handler: handler,
    middleware: [],
    name: "",
  )
}

pub fn middleware(route: Route, middleware: List(Middleware)) -> Route {
  Route(..route, middleware: middleware)
}

pub fn name(route: Route, name: String) -> Route {
  Route(..route, name: name)
}

pub fn group_middleware(
  middleware: List(Middleware),
  routes: fn() -> List(Route),
) -> List(Route) {
  use route <- list.map(routes())

  Route(..route, middleware: list.append(middleware, route.middleware))
}

pub fn group_path_prefix(
  prefix: String,
  routes: fn() -> List(Route),
) -> List(Route) {
  use route <- list.map(routes())

  Route(..route, path: normalize_path(prefix) <> route.path)
}

pub fn group_name_prefix(
  name: String,
  routes: fn() -> List(Route),
) -> List(Route) {
  use route <- list.map(routes())

  Route(..route, name: name <> route.name)
}

fn normalize_path(path: String) -> String {
  path
  |> ensure_leading_slash
  |> remove_trailing_slash
}

fn ensure_leading_slash(path: String) -> String {
  case string.starts_with(path, "/") {
    True -> path
    False -> "/" <> path
  }
}

fn remove_trailing_slash(path: String) -> String {
  case path {
    "/" -> "/"
    _ ->
      case string.ends_with(path, "/") {
        True -> string.drop_end(path, 1)
        False -> path
      }
  }
}
