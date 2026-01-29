//// Route Group Configuration
////
//// Defines route groups for the application. Each group maps a
//// URL prefix to an output file name and middleware group. 
//// Routes are compiled into separate files based on their 
//// prefix match.
////

import glimr/http/kernel
import glimr/routing/router.{type RouteGroupConfig, RouteGroupConfig}

/// Route Groups
///
/// Returns the route group configuration. Groups are matched in
/// order with longest prefix winning. The empty prefix "" acts
/// as a catch-all and should be last.
///
pub fn groups() -> List(RouteGroupConfig) {
  [
    RouteGroupConfig(
      name: "api",
      prefix: "/api",
      middleware: kernel.Api,
      //
    ),
    // Register custom route groups here before the 
    // default "web" group below.
    RouteGroupConfig(
      name: "web",
      prefix: "",
      middleware: kernel.Web,
      //
    ),
  ]
}
