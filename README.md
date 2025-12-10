# Glimr ✨

A type-safe web framework for Gleam that brings functional programming elegance and developer productivity to web development.

If you'd like to stay updated on Glimr's development, Follow [@migueljarias](https://x.com/migueljarias) on X (that's me) for updates, behind-the-scenes stuff and overall nonsense.

## About Glimr

Glimr is a Laravel-inspired web framework built for Gleam. It provides a delightful developer experience with type-safe routing, middleware, singletons, and more - all leveraging Gleam's functional programming paradigm.

> **Note:** This repository contains the Glimr application template. If you want to contribute to the core framework, visit the [framework repository](https://github.com/glimr-org/framework).

## Features

- **Type Safe Routing** - Laravel-style routing with type safe parameter extraction and handling
- **View Builder** - Fluent API for rendering HTML and Lustre components with layouts
- **Template Engine** - Simple `{{variable}}` syntax for dynamic content
- **Redirect Builder** - Clean redirect API with flash message support
- **Middleware System** - Composable middleware at route and group levels
- **Middleware Groups** - Pre-configured middleware stacks for different route types
- **Form Validation** - Elegant form validation layer to easily validate requests
- **Lustre Integration** - Server-side rendering of Lustre components
- **Context/Singleton System** - Type-safe use of singletons throughout your application
- **Controller Pattern** - Organized request handlers with clear separation of concerns
- **Configuration Management** - Environment-based configuration with `.env` support
- **Web & API Routes** - Separate route groups with appropriate error handling (HTML vs JSON)
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
│   ├── bootstrap/
│   │   ├── app.gleam            # Application bootstrapping
│   │   └── router.gleam         # Router setup
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

Routes are defined in `src/routes/web.gleam` and `src/routes/api.gleam`:

```gleam
import glimr/routing/route
import app/http/controllers/home_controller

pub fn routes() {
  [
    [
      route.get("/", home_controller.show),

      route.get("/users/{id}", user_controller.show),
      route.post("/users", user_controller.store)
    ],
  ]
}
```

#### Route Redirects

Define redirects directly in your routes:

```gleam
// Redirect old URLs to new ones
route.redirect("/old-contact", "/contact")
```

### Creating Controllers

Controllers live in `src/app/http/controllers/`:

```gleam
import app/http/context/ctx
import glimr/routing/route
import glimr/response/view
import glimr/response/redirect
import wisp

pub fn show(req: route.RouteRequest, ctx: ctx.Context) -> wisp.Response {
  let assert Ok(id) = route.get_param(req, "id")

  view.build()
  |> view.html("users/show.html")
  |> view.render()
}

pub fn store(req: route.RouteRequest, ctx: ctx.Context) -> wisp.Response {
  // Handle POST request...

  redirect.build()
  |> redirect.back(req)
  |> redirect.flash([#("message", "User created!")])
  |> redirect.go()    
}
```

### Route Parameters

Extract parameters from the URL:

```gleam
// Route definition
route.get("/posts/{slug}/comments/{id}", comment_controller.show)

// Controller
pub fn show(req: route.RouteRequest, ctx: ctx.Context) -> wisp.Response {
  // Without a fallback
  let assert Ok(slug) = route.get_param(req, "slug")

  // With a fallback
  let id = route.get_param_or(req, "id", "0")

  // Use slug and id...
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

pub fn store(req: route.RouteRequest, ctx: ctx.Context) -> wisp.Response {
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

pub fn store(req: route.RouteRequest, ctx: ctx.Context) -> wisp.Response {
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

pub fn show(req: route.RouteRequest, ctx: ctx.Context) -> wisp.Response {
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

pub fn show(req: route.RouteRequest, ctx: ctx.Context) -> wisp.Response {
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

pub fn store(req: route.RouteRequest, ctx: ctx.Context) -> wisp.Response {
  // Process form...

  redirect.build()
  |> redirect.to("/contact/success")
  |> redirect.go()
}
```

#### Redirects with Flash Messages

Flash messages persist data across redirects (requires session support):

```gleam
pub fn store(req: route.RouteRequest, ctx: ctx.Context) -> wisp.Response {
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
pub fn cancel(req: route.RouteRequest, ctx: ctx.Context) -> wisp.Response {
  redirect.build()
  |> redirect.back(req.request)
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

Apply middleware to routes:

```gleam
import app/http/middleware/logger.{handle as logger}

route.get("/dashboard", dashboard_controller.show)
  |> route.middleware([logger])
```

### Route Groups

Group routes with shared configuration:

```gleam
// Group with middleware
route.group_middleware([auth, logger], [
  [
    route.get("/dashboard", dashboard_controller.show),
    route.get("/profile", profile_controller.show),
  ],
])

// Group with path prefix
route.group_path_prefix("/admin", [
  [
    route.get("/users", admin_users_controller.index),
    route.get("/settings", admin_settings_controller.index),
  ],
])

// Group with name prefix
route.group_name_prefix("admin.", [
  [
    route.get("/users", users_controller.index)
      |> route.name("users.index"),  // Full name: "admin.users.index"
  ],
])
```

### API Routes

API routes automatically return JSON error responses:

```gleam
// src/routes/api.gleam
import config/config_api

pub fn routes() -> List(List(route.Route(ctx.Context))) {
  [
    route.group_path_prefix(config_api.route_prefix(), [
      [
        route.get("/users", api_users_controller.index),
        route.post("/users", api_users_controller.store),
      ],
    ]),
  ]
}
```

API routes are automatically prefixed with `/api` and return JSON errors (404, 500, etc.) instead of HTML.

### Configuration

Access configuration values anywhere in your application:

```gleam
import config/config_app

pub fn show(req: route.RouteRequest, ctx: ctx.Context) -> wisp.Response {
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
pub fn show(req: route.RouteRequest, ctx: ctx.Context) -> wisp.Response {
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
