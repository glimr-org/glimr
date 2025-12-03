import gleam/dict
import gleam/http
import gleam/list
import gleam/result
import gleam/string
import glimr/http/kernel
import wisp

// TODO: document all this

pub type RouteRequest {
  RouteRequest(request: wisp.Request, params: dict.Dict(String, String))
}

pub type RouteGroup(context) {
  RouteGroup(middleware_group: kernel.MiddlewareGroup, routes: List(Route(context)))
}

pub type RouteHandler(context) =
  fn(RouteRequest, context) -> wisp.Response

pub type Middleware(context) =
  fn(wisp.Request, context, fn(wisp.Request) -> wisp.Response) ->
    wisp.Response

pub fn get_param(req: RouteRequest, key: String) -> Result(String, Nil) {
  dict.get(req.params, key)
}

pub fn get_param_or(req: RouteRequest, key: String, default: String) -> String {
  dict.get(req.params, key) |> result.unwrap(default)
}

pub type Route(context) {
  Route(
    method: http.Method,
    path: String,
    handler: RouteHandler(context),
    middleware: List(Middleware(context)),
    name: String,
  )
}

pub fn get(path: String, handler: RouteHandler(context)) -> Route(context) {
  Route(
    method: http.Get,
    path: normalize_path(path),
    handler: handler,
    middleware: [],
    name: "",
  )
}

pub fn post(path: String, handler: RouteHandler(context)) -> Route(context) {
  Route(
    method: http.Post,
    path: normalize_path(path),
    handler: handler,
    middleware: [],
    name: "",
  )
}

pub fn put(path: String, handler: RouteHandler(context)) -> Route(context) {
  Route(
    method: http.Put,
    path: normalize_path(path),
    handler: handler,
    middleware: [],
    name: "",
  )
}

pub fn delete(path: String, handler: RouteHandler(context)) -> Route(context) {
  Route(
    method: http.Delete,
    path: normalize_path(path),
    handler: handler,
    middleware: [],
    name: "",
  )
}

pub fn middleware(route: Route(context), middleware: List(Middleware(context))) -> Route(context) {
  Route(..route, middleware: middleware)
}

pub fn name(route: Route(context), name: String) -> Route(context) {
  Route(..route, name: name)
}

pub fn group_middleware(
  middleware: List(Middleware(context)),
  routes: List(List(Route(context))),
) -> List(Route(context)) {
  use route <- list.map(list.flatten(routes))

  Route(..route, middleware: list.append(middleware, route.middleware))
}

pub fn group_path_prefix(
  prefix: String,
  routes: List(List(Route(context))),
) -> List(Route(context)) {
  use route <- list.map(list.flatten(routes))

  Route(..route, path: normalize_path(prefix) <> route.path)
}

pub fn group_name_prefix(name: String, routes: List(List(Route(context)))) -> List(Route(context)) {
  use route <- list.map(list.flatten(routes))

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
