# Glimr ✨

A batteries-included web framework for Gleam that brings functional programming elegance and developer productivity to web development.

If you'd like to stay updated on Glimr's development, Follow [@migueljarias](https://x.com/migueljarias) on X (that's me) for updates.

## Table of Contents

- [About Glimr](#about-glimr)
- [Features](#features)
- [Installation](#installation)
- [Project Structure](#project-structure)
- [Routes](#defining-routes)
    - [Route Groups](#route-groups)
    - [API Routes](#api-routes)
- [Controllers](#creating-controllers)
- [Actions](#creating-actions)
- [Middleware](#middleware)
- [Form Validation](#form-validation)
- [Views & Responses](#views--responses)
- [Database](#database)
  - [Setup](#setup)
      - [SQLite](#sqlite)
      - [PostgreSQL](#postgresql)
      - [Multiple Databases](#multiple-database-connections)
  - [Migrations](#migrations)
  - [Queries](#queries)
- [Console Commands](#console-commands)
  - [Creating Commands](#creating-commands)
  - [Commands with Database Access](#commands-with-database-access)
  - [Third-Party Commands](#third-party-commands)
- [Configuration](#configuration)
- [Context System](#context-system)
- [Development](#development)
- [Learn More](#learn-more)
- [Contributing](#contributing)
- [License](#license)

## About Glimr

Glimr is a fully featured web framework built for Gleam. It provides a delightful developer experience with type-safe routing, middleware, singletons, and more - all leveraging Gleam's functional programming paradigm.

> **Note:** This repository contains the Glimr application template. If you want to contribute to the core framework, visit the [framework repository](https://github.com/glimr-org/framework).

## Features

- **Type Safe Routing** - Pattern matching routes with compile-time type safety
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
- **Automatic Migrations** - Schema-based migration generation with snapshot diffing
- **SQL Queries** - Write raw SQL files with full editor LSP support, compiled to typed Gleam functions
- **Connection Pooling** - Efficient database connection management for PostgreSQL and SQLite
- **Transaction Support** - Atomic operations with automatic retry on deadlock
- **Console Commands** - CLI task runner with database access support and argument parsing

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
│   ├── glimr_app.gleam               # Application entry point
│   ├── app/
│   │   ├── actions/                  # Modules for reusable business logic
│   │   ├── http/
│   │   │   ├── controllers/          # Request handlers
│   │   │   ├── middleware/           # Custom middleware
│   │   │   ├── requests/             # Typed request validation
│   │   │   ├── rules/                # Custom validation rules
│   │   │   ├── context/              # Application context
│   │   │   └── kernel.gleam          # HTTP middleware configuration
│   │   └── providers/                # Service providers
│   │       ├── ctx_provider.gleam    # Context registration
│   │       └── route_provider.gleam  # Route group registration
│   ├── bootstrap/
│   │   └── app.gleam                 # Application bootstrapping
│   ├── config/                       # Configuration files
│   ├── routes/
│   │   ├── web.gleam                 # Web routes
│   │   └── api.gleam                 # API routes
│   └── static/                       # Static assets
├── test/                             # Test files
├── .env                              # Environment variables
└── gleam.toml                        # Project configuration
```

## Routes

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
        _ -> wisp.method_not_allowed([Get])
      }

    // equivalent to "/users"
    ["users"] ->
      case method {
        Get -> user_controller.index(req, ctx)
        Post -> user_controller.store(req, ctx)
        _ -> wisp.method_not_allowed([Get, Post])
      }

    // equivalent to "/users/:user_id"
    ["users", user_id] ->
      case method {
        Get -> user_controller.show(user_id, req, ctx)
        _ -> wisp.method_not_allowed([Get])
      }

    _ -> wisp.not_found()
  }
}
```

**How it works:**
- Pattern match on `path` (list of URL segments)
- Pattern match on `method` to handle different HTTP methods
- Type-safe parameter extraction from the path

### Route Redirects

Define redirects directly in your routes:

```gleam
["old-contact"] -> wisp.redirect("/contact")
```

### Route Parameters

Parameters are extracted directly via pattern matching:

```gleam
// Route definition with type-safe parameter extraction
pub fn routes(path, method, req, ctx) {
  case path {
    ["posts", slug, "comments", comment_id] ->
      case method {
        Get -> comment_controller.show(req, ctx, slug, comment_id)
        ...
      }

    ...
  }
}

// Controller receives parameters directly
pub fn show(req: Request, ctx: Context, slug: String, comment_id: String) -> Response {
  // Use slug and comment_id...
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

## Controllers

Create controllers in `src/app/http/controllers/`. Use the following command:

```bash
./glimr make:controller user
```

This creates `user_controller.gleam`. In it you can add your custom logic.

```gleam
import app/http/context/ctx.{type Context}
import glimr/response/view
import glimr/response/redirect
import wisp.{type Request, type Response}

pub fn show(req: Request, ctx: Context) -> Response {
  view.build()
  |> view.html("users/show.html")
  |> view.render()
}

pub fn store(req: Request, ctx: Context) -> Response {
  // Handle POST request...

  redirect.build()
  |> redirect.back(req)
  |> redirect.flash([#("message", "User created!")])
  |> redirect.go()
}
```

You can also create resource controllers that come set up with index,show,edit,update,delete functions with this command:

```bash
./glimr make:controller --resource
```

## Actions

Actions help keep controllers clean by extracting complex business logic into reusable modules that can be used in controllers, and console commands. They encapsulate database operations and can return `Result` types for clean error handling on the controller's or command's side.

Create actions in `src/app/actions/`. Use the following command:

```bash
./glimr make:action update_submission
```

This creates `update_submission.gleam`. Actions follow a simple pattern - they perform work and return a Result. If you're going to perform database work within your action, it's preferable to accept a `Pool` rather than an entire `Context`, so that this action may be usable from console commands as well:

```gleam
// src/app/actions/update_submission.gleam
import app/http/requests/contact_store_request.{type Data}
import data/models/submission/gen/submission_repository.{type CreateRow}
import glimr/db/pool_connection.{type DbError}
import glimr/utils/unix_timestamp
import glimr/db/pool.{type Pool}

pub fn run(pool: Pool, id: Int, data: Data) -> Result(CreateRow, DbError) {
  let now = unix_timestamp.now()

  submission_repository.update(
    pool: pool,
    id: id,
    name: data.name,
    email: data.email,
    message: data.message,
    created_at: now,
    updated_at: now,
  )
}
```

Use actions in controllers with `case` for error handling:

```gleam
// src/app/http/controllers/contact_controller.gleam
import app/http/actions/create_submission
import app/http/requests/contact_store_request
import glimr/db/pool_connection.{NotFound}

pub fn update(req: Request, ctx: Context, submission_id: String) -> Response {
  use validated <- contact_store_request.validate(req, ctx)
  let assert Ok(submission_id) = int.parse(submission_id)

  case update_submission.run(ctx.db.pool, submission_id, validated) {
    Ok(submission) -> {
      redirect.build()
      |> redirect.to("/contact/updated")
      |> redirect.flash([#("message", "Thanks " <> submission.name <> "!")])
      |> redirect.go()
    }
    Error(NotFound) -> wisp.not_found()
    Error(_) -> wisp.internal_server_error()
  }
}
```

### Chaining Multiple Actions

Actions can be composed using `result.try` for sequential operations:

```gleam
import gleam/result

pub fn store(req: Request, ctx: Context) -> Response {
  use validated <- user_store_request.validate(req, ctx)

  case {
    use user <- result.try(create_user.run(ctx.db.pool, validated))
    use _ <- result.try(send_welcome_email.run(ctx.notif, user))
    use _ <- result.try(notify_admin.run(ctx.notif, user))
    Ok(user)
  } {
    Ok(user) -> {
      redirect.build()
      |> redirect.to("/users/" <> int.to_string(user.id))
      |> redirect.go()
    }
    Error(_) -> wisp.internal_server_error()
  }
}
```

## Middleware

Middleware intercepts requests before they reach your controllers. Middleware can modify both the request and context, with changes flowing through to subsequent middleware and controllers.

### Creating Middleware

Create custom middleware in `src/app/http/middleware/`. Use the following command:

```bash
./glimr make:middleware logger
```

This creates `logger.gleam`. In it you can add your custom logic.

```gleam
// app/http/middleware/logger.gleam
import wisp
import glimr/http/kernel.{type Next}

pub fn handle(req: Request, ctx: Context, next: Next(Context)) -> Response {
  io.println("Request received")

  // Pass both request and context to next middleware/handler
  next(req, ctx)
}
```

### Applying Middleware to Route Handlers

Apply middleware to specific controller functions:

```gleam
import app/http/middleware/logger.{handle as logger}
import app/http/middleware/auth.{handle as auth}
import glimr/http/middleware
...

pub fn show(req: Request, ctx: Context) -> Response {
  use req, ctx <- middleware.apply([auth, logger], req, ctx)

  // Continue with controller logic using the modified
  // req and ctx from your middleware stack
}
```

### Modifying Context in Middleware

Middleware can modify the context, and those changes are visible to downstream middleware and controllers:

```gleam
// middleware/auth.gleam
pub fn handle(req, ctx, next) {
  case authenticate(req) {
    Ok(user) -> {
      // Add authenticated user to context
      let updated_ctx = Context(..ctx, user: Some(user))
      next(req, updated_ctx)
    }
    Error(_) -> wisp.response(401)
  }
}
```

Then in your controller:

```gleam
pub fn dashboard(req: Request, ctx: Context) -> Response {
  // Apply the middleware to this controller function
  use _req, ctx <- middleware.apply([auth], req, ctx)

  // Safe to assert because auth middleware guarantees this
  let assert Some(user) = ctx.user

  view.build()
  |> view.html("dashboard.html")
  |> view.data([#("username", user.username)])
  |> view.render()
}
```

### Modifying Responses After Handler

Middleware can also modify responses on the way back up the chain:

```gleam
// middleware/cors.gleam
pub fn handle(req, ctx, next) {
  // Call the next middleware/handler first
  let response = next(req, ctx)

  // Modify the response on the way back
  response
  |> wisp.set_header("Access-Control-Allow-Origin", "*")
  |> wisp.set_header("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE")
}
```

This allows middleware to:
- Add headers to responses (CORS, security headers, etc.)
- Log response times
- Compress response bodies
- Transform response data

## Form Validation

Glimr provides a declarative, rule-based validation system for form data. Create form request modules to define validation rules and handle requests.

### Creating Form Requests

Create form request modules in `src/app/http/requests/`. Use the following command:

```bash
./glimr make:request user_store
```

This creates `user_store.gleam`. In it you can add your custom logic.

```gleam
// src/app/http/requests/user_store.gleam
import glimr/forms/validator.{Email, MaxLength, MinLength, Required, FileRequired}
import wisp.{type FormData, type UploadedFile}

// Define the shape of the data returned after validation
pub type Data {
  Data(name: String, email: String, avatar: UploadedFile)
}

// Define your form's validation rules
pub fn rules(form: FormData) {
  [
    validator.for(form, "name", [Required, MinLength(2)]),
    validator.for(form, "email", [Required, Email, MaxLength(255)]),
    validator.for_file(form, "avatar", [FileRequired, FileMaxSize(5000)]),
  ]
}

// Set the form data returned after validation
pub fn data(form: FormData) -> Data {
  Data(
    name: form.get(form, "name"),
    email: form.get(form, "email"),
    avatar: form.get_file(form, "avatar"),
  )
}

// Add "before" or "after" validation logic if necessary, here
pub fn validate(req: Request, ctx: Context, next: fn(Data) -> Response) {
  // Add before validation logic here...
  use validated <- validator.run(req, ctx, rules, data)
  // Add after validation logic here...

  next(validated)
}
```

### Using Validation in Controllers

Use the `use` syntax for clean, readable validation handling:

```gleam
import app/http/requests/user_store_request
import app/repositories/user_repository
import glimr/forms/validator

// app/http/controllers/user_controller.gleam
pub fn store(req: Request, ctx: Context) -> Response {
  // Form validation errors are handled automatically
  use validated <- user_store_request.validate(req, ctx)

  // Do something with your validated data
  let assert Ok(user) = user_repository.create(
    pool: ctx.db.pool,
    name: validated.name,
    email: validated.email,
    avatar: validated.avatar.path,
  )

  // Redirect back with success message
  redirect.build()
  |> redirect.back(req)
  |> redirect.flash([#("message", "User created successfully!")])
  |> redirect.go()
}
```

> **Note:** Flash messaging isn't supported yet, as session support hasn't been implemented.

If validation fails, a 422 response with validation errors is automatically returned.

> **Note:** Currently, validation errors just show up in a basic view. Eventually, web routes will redirect back with the errors, and API routes will return a 422 JSON response.

### Available Validation Rules

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

### Custom Validation Rules

Create your own validation rules for domain-specific logic using the `Custom` rule in `app/http/rules`. Use the following command:

```bash
./glimr make:rule no_gmail
```

Add your rule's validation logic:

```gleam
// app/http/rules/no_gmail.gleam
import app/http/context/ctx.{type Context}
import gleam/string

pub fn run(value: String, _ctx: Context) -> Result(Nil, String) {
  case string.contains(value, "gmail") {
    False -> Ok(Nil)
    True -> Error("cannot be a Gmail address")
  }
}
```

Use your custom rule in your request:

```gleam
// app/http/requests/login_request.gleam
import glimr/forms/validator.{Custom, MinLength, MaxLength, Required}
import app/http/rules/no_gmail.{run as username_available}

pub fn rules(form: FormData) {
  [
    validator.for(form, "email", [
      Required,
      MinLength(3),
      MaxLength(255),
      Custom(no_gmail), // <----- custom rule!
    ]),

    validator.for(form, "password", [Required]),
  ]
}

```

**Custom validation function structure:**
- Take a `String` value as input
- Return `Ok(Nil)` if validation passes
- Return `Error(message)` with an error message if validation fails

### Custom File Validation Rules

Create your own validation rules for domain-specific logic using the `FileCustom` rule in `app/http/rules`. Use the following command:

```bash
./glimr make:rule image_dimensions --file
```

Add your rule's validation logic:

```gleam
// app/http/rules/image_dimensions.gleam
import wisp.{type UploadedFile}

pub fn run(file: UploadedFile) -> Result(Nil, String) {
  case get_image_dimensions(file.path) {
    Ok(#(width, height)) if width >= 100 && height >= 100 -> Ok(Nil)
    Ok(_) -> Error("must be at least 100x100 pixels")
    Error(_) -> Error("could not read image dimensions")
  }
}
```

Use your custom rule in your request:

```gleam
// app/http/requests/avatar_upload.gleam
import glimr/forms/validator.{FileCustom, FileRequired, FileMaxSize}
import app/http/rules/image_dimensions.{run as image_dimensions}

pub fn rules(form: FormData) {
  [
    validator.for_file(form, "avatar", [
      FileRequired,
      FileMaxSize(2048),
      FileCustom(image_dimensions), // <-----
    ]),
  ]
}
```

**Custom file validation function structure:**
- Take an `UploadedFile` as input
- Return `Ok(Nil)` if validation passes
- Return `Error(message)` with an error message if validation fails

## Views & Responses

Glimr provides a fluent builder pattern for rendering views with layouts and template variables.

### Rendering Views

```gleam
import glimr/response/view

pub fn show(req: Request, ctx: Context) -> Response {
  view.build()
  |> view.html("welcome.html")
  |> view.data([#("title", "Welcome")])
  |> view.render()
}
```

### Rendering Lustre Components

Glimr seamlessly integrates with [Lustre](https://hexdocs.pm/lustre/) for server-side rendering:

```gleam
import glimr/response/view
import resources/views/contact/contact_form

pub fn show(req: Request, ctx: Context) -> Response {
  let model = contact_form.init(Nil)

  view.build()
  |> view.lustre(contact_form.view(model))
  |> view.data([#("title", "Contact Us")])
  |> view.render()
}
```

### Set Layout

Set a layout for a specific view:

```gleam
view.build()
|> view.html("dashboard.html")
// Layouts are set in src/resources/views/layouts/*
|> view.layout("admin.html")
|> view.data([#("title", "Admin Dashboard")])
|> view.render()
```

### Template Variables

Views use `{{ variable }}` syntax for template substitution. The special `{{ _content_ }}` variable is reserved for the main content:

```html
<!-- layouts/app.html -->
<!DOCTYPE html>
<html>
  <head>
    <title>{{ title }} - {{ app_name }}</title>
  </head>
  <body>
    {{ _content_ }}
  </body>
</html>
```

## Redirects

Glimr's redirect builder provides a clean API for redirecting users with flash messages.

### Basic Redirects

```gleam
import glimr/response/redirect

pub fn store(req: Request, ctx: Context) -> wisp.Response {
  // Process form...

  redirect.build()
  |> redirect.to("/contact/success")
  |> redirect.go()
}
```

### Redirects with Flash Messages

Flash messages persist data across redirects (requires session support):

```gleam
pub fn store(req: Request, ctx: Context) -> Response {
  // Process form...

  redirect.build()
  |> redirect.to("/dashboard")
  |> redirect.flash([#("success", "Contact form submitted!")])
  |> redirect.go()
}
```

> **Note:** Flash messaging isn't supported yet, as session support hasn't been implemented.

### Redirect Back

Redirect users back to the previous page:

```gleam
pub fn cancel(req: Request, ctx: Context) -> Response {
  redirect.build()
  |> redirect.back(req)
  |> redirect.go()
}
```

## Database

Currently supports sqlite via the [glimr-org/sqlite](https://github.com/glimr-org/sqlite) package (built with `lpil/sqlight`) and postgres via the [glimr-org/postgres](https://github.com/glimr-org/postgres) package (built with `lpil/pog`).

### Setup

#### SQLite

Install the `glimr_sqlite` and `sqlight` packages:

```bash
gleam add sqlight glimr_sqlite
```

In your `config_db.gleam` file, set up an sqlite connection in the `connections()` list:

```gleam
import dot_env/env
import glimr/db/driver.{type Connection}

pub fn connections() -> List(Connection) {
  [
    driver.SqliteConnection(
      name: "main",
      database: env.get_string("DB_DATABASE"),
      pool_size: env.get_int("DB_POOL_SIZE"),
    ),
    // ...
  ]
}
```

Run the following command to create a directory for your new database connection. This will contain all migrations, queries, repositories, for this database. In our previous example we set the name to "main", so the command below would create `src/data/main/`. This also creates a database file in `src/data/main/data.db`.

```bash
./glimr setup:database main --sqlite
```

Update your .env variables:

```env
DB_DATABASE=src/data/main/data.db
DB_POOL_SIZE=15
```

Set up your connection in your `ctx_db.gleam`:

```gleam
import config/config_db
import glimr_sqlite/db/pool.{type Pool as SqlitePool}
import glimr_sqlite/sqlite

pub type DbContext {
  DbContext(
    main: SqlitePool, // <--- Add to context
    // ...
  )
}

pub fn load() -> DbContext {
  let connections = config_db.connections()

  DbContext(
    main: sqlite.start("main", connections), // <--- Load by name
    // ...
  )
}
```

And then finally, use `ctx.db.main` in your controllers:

```gleam
pub fn show(_req: Request, ctx: Context) -> Response {
  case user_repository.find(ctx.db.main, user_id) {
    Ok(user) -> {
      view.build()
      |> view.html("users/show.html")
      |> view.data([#("user", user.name)])
      |> view.render()
    }
    Error(NotFound) -> wisp.not_found()
    Error(_) -> wisp.internal_server_error()
}
```

You should also register the `glimr_sqlite` console commands in your `command_provider.gleam` file so you can access commands like `./glimr sqlite:migrate`:

```gleam
import app/console/kernel
import gleam/list
import glimr/console/command.{type Command}
import glimr_sqlite/console/kernel as kernel_sqlite

pub fn register() -> List(Command) {
  list.flatten([
    kernel.commands(),
    kernel_sqlite.commands(), // <--- Register sqlite commands
    // ...
  ])
}
```
 
##### SQLite with :memory:

For development or testing, you can use an in-memory SQLite database. Update your `.env` file:

```env
DB_DRIVER=sqlite
DB_DATABASE=":memory:"
DB_POOL_SIZE=1
```

**Important:** When using `:memory:`, set `DB_POOL_SIZE=1` because each SQLite connection to `:memory:` creates a separate in-memory database. With multiple connections, queries would hit different databases and not see each other's data.

For multiple connections to the same in-memory database, use a shared cache URI:

```env
DB_PATH="file::memory:?cache=shared"
```

#### PostgreSQL

Install the `glimr_postgres` and `pog` packages:

```bash
gleam add pog glimr_postgres
```

In your `config_db.gleam` file, set up a postgres connection in the `connections()` list:

```gleam
import dot_env/env
import glimr/db/driver.{type Connection}

pub fn connections() -> List(Connection) {
  [
    driver.PostgresConnection(
      name: "main",
      host: env.get_string("DB_HOST"),
      port: env.get_int("DB_PORT"),
      database: env.get_string("DB_DATABASE"),
      username: env.get_string("DB_USERNAME"),
      password: env.get_string("DB_PASSWORD"),
      pool_size: env.get_int("DB_POOL_SIZE"),
    )
    // ...
  ]
}
```

Update your .env variables:

```env
DB_HOST=[your_host]
DB_PORT=5432
DB_DATABASE=[your_database]
DB_USERNAME=[db_user]
DB_PASSWORD=[db_password]
DB_POOL_SIZE=15
```

If you'd rather use a `DB_URL` for your postgres connection, set up your `config_db.gleam` like this:

```gleam
import dot_env/env
import glimr/db/driver.{type Connection}

pub fn connections() -> List(Connection) {
  [
    driver.PostgresUriConnection(
      name: "main",
      url: env.get_string("DB_URL"),
      pool_size: env.get_int("DB_POOL_SIZE"),
    )
    // ...
  ]
}
```

Update your .env variables:

```env
DB_URL=postgres://user@host:port/db_name
DB_POOL_SIZE=15
```

Run the following command to create a directory for your new database connection. This will contain all migrations, queries, repositories, for this database. In our previous example we set the name to "main", so the command below would create `src/data/main/`.

```bash
./glimr setup:database main
```
Set up your connection in your `ctx_db.gleam`:

```gleam
import config/config_db
import glimr_postgres/db/pool.{type Pool as PostgresPool}
import glimr_postgres/postgres

pub type DbContext {
  DbContext(
    main: PostgresPool, // <--- Add to context
    // ...
  )
}

pub fn load() -> DbContext {
  let connections = config_db.connections()

  DbContext(
    main: postgres.start("main", connections), // <--- Load by name
    // ...
  )
}
```

And then finally, use `ctx.db.main` in your controllers:

```gleam
pub fn show(_req: Request, ctx: Context) -> Response {
  case user_repository.find(ctx.db.main, user_id) {
    Ok(user) -> {
      view.build()
      |> view.html("users/show.html")
      |> view.data([#("user", user.name)])
      |> view.render()
    }
    Error(NotFound) -> wisp.not_found()
    Error(_) -> wisp.internal_server_error()
}
```

You should also register the `glimr_postgres` console commands in your `command_provider.gleam` file so you can access commands like `./glimr postgres:migrate`:

```gleam
import app/console/kernel
import gleam/list
import glimr/console/command.{type Command}
import glimr_postgres/console/kernel as kernel_postgres

pub fn register() -> List(Command) {
  list.flatten([
    kernel.commands(),
    kernel_postgres.commands(), // <--- Register postgres commands
    // ...
  ])
}
```

### Multiple Database Connections

Glimr supports multiple database connections at the same time, even with different drivers! Just add them to the `connections()` list in `config_db.gleam`:

```gleam
import dot_env/env
import glimr/db/driver.{type Connection}

pub fn connections() -> List(Connection) {
  [
    driver.PostgresUriConnection(
      name: "main",
      url: env.get_string("DB_URL"),
      pool_size: env.get_int("DB_POOL_SIZE"),
    ),
    driver.SqliteConnection(
      name: "analytics",
      database: env.get_string("DB_ANALYTICS_DATABASE"),
      pool_size: env.get_int("DB_ANALYTICS_POOL_SIZE"),
    )
    // ...
  ]
}
```

You can then set up these connections in your `ctx_db.gleam`:

```gleam
import config/config_db
import glimr_sqlite/db/pool.{type Pool as SqlitePool}
import glimr_postgres/db/pool.{type Pool as PostgresPool}
import glimr_sqlite/sqlite
import glimr_postgres/postgres

pub type DbContext {
  DbContext(
    main: PostgresPool,
    analytics: SqlitePool,
    // ...
  )
}

pub fn load() -> DbContext {
  let connections = config_db.connections()

  DbContext(
    main: postgres.start("main", connections),
    analytics: sqlite.start("analytics", connections),
    // ...
  )
}
```

And use them like so:

```gleam
// your "main" postgres connection pool
ctx.db.main 

// your "analytics" sqlite connection pool
ctx.db.analytics 
```

### Migrations

Glimr provides automatic migration generation by comparing your schema definitions against a stored snapshot. It detects changes and generates driver-specific SQL for PostgreSQL or SQLite.

#### Defining Schemas

Start by creating a data model using the following command:

```bash
./glimr make:model user
```

This creates a `user/` folder inside your default database directory `src/data/main/models/`. The folder contains `user_schema.gleam` for defining your table schema, and a `queries/` folder with pre-generated CRUD queries that get compiled into fully typed gleam code. You can add custom queries to this folder as well (see [Queries](#queries) section).

The `make:model` command defines your default connection as the very first one in your `connections()` list in `config_db.gleam`. All other commands that accept the `--database` flag define it as the first of it's driver type instead.

If you need to specify the connection folder you can always pass a `--database` flag:

```bash
./glimr make:model user --database=analytics
```

This creates a `user/` folder inside `src/data/analytics/models/`.

Define the user schema for your migrations:

```gleam
// src/data/models/user/user_schema.gleam
import glimr/db/schema.{
  table, id, string, text, boolean, uuid, foreign,
  nullable, default_bool, default_string, auto_uuid, unix_timestamps,
}

pub const name = "users"

pub fn define() {
  table(name, [
    id(),
    foreign("organization_id", "organizations") |> nullable(),
    string("email"),
    string("name"),
    text("bio") |> nullable(),
    boolean("is_admin") |> default_bool(False),
    string("role") |> default_string("user"),
    unix_timestamps(),
  ])
}
```

#### Available Column Types

| Function | PostgreSQL | SQLite | Gleam Type |
|----------|------------|--------|------------|
| `id()` | `SERIAL PRIMARY KEY` | `INTEGER PRIMARY KEY AUTOINCREMENT` | `Int` |
| `uuid("name")` | `UUID` | `TEXT` | `String` |
| `string("name")` | `VARCHAR(255)` | `TEXT` | `String` |
| `string_sized("name", 100)` | `VARCHAR(100)` | `TEXT` | `String` |
| `text("name")` | `TEXT` | `TEXT` | `String` |
| `int("name")` | `INTEGER` | `INTEGER` | `Int` |
| `bigint("name")` | `BIGINT` | `INTEGER` | `Int` |
| `float("name")` | `DOUBLE PRECISION` | `REAL` | `Float` |
| `boolean("name")` | `BOOLEAN` | `INTEGER` | `Bool` |
| `timestamp("name")` | `TIMESTAMP` | `TEXT` | `String` |
| `unix_timestamp("name")` | `BIGINT` | `INTEGER` | `Int` |
| `date("name")` | `DATE` | `TEXT` | `String` |
| `json("name")` | `JSONB` | `TEXT` | `String` |
| `foreign("user_id", "users")` | `INTEGER REFERENCES users(id)` | `INTEGER` | `Int` |
| `timestamps()` | Creates `created_at` and `updated_at` | | |
| `unix_timestamps()` | Creates `created_at` and `updated_at` as integers | | |

#### Column Modifiers

```gleam
// Make a column nullable (default is NOT NULL)
string("bio") |> nullable()

// Set default values
boolean("active") |> default_bool(True)
string("role") |> default_string("user")
int("count") |> default_int(0)
float("rate") |> default_float(0.0)
timestamp("published_at") |> default_now()
unix_timestamp("created_at") |> default_unix_now()
uuid("external_id") |> auto_uuid()
string("deleted_at") |> nullable() |> default_null()
```

#### Generating Migrations

Run the migration generator for the specific driver:

```bash
# for your default sqlite connection
./glimr sqlite:gen

# for a named sqlite connection
./glimr sqlite:gen --database=analytics

# for your default postgres connection
./glimr postgres:gen

# for a named postgres connection
./glimr postgres:gen --database=analytics
```

> **Note:** The default connection for a specific driver is the very first one of its kind defined in your `connections()` list in `config_db.gleam`.

This will:
1. Scan schema files in `src/data/{connection_name}/models/`
2. Compare against the stored snapshot (`._schema_snapshot.json`)
3. Detect changes (new tables, dropped tables, column changes)
4. Generate SQL in `src/data/{connection_name}/_migrations/{timestamp}_migration.sql`
5. Update the snapshot for the next run

You can also run the following command to generate migrations and also run them:

```bash
# for your default sqlite connection
./glimr sqlite:gen --migrate

# for a named sqlite connection
./glimr sqlite:gen --database=analytics --migrate

# for your default postgres connection
./glimr postgres:gen --migrate

# for a named postgres connection
./glimr postgres:gen --database=analytics --migrate
```

Additionally, you can generate migrations/queries for a specific model or multiple models by passing the `--model` flag: 

```bash
# for your default sqlite connection
./glimr sqlite:gen --model=user,post

# for a named sqlite connection
./glimr sqlite:gen --database=analytics --model=user,post

# for your default postgres connection
./glimr postgres:gen --model=user,post

# for a named postgres connection
./glimr postgres:gen --database=analytics --model=user,post
```

#### Renaming Columns

To rename a column without losing data, use the `schema.rename_from` modifier:

```gleam
string("email_address") |> schema.rename_from("email")
```

This generates `ALTER TABLE ... RENAME COLUMN` instead of drop/add. The `schema.rename_from` modifier is automatically removed from your schema file after the migration is generated.

#### Running Migrations

Generated migrations are plain SQL files. Run them with the following command:

```bash
# for your default sqlite connection
./glimr sqlite:migrate

# for a named sqlite connection
./glimr sqlite:migrate --database=analytics

# for your default postgres connection
./glimr postgres:migrate

# for a named postgres connection
./glimr postgres:migrate --database=analytics
```

#### Rolling Back Migrations

Glimr takes a forward-only approach to migrations. Instead of rollbacks, simply generate a new migration to reverse any changes. This keeps your migration history explicit and auditable.

#### Dropping Tables

To drop a database table, simply delete the model from the `src/data/{connection}/models/` folder. For example, if your model is called `user` in your main connection, delete the `src/data/main/models/user/` folder. Finally, regenerate migrations and rerun them.

### Queries

Each model includes a `queries/` folder with pre-generated CRUD queries. These are plain SQL files, so you get full SQL language support, autocomplete, and linting from your editor's SQL LSP.

#### Generated CRUD Queries

When you create a model with the `./glimr make:model` command, the following query files are generated for you:

```
src/data/models/user/queries/
├── create.sql
├── delete.sql
├── find.sql
├── list_all.sql
└── update.sql
```

You can modify these queries to fit your needs or delete any you don't need.

#### Creating Custom Queries

Add new `.sql` files to the `queries/` folder for custom queries:

```sql
-- src/data/models/user/queries/find_by_email.sql
SELECT * FROM users WHERE email = $1;
```

```sql
-- src/data/models/user/queries/list_active.sql
SELECT * FROM users WHERE is_active = true ORDER BY created_at DESC;
```

#### Query Naming Convention

The file name prefix determines whether the query returns a single row or multiple rows:

| Prefix | Returns | Gleam Return Type |
|--------|---------|-------------------|
| `list_*` | Multiple rows | `List(User)` |
| Anything else | Single row | `Result(User, Nil)` |

**Examples:**
- `find.sql` → returns `Result(User, Nil)`
- `find_by_email.sql` → returns `Result(User, Nil)`
- `list_all.sql` → returns `List(User)`
- `list_active.sql` → returns `List(User)`
- `list_by_role.sql` → returns `List(User)`

#### Generating the Repository

After adding or modifying queries, run:

```bash
# for your default sqlite connection
./glimr sqlite:gen

# for a named sqlite connection
./glimr sqlite:gen --database=analytics

# for your default postgres connection
./glimr postgres:gen

# for a named postgres connection
./glimr postgres:gen --database=analytics
```



This generates a fully-typed repository file with Gleam functions for each query. Every query generates **two functions**:

| Function | Accepts | Use Case |
|----------|---------|----------|
| `find(pool, id)` | Pool | Normal queries - auto-manages connection |
| `find_wc(conn, id)` | Connection | Transactions - uses existing connection |

```gleam
// src/data/models/user/user_repository.gleam (auto-generated)

// Main functions - accept Pool, auto checkout/checkin connection
pub fn find(pool, id) -> Result(User, DbError)
pub fn find_by_email(pool, email) -> Result(User, DbError)
pub fn list_all(pool) -> Result(List(User), DbError)
pub fn list_active(pool) -> Result(List(User), DbError)

// With-connection variants - for use inside transactions
pub fn find_wc(conn, id) -> Result(User, DbError)
pub fn find_by_email_wc(conn, email) -> Result(User, DbError)
pub fn list_all_wc(conn) -> Result(List(User), DbError)
pub fn list_active_wc(conn) -> Result(List(User), DbError)
```

#### Connection Pooling

Glimr manages a pool of database connections to efficiently handle concurrent requests. The pool is initialized in your context in `ctx_provider.gleam`.

You can specify the pool size by setting the `DB_POOL_SIZE` env variable, and the config value for your connection in `config_db.gleam`. It defaults to 15.

**How it works:**

When you call a query function like `user_repository.find(ctx.db.pool, id)`, it automatically:
1. Checks out a connection from the pool
2. Executes the query
3. Returns the connection to the pool
4. Returns the result

This means each query holds a connection only for the duration of the query itself, maximizing pool efficiency.

#### Using Queries in Controllers

Query functions return `Result` types, giving you full control over error handling:

```gleam
import data/models/user/user_repository
import glimr/db/pool_connection.{NotFound}

pub fn show(id: String, req: Request, ctx: Context) -> Response {
  let assert Ok(user_id) = int.parse(id)

  case user_repository.find(ctx.db.pool, user_id) {
    Ok(user) -> {
      view.build()
      |> view.html("users/show.html")
      |> view.data([#("user", user.name)])
      |> view.render()
    }
    Error(NotFound) -> wisp.not_found()
    Error(_) -> wisp.internal_server_error()
  }
}
```

**List queries:**

```gleam
import data/models/user/user_repository

pub fn index(req: Request, ctx: Context) -> Response {
  case user_repository.list_all(ctx.db.pool) {
    Ok(users) -> {
      view.build()
      |> view.html("users/index.html")
      |> view.data([#("count", int.to_string(list.length(users)))])
      |> view.render()
    }
    Error(_) -> wisp.internal_server_error()
  }
}
```

In situations where you'd rather not handle error handling yourself, you can just `let assert Ok()`. This will display a 500 error page if an error occurs. Note, 404 errors won't be properly handled this way. Only do this if a 404 error isn't possible, like in a `create`, or `list_all` for example.

```gleam
import data/models/user/user_repository

pub fn index(req: Request, ctx: Context) -> Response {
  let assert Ok(user) = user_repository.list_all(ctx.db.pool)

  view.build()
  |> view.html("users/index.html")
  |> view.data([#("count", int.to_string(list.length(users)))])
  |> view.render()
}
```

#### Database Transactions

For operations that must succeed or fail together, use transactions. They automatically:
- Check out a connection from the pool
- Begin a transaction
- Commit on success or roll back on error
- Return the connection to the pool
- Retry on deadlock (with configurable retry count)

Transactions are provided by the driver packages (`glimr_sqlite` or `glimr_postgres`):

```gleam
// For SQLite
import glimr_sqlite/db/db
import glimr/db/pool_connection.{type DbError}

// For PostgreSQL
// import glimr_postgres/db/db

pub fn transfer(
  ctx: Context,
  from_id: Int,
  to_id: Int,
  amount: Int,
) -> Result(Nil, DbError) {
  use conn <- db.transaction(ctx.db.pool, 3)

  // Both operations use the same connection within the transaction
  use _ <- result.try(account_repository.debit_wc(conn, from_id, amount))
  use _ <- result.try(account_repository.credit_wc(conn, to_id, amount))
  Ok(Nil)
}
```

The second parameter is the retry count for deadlocks:
- `0` = no retries (try once, fail immediately on error)
- `3` = retry up to 3 times on deadlock (4 total attempts)

Retries use exponential backoff to reduce contention.

**Using transactions in controllers:**

```gleam
// Use the appropriate driver package
import glimr_sqlite/db/db       // for SQLite
// import glimr_postgres/db/db  // for PostgreSQL

pub fn store(req: Request, ctx: Context) -> Response {
  use validated <- transfer_request.validate(req, ctx)

  case {
    use conn <- db.transaction(ctx.db.pool, 3)
    use _ <- result.try(account_repository.debit_wc(conn, validated.from_id, validated.amount))
    use _ <- result.try(account_repository.credit_wc(conn, validated.to_id, validated.amount))
    Ok(Nil)
  } {
    Ok(_) -> {
      redirect.build()
      |> redirect.to("/transfers/success")
      |> redirect.go()
    }
    Error(_) -> {
      redirect.build()
      |> redirect.to("/transfers")
      |> redirect.flash([#("error", "Transfer failed")])
      |> redirect.go()
    }
  }
}
```

> **Note:** Use the `_wc` (with connection) variants of repository functions inside transactions. These accept a `Connection` instead of a `Pool`, allowing all operations to share the same transactional connection.

## Console Commands

Glimr provides a console command system (Similar to Laravel's artisan) for running tasks from the command line. Commands are defined using a fluent API and can optionally receive database access.

### Creating Commands

Create a new command using the following command:

```bash
./glimr make:command send_emails
```

This creates `src/app/console/commands/send_emails.gleam`:

```gleam
import glimr/console/command.{type Command, type ParsedArgs}

const name = "app:send-emails"

const description = "Command description"

pub fn command() -> Command {
  command.new()
  |> command.name(name)
  |> command.description(description)
  |> command.handler(run)
}

fn run(args: ParsedArgs) -> Nil {
  // Your command logic here
  todo
}
```

### Adding Arguments, Flags, and Options

Commands can accept three types of inputs:

- **Arguments** - Required positional values
- **Flags** - Optional boolean switches (e.g., `--verbose` or `-v`)
- **Options** - Optional values (e.g., `--format=json` or `-f=json`)

```gleam
import gleam/result
import glimr/console/command.{type Command, type ParsedArgs, Argument, Flag, Option}

pub fn command() -> Command {
  command.new()
  |> command.name("app:send-emails")
  |> command.description("Send emails to users")
  |> command.args([
    Argument(name: "recipient", description: "The email recipient"),
    Flag(name: "dry-run", short: "d", description: "Preview without sending"),
    Option(name: "format", description: "Output format", default: "text"),
  ])
  |> command.handler(run)
}

fn run(args: ParsedArgs) -> Nil {
  let recipient = command.get_arg(args, "recipient")
  let dry_run = command.has_flag(args, "dry-run")
  let format = command.get_option(args, "format")

  // Use recipient, dry_run, and format...
}
```

### Register Your Command

You can register your commands in `src/app/console/kernel.gleam`:

```gleam
import glimr/console/command.{type Command}
import app/console/commands/send_emails

pub fn commands() -> List(Command) {
  [
    send_emails.command(),
    // Add more commands here...
  ]
}
```

### Run Your Command

You can now run your newly created command the same way you run Glimr commands:

```bash
./glimr app:send-emails
```

Your command will also appear in the command list when running:

```bash
./glimr
```

Just like with Glimr commands, you'll automatically be able to get help output for your custom commands by running:

```bash
./glimr app:send-emails --help
```

Run with arguments:

```bash
./glimr app:send-emails user@example.com --dry-run --format=json
```

### Commands with Database Access

For commands that need database access, use the `--sqlite` or `--postgres` flag:

```bash
./glimr make:command seed_database --sqlite
```

This creates a command with a `Pool` parameter for the driver type passed:

```gleam
import glimr_sqlite/db/pool.{type Pool}
import glimr/console/command.{type Command, type ParsedArgs}
import glimr_sqlite/console/command as command_sqlite // <--- import command module from glimr_sqlite

const name = "app:seed-database"

const description = "Seed the database with initial data"

pub fn command() -> Command {
  command.new()
  |> command.name(name)
  |> command.description(description)
  |> command_sqlite.handler(run) // <--- uses command_sqlite rather than command for the handler
}

fn run(args: ParsedArgs, pool: Pool) -> Nil { // <--- run() now accepts a Pool parameter
  // Use the pool for database operations
  let assert Ok(_) = user_repository.create(
    pool: pool,
    name: "Admin",
    email: "admin@example.com",
  )
}
```

The framework automatically:
1. Starts a database pool with 1 connection before your command runs
2. Passes the pool to your handler
3. Stops the pool when your command completes

### Multiple Database Connections

All commands that need a database connection automatically accept a `--database` option for you to pass the name of the database connection you need access to specified in your `config_db.gleam`. 

If a database connection isn't specified, it will to default to the first connection of it's type in the `connections()` list in `config_db.gleam`.

```bash
# Uses the default connection
./glimr app:seed-database

# Uses a specific connection
./glimr app:seed-database --database=analytics
```

The `--database` name's existence is automatically verified before attempting to create a connection.

### Third-Party Commands

Register third-party package commands in `src/app/providers/command_provider.gleam`:

```gleam
import app/console/kernel
import gleam/list
import glimr/console/command.{type Command}
import glimr/console/kernel as glimr_kernel
// Import third-party commands
import some_package/commands as package_commands

pub fn register() -> List(Command) {
  list.flatten([
    kernel.commands(),
    glimr_kernel.commands(),
    package_commands.commands(),  // Third-party commands
  ])
}
```

This allows third party packages to provide commands for your app in the same way Glimr does, providing a seamless and unified experience.

## Configuration

Access configuration values anywhere in your application:

```gleam
import config/config_app

pub fn show(req: Request, ctx: Context) -> Response {
  let app_name = config_app.name()
  let app_url = config_app.url()
  let debug_mode = config_app.debug()

  // Use configuration...
}
```

Add your own configuration files in `src/config/`.

## Context System

The context system provides type-safe dependency injection. Define your context in `src/app/http/context/`:

```gleam
// src/app/http/context/ctx.gleam
pub type Context {
  Context(
    app: Context,
    // Add your own contexts here
    // database: DatabaseContext,
    // cache: CacheContext,
  )
}
```

Register contexts in the provider:

```gleam
// src/app/providers/ctx_provider.gleam
pub fn register() -> Context {
  ctx.Context(
    app: ctx.load(),
    // Initialize your contexts here
  )
}
```

Access context in controllers:

```gleam
pub fn show(req: Request, ctx: Context) -> Response {
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
- [Wisp Documentation](https://hexdocs.pm/wisp/) - Web framework library

### Built With

Glimr is built on top of these excellent Gleam packages:

- [**wisp**](https://hexdocs.pm/wisp/) - The web framework that powers Glimr's HTTP handling
- [**gleam_http**](https://hexdocs.pm/gleam_http/) - HTTP types and utilities
- [**gleam_json**](https://hexdocs.pm/gleam_json/) - JSON encoding and decoding
- [**gleam_stdlib**](https://hexdocs.pm/gleam_stdlib/) - Gleam's standard library
- [**gleam_time**](https://github.com/gleam-lang/time) - Work with time in Gleam!
- [**simplifile**](https://github.com/bcpeinhardt/simplifile) - Simple file operations for Gleam
- [**dot_env**](https://github.com/aosasona/dotenv) - Load environment variables from .env

Special thanks to the Gleam community for building such an awesome ecosystem!

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

The Glimr framework is open-sourced software licensed under the [MIT](https://opensource.org/license/MIT) license.

## Credits

Glimr is inspired by [Laravel](https://laravel.com/) and adapted for Gleam's functional programming paradigm.
