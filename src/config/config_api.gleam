//// ------------------------------------------------------------
//// API Configuration
//// ------------------------------------------------------------
////
//// Configuration module for managing API-specific application 
//// settings. Controls route prefixes and behavior for API 
//// endpoints in the app.
////

/// ------------------------------------------------------------
/// API Route Prefix
/// ------------------------------------------------------------
///
/// The URL prefix automatically prepended to all API route 
/// definitions. Routes with this prefix will use API middleware 
/// for JSON error responses.
///
pub fn route_prefix() -> String {
  "/api"
}
