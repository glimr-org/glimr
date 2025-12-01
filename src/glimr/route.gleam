import gleam/http.{type Method}
import glimr/web.{type Context}
import wisp.{type Request, type Response}

// TODO: Add documentation to all of this...

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
    path: path,
    handler: handler,
    middleware: [],
    name: "",
  )
}

pub fn post(path: String, handler: RouteHandler) -> Route {
  Route(
    method: http.Post,
    path: path,
    handler: handler,
    middleware: [],
    name: "",
  )
}

pub fn put(path: String, handler: RouteHandler) -> Route {
  Route(
    method: http.Put,
    path: path,
    handler: handler,
    middleware: [],
    name: "",
  )
}

pub fn delete(path: String, handler: RouteHandler) -> Route {
  Route(
    method: http.Delete,
    path: path,
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
