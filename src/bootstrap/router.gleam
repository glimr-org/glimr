import app/http/context/ctx
import app/http/kernel
import app/providers/route_provider
import config/config_api
import gleam/http/response
import gleam/list
import gleam/string
import glimr/http/kernel as base_kernel
import glimr/routing/route
import glimr/routing/router
import wisp

pub fn handle(req: wisp.Request, ctx: ctx.Context) -> wisp.Response {
  let path = "/" <> string.join(wisp.path_segments(req), "/")
  let method = req.method
  let route_groups = route_provider.register()

  case router.find_matching_route_in_groups(route_groups, path, method) {
    Ok(#(route, params, group)) -> {
      let route_req = route.RouteRequest(request: req, params: params)
      use req <- kernel.handle(route_req.request, ctx, group)
      let updated_route_req = route.RouteRequest(..route_req, request: req)
      router.apply_middleware(
        updated_route_req,
        ctx,
        route.middleware,
        route.handler,
      )
    }
    Error(_) -> {
      let group = case string.starts_with(path, config_api.route_prefix()) {
        True -> base_kernel.Api
        False -> base_kernel.Web
      }

      let all_routes = router.get_all_routes(route_groups)
      let status = case
        all_routes
        |> list.any(fn(route) { router.matches_path(route.path, path) })
      {
        True -> 405
        False -> 404
      }

      use _req <- kernel.handle(req, ctx, group)
      response.Response(status, [], wisp.Text(""))
    }
  }
}
