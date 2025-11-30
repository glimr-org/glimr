import gleam/http.{type Method}
import glimr/web.{type Context}
import wisp.{type Request, type Response}

type RouteHandler =
  fn(Request, Context) -> Response

pub type Route {
  Route(method: Method, path: String, handler: RouteHandler)
}

pub fn get(path: String, handler: RouteHandler) -> Route {
  Route(method: http.Get, path: path, handler: handler)
}

pub fn post(path: String, handler: RouteHandler) -> Route {
  Route(method: http.Post, path: path, handler: handler)
}

pub fn put(path: String, handler: RouteHandler) -> Route {
  Route(method: http.Put, path: path, handler: handler)
}

pub fn delete(path: String, handler: RouteHandler) -> Route {
  Route(method: http.Delete, path: path, handler: handler)
}
