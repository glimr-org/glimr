# Glimr ✨

A type-safe web framework for Gleam that brings functional programming elegance and developer productivity to web development.

If you'd like to stay updated on Glimr's development, Follow [@migueljarias](https://x.com/migueljarias) on X (that's me) for updates, behind-the-scenes stuff and overall nonsense.

## About Glimr

Glimr is a Laravel-inspired web framework built for Gleam. It provides a delightful developer experience with type-safe routing, middleware, singletons, and more - all leveraging Gleam's functional programming paradigm.

> **Note:** This repository contains the Glimr application template. If you want to contribute to the core framework, visit the [framework repository](https://github.com/glimr-org/framework).

## Features

- **Type Safe Routing** - Pattern matching routes with compile-time type safety and automatic 404/405 handling
- **View Builder** - Fluent API for rendering HTML and Lustre components with layouts
- **Template Engine** - Simple `{{ variable }}` syntax for dynamic content
- **Redirect Builder** - Clean redirect API with flash message support
- **Middleware System** - Composable middleware at route and group levels
- **Middleware Groups** - Pre-configured middleware stacks for different route types (Web, API, Custom)
- **Form Validation** - Elegant form validation layer to easily validate requests
- **Lustre Integration** - Server-side rendering of Lustre components
- **Context/Singleton System** - Type-safe use of singletons throughout your application
- **Controller Pattern** - Organized request handlers with clear separation of concerns
- **Configuration Management** - Environment-based configuration with `.env` support
- **Provider Pattern** - Service providers for bootstrapping application services

## Installation

### Prerequisites

- [Gleam stdlib](https://github.com/gleam-lang/stdlib) >= 0.44.0
- [Erlang/OTP](https://www.erlang.org/) >= 26.0

### Clone the Template

```sh
git clone https://github.com/glimr-org/glimr.git my-app
cd my-app
gleam deps download
```

### Environment Setup

Create a `.env` file in the project root:

```sh
cp .env.example .env
```

Configure your environment variables:

```env
APP_NAME=Glimr
APP_PORT=8000
APP_DEBUG=true
APP_URL=http://localhost:8000
APP_KEY=your-secret-key-here
```

### Run the Application

```sh
gleam run
```

Visit `http://localhost:8000` in your browser.

## Project Structure

```
├── src/
│   ├── glimr_app.gleam           # Application entry point
│   ├── app/
│   │   ├── http/
│   │   │   ├── controllers/      # Request handlers
│   │   │   ├── middleware/       # Custom middleware
│   │   │   ├── context/          # Application context
│   │   │   └── kernel.gleam      # HTTP middleware configuration
│   │   └── providers/            # Service providers
│   │       ├── ctx_provider.gleam   # Context registration
│   │       └── route_provider.gleam # Route group registration
│   ├── bootstrap/
│   │   └── app.gleam            # Application bootstrapping
│   ├── config/                  # Configuration files
│   ├── routes/
│   │   ├── web.gleam            # Web routes
│   │   └── api.gleam            # API routes
│   └── static/                  # Static assets
├── test/                        # Test files
├── .env                         # Environment variables
└── gleam.toml                   # Project configuration
```

## Quick Start

### Defining Routes

Routes are defined using pattern matching in `src/routes/web.gleam`, `src/routes/api.gleam`, or any other route file you register:

```gleam
import gleam/http.{Get, Post}
import glimr/routing/router
import app/http/controllers/home_controller
import app/http/controllers/user_controller
import wisp

pub fn routes(path, method, req, ctx) {
  case path {
    // equivalent to "/"
    [] ->
      case method {
        Get -> home_controller.show(req, ctx)
        _ -> wisp.response(405)
      }

    // equivalent to "/users"
    ["users"] ->
      case method {
        Get -> user_controller.index(req, ctx)
        Post -> user_controller.store(req, ctx)
        _ -> wisp.response(405)
      }

    // equivalent to "/users/:user_id"
    ["users", user_id] ->
      case method {
        Get -> user_controller.show(user_id, req, ctx)
        _ -> wisp.response(405)
      }

    _ -> wisp.not_found()
  }
}
```

**How it works:**
- Pattern match on `path` (list of URL segments)
- Pattern match on `method` to handle different HTTP methods
- Returns **404** for unknown paths
- Type-safe parameter extraction from the path

#### Route Redirects

Define redirects directly in your routes:

```gleam
["old-contact"] -> wisp.redirect("/contact")
```

### Creating Controllers

Controllers live in `src/app/http/controllers/`:

```gleam
import app/http/context/ctx
import glimr/response/view
import glimr/response/redirect
import wisp

pub fn show(user_id: String, req: wisp.Request, ctx: ctx.Context) -> wisp.Response {
  // user_id is passed directly from the route pattern match

  view.build()
  |> view.html("users/show.html")
  |> view.data([#("user_id", user_id)])
  |> view.render()
}

pub fn store(req: wisp.Request, ctx: ctx.Context) -> wisp.Response {
  // Handle POST request...

  redirect.build()
  |> redirect.back(req)
  |> redirect.flash([#("message", "User created!")])
  |> redirect.go()
}
```

### Route Parameters

Parameters are extracted directly via pattern matching:

```gleam
// Route definition with type-safe parameter extraction
pub fn routes(path, method, req, ctx) {
  case path {
    ["posts", slug, "comments", comment_id] ->
      case method {
        Get -> comment_controller.show(slug, comment_id, req, ctx)
      }

    ...
  }
}

// Controller receives parameters directly
pub fn show(
  slug: String,
  comment_id: String,
  req: wisp.Request,
  ctx: ctx.Context
) -> wisp.Response {
  // Use slug and comment_id...
}
```

### Form Validation

Glimr provides a declarative, rule-based validation system for form data. Create form request modules to define validation rules and handle requests.

#### Creating Form Requests

Form request modules live in `src/app/http/requests/`:

```gleam
// src/app/http/requests/contact_request.gleam
import glimr/forms/validation.{Email, MaxLength, MinLength, Required}
import wisp

pub fn rules(form: wisp.FormData) {
  validation.start([
    form |> validation.for("name", [Required, MinLength(2)]),
    form |> validation.for("email", [Required, Email, MaxLength(255)]),
  ])
}

pub fn validate(req, on_valid) {
  rules |> validation.handle(req, on_valid)
}
```

#### Using Validation in Controllers

Use the `use` syntax for clean, readable validation handling:

```gleam
import app/http/requests/contact_request

pub fn store(req: wisp.Request, ctx: ctx.Context) -> wisp.Response {
  // Form validation errors are handled automatically
  use _form <- contact_request.validate(req)

  // Form is valid, redirect back with a success message
  redirect.build()
  |> redirect.back(req)
  |> redirect.flash([#("message", "Contact form submitted successfully!")])
  |> redirect.go()
}
```

> **Note:** Flash messaging isn't supported yet, as session support hasn't been implemented.

If validation fails, a 422 response with validation errors is automatically returned.

> **Note:** Currently, validation errors just show up in a basic view. Eventually, web routes will redirect back with the errors, and API routes will return a 422 JSON response.

#### Available Validation Rules

**Text & String Rules:**
- **Required** - Field must have a value
- **Email** - Field must be a valid email address
- **MinLength(Int)** - Field must be at least n characters
- **MaxLength(Int)** - Field must be at most n characters
- **Url** - Field must be a valid URL

**Numeric Rules:**
- **Numeric** - Field must be numeric
- **Min(Int)** - Numeric field must be at least n
- **Max(Int)** - Numeric field must be at most n
- **Digits(Int)** - Field must have exactly n digits
- **MinDigits(Int)** - Field must have at least n digits
- **MaxDigits(Int)** - Field must have at most n digits

**File Upload Rules:**
- **FileRequired** - File field must have a file uploaded
- **FileMinSize(Int)** - File must be at least n KB
- **FileMaxSize(Int)** - File must be at most n KB
- **FileExtension(List(String))** - File must have one of the allowed extensions (e.g., `["jpg", "png"]`)

#### Accessing Form Data

Extract individual form field values:

```gleam
import glimr/forms/form

pub fn store(req: wisp.Request, ctx: ctx.Context) -> wisp.Response {
  use form <- store_contact.validate(req)

  let name = form |> form.get("name")
  let email = form |> form.get("email")

  // Process the data...
}
```

### Views & Responses

Glimr provides a fluent builder pattern for rendering views with layouts and template variables.

#### Rendering Views

```gleam
import glimr/response/view
import config/config_app

pub fn show(req: wisp.Request, ctx: ctx.Context) -> wisp.Response {
  view.build()
  |> view.html("welcome.html")
  |> view.data([#("title", "Welcome")])
  |> view.render()
}
```

#### Rendering Lustre Components

Glimr seamlessly integrates with [Lustre](https://hexdocs.pm/lustre/) for server-side rendering:

```gleam
import glimr/response/view
import resources/views/contact/contact_form

pub fn show(req: wisp.Request, ctx: ctx.Context) -> wisp.Response {
  let model = contact_form.init(Nil)

  view.build()
  |> view.lustre(contact_form.view(model))
  |> view.data([#("title", "Contact Us")])
  |> view.render()
}
```

#### Custom Layouts

Override the default layout for specific views:

```gleam
view.build()
|> view.html("dashboard.html")
// Layouts are found in src/resources/views/layouts/*
|> view.layout("admin.html")
|> view.data([#("title", "Admin Dashboard")])
|> view.render()
```

#### Template Variables

Views use `{{variable}}` syntax for template substitution. The special `{{_content_}}` variable is reserved for the main content:

```html
<!-- layouts/app.html -->
<!DOCTYPE html>
<html>
  <head>
    <title>{{title}} - {{app_name}}</title>
  </head>
  <body>
    {{_content_}}
  </body>
</html>
```

### Redirects

Glimr's redirect builder provides a clean API for redirecting users with flash messages.

#### Basic Redirects

```gleam
import glimr/response/redirect

pub fn store(req: wisp.Request, ctx: ctx.Context) -> wisp.Response {
  // Process form...

  redirect.build()
  |> redirect.to("/contact/success")
  |> redirect.go()
}
```

#### Redirects with Flash Messages

Flash messages persist data across redirects (requires session support):

```gleam
pub fn store(req: wisp.Request, ctx: ctx.Context) -> wisp.Response {
  // Process form...

  redirect.build()
  |> redirect.to("/dashboard")
  |> redirect.flash([#("success", "Contact form submitted!")])
  |> redirect.go()
}
```

> **Note:** Flash messaging isn't supported yet, as session support hasn't been implemented.

#### Redirect Back

Redirect users back to the previous page:

```gleam
pub fn cancel(req: wisp.Request, ctx: ctx.Context) -> wisp.Response {
  redirect.build()
  |> redirect.back(req)
  |> redirect.go()
}
```

### Middleware

Create custom middleware in `src/app/http/middleware/`:

```gleam
import wisp

pub fn handle(
  req: wisp.Request,
  ctx: context,
  next: fn(wisp.Request) -> wisp.Response,
) -> wisp.Response {
  // Before request
  io.println("Request received")

  next(req)
}
```

Apply middleware to specific routes using the helper:

```gleam
import app/http/middleware/logger.{handle as logger}
import app/http/middleware/auth.{handle as auth}
import glimr/http/middleware

pub fn routes(path, method, req, ctx) {
  case path {
    ["dashboard"] ->
      case method {
        Get -> {
          // Apply multiple middleware to this route
          use req <- middleware.apply([auth, logger], req, ctx)
          dashboard_controller.show(req, ctx)
        }
      }

    ...
  }
}
```

### Route Groups

Route groups are defined in `src/app/providers/route_provider.gleam`. Each group has a prefix and middleware stack:

```gleam
import glimr/routing/router.{type RouteGroup}
import glimr/http/kernel

pub fn register() -> List(RouteGroup(Context)) {
  [
    // API routes - prefixed with "/api"
    router.RouteGroup(
      prefix: "/api",
      middleware_group: kernel.Api,  // JSON error responses
      routes: api.routes,
    ),

    // Admin routes - prefixed with "/admin"
    router.RouteGroup(
      prefix: "/admin",
      middleware_group: kernel.Custom("admin"),  // Custom middleware stack
      routes: admin.routes,
    ),

    // Default web routes - no prefix (must be last)
    router.RouteGroup(
      prefix: "",
      middleware_group: kernel.Web,  // HTML error responses
      routes: web.routes,
    ),
  ]
}
```

### API Routes

API routes are automatically:
- Prefixed with `/api` (configured in `route_provider.gleam`)
- Return JSON error responses (404, 405, 500, etc.) instead of HTML

### Configuration

Access configuration values anywhere in your application:

```gleam
import config/config_app

pub fn show(req: wisp.Request, ctx: ctx.Context) -> wisp.Response {
  let app_name = config_app.name()
  let app_url = config_app.url()
  let debug_mode = config_app.debug()

  // Use configuration...
}
```

Add your own configuration files in `src/config/`.

### Context System

The context system provides type-safe dependency injection. Define your context in `src/app/http/context/`:

```gleam
// src/app/http/context/ctx.gleam
pub type Context {
  Context(
    app: ctx_app.Context,
    // Add your own contexts here
    // database: database.Context,
    // cache: cache.Context,
  )
}
```

Register contexts in the provider:

```gleam
// src/app/providers/ctx_provider.gleam
pub fn register() -> ctx.Context {
  ctx.Context(
    app: ctx_app.load(),
    // Initialize your contexts here
  )
}
```

Access context in controllers:

```gleam
pub fn show(req: wisp.Request, ctx: ctx.Context) -> wisp.Response {
  let static_dir = ctx.app.static_directory
  // Use context...
}
```

## Development

### Running Tests

```sh
gleam test
```

### Building for Production

```sh
gleam build
```

## Learn More

- [Framework Repository](https://github.com/glimr-org/framework) - Core framework code
- [Gleam Documentation](https://gleam.run/documentation/) - Learn Gleam
- [Wisp Documentation](https://hexdocs.pm/wisp/) - Web server library

### Built With

Glimr is built on top of these excellent Gleam libraries:

- [**Wisp**](https://hexdocs.pm/wisp/) - The web framework that powers Glimr's HTTP handling
- [**gleam_http**](https://hexdocs.pm/gleam_http/) - HTTP types and utilities
- [**gleam_json**](https://hexdocs.pm/gleam_json/) - JSON encoding and decoding
- [**gleam_stdlib**](https://hexdocs.pm/gleam_stdlib/) - Gleam's standard library

Special thanks to the Gleam community for building such an awesome ecosystem!

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

The Glimr framework is open-sourced software licensed under the [MIT](https://opensource.org/license/MIT) license.

## Credits

Glimr is inspired by [Laravel](https://laravel.com/) and adapted for Gleam's functional programming paradigm.
