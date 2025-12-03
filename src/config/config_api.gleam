//// --------------------------------------------------------------------------
//// API Configuration
//// --------------------------------------------------------------------------
////
//// Configuration module for managing API-specific application settings.
//// Controls route prefixes and behavior for API endpoints in the app.
//// Used to distinguish API routes from web routes for middleware.
////

/// --------------------------------------------------------------------------
/// API Route Prefix (Default: "/api")
/// --------------------------------------------------------------------------
///
/// The URL prefix automatically prepended to all API route definitions.
/// Routes with this prefix use API middleware for JSON error responses.
/// Used during request handling to determine appropriate middleware.
///
pub fn route_prefix() -> String {
  "/api"
}
