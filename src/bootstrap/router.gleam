import app/http/context/ctx.{type Context}
import app/http/kernel
import app/providers/route_provider
import gleam/http/response
import gleam/list
import gleam/string
import glimr/http/kernel as base_kernel
import glimr/routing/route
import glimr/routing/router
import wisp.{type Request, type Response}

pub fn handle(req: Request, ctx: Context) -> Response {
  let path = "/" <> string.join(wisp.path_segments(req), "/")
  let method = req.method
  let route_groups = route_provider.register()

  let matching_group =
    list.find(route_groups, fn(group) {
      case group.prefix {
        "" -> True
        prefix -> string.starts_with(path, prefix)
      }
    })

  case matching_group {
    Ok(group) -> {
      let loaded_routes = group.routes()

      case router.find_matching_route(loaded_routes, path, method) {
        Ok(#(route, params)) -> {
          let route_req = route.RouteRequest(request: req, params: params)
          use req <- kernel.handle(
            route_req.request,
            ctx,
            group.middleware_group,
          )
          let updated_route_req = route.RouteRequest(..route_req, request: req)
          router.apply_middleware(
            updated_route_req,
            ctx,
            route.middleware,
            route.handler,
          )
        }
        Error(router.NoRouteFound) -> {
          use _req <- kernel.handle(req, ctx, group.middleware_group)
          response.Response(404, [], wisp.Text(""))
        }
        Error(router.MethodNotAllowed) -> {
          use _req <- kernel.handle(req, ctx, group.middleware_group)
          response.Response(405, [], wisp.Text(""))
        }
      }
    }
    Error(_) -> {
      use _req <- kernel.handle(req, ctx, base_kernel.Web)
      response.Response(404, [], wisp.Text(""))
    }
  }
}
