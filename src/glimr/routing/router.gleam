import gleam/dict
import gleam/http
import gleam/list
import gleam/string
import glimr/http/kernel
import glimr/routing/route
import wisp

pub fn apply_middleware(
  route_req: route.RouteRequest,
  ctx: context,
  middleware: List(route.Middleware(context)),
  handler: fn(route.RouteRequest, context) -> wisp.Response,
) -> wisp.Response {
  case middleware {
    [] -> handler(route_req, ctx)
    [first, ..rest] -> {
      use req <- first(route_req.request, ctx)

      let updated_route_req = route.RouteRequest(..route_req, request: req)
      apply_middleware(updated_route_req, ctx, rest, handler)
    }
  }
}

pub fn find_matching_route_in_groups(
  route_groups: List(route.RouteGroup(context)),
  path: String,
  method: http.Method,
) -> Result(
  #(route.Route(context), dict.Dict(String, String), kernel.MiddlewareGroup),
  Nil,
) {
  route_groups
  |> list.find_map(fn(group) {
    case find_matching_route(group.routes, path, method) {
      Ok(#(route, params)) -> Ok(#(route, params, group.middleware_group))
      Error(_) -> Error(Nil)
    }
  })
}

pub fn get_all_routes(
  route_groups: List(route.RouteGroup(context)),
) -> List(route.Route(context)) {
  route_groups
  |> list.flat_map(fn(group) { group.routes })
}

pub fn matches_path(pattern: String, path: String) -> Bool {
  let pattern_segments = string.split(pattern, "/")
  let path_segments = string.split(path, "/")

  case list.length(pattern_segments) == list.length(path_segments) {
    False -> False
    True -> do_match_segments(pattern_segments, path_segments)
  }
}

fn find_matching_route(
  routes: List(route.Route(context)),
  path: String,
  method: http.Method,
) -> Result(#(route.Route(context), dict.Dict(String, String)), Nil) {
  routes
  |> list.find_map(fn(route) {
    case route.method == method && matches_path(route.path, path) {
      True -> {
        let params = extract_params(route.path, path)
        Ok(#(route, params))
      }
      False -> Error(Nil)
    }
  })
}

fn do_match_segments(
  pattern_segments: List(String),
  path_segments: List(String),
) -> Bool {
  case pattern_segments, path_segments {
    [], [] -> True
    [p, ..rest_p], [s, ..rest_s] -> {
      let matches = case is_param(p) {
        True -> True
        False -> p == s
      }
      case matches {
        True -> do_match_segments(rest_p, rest_s)
        False -> False
      }
    }
    _, _ -> False
  }
}

fn is_param(segment: String) -> Bool {
  string.starts_with(segment, "{") && string.ends_with(segment, "}")
  // TODO: make this work with {user:id} for example, where user would be
  // the param name, but behind the scenes we can resolve the user by what comes
  // after the : (in this case id) 
}

fn extract_params(pattern: String, path: String) -> dict.Dict(String, String) {
  // TODO: if param contains a : use that to extract the correct value
  // and we can possibly throw an error from here like a 404 for example
  // if we get {user:id} and the url value is "10" but a user of id 10
  // does not exist. That way it doesn't have to be handled every time 
  // in the controller method

  let pattern_segments = string.split(pattern, "/")
  let path_segments = string.split(path, "/")

  do_extract_params(pattern_segments, path_segments, dict.new())
}

fn do_extract_params(
  pattern_segments: List(String),
  path_segments: List(String),
  params: dict.Dict(String, String),
) -> dict.Dict(String, String) {
  case pattern_segments, path_segments {
    [], [] -> params
    [p, ..rest_p], [s, ..rest_s] -> {
      let new_params = case is_param(p) {
        True -> {
          let param_name =
            p
            |> string.drop_start(1)
            |> string.drop_end(1)
          dict.insert(params, param_name, s)
        }
        False -> params
      }
      do_extract_params(rest_p, rest_s, new_params)
    }
    _, _ -> params
  }
}
