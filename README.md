# Glimr ✨

A batteries-included web framework for Gleam that brings functional programming elegance and developer productivity to web development.

Website: [glimr.build](https://glimr.build)

If you'd like to stay updated on Glimr's development, Follow [@migueljarias](https://x.com/migueljarias) on X (that's me) for updates.

## Table of Contents

- [About Glimr](#about-glimr)
- [Features](#features)
- [Installation](#installation)
- [Project Structure](#project-structure)
- [Build Tools](#build-tools)
    - [Vite & Tailwind](#vite--tailwind)
    - [Build Command](#build-command)
    - [Run Command](#run-command)
    - [Hooks](#hooks)
    - [Glimr Commands](#glimr-commands)
- [Routes](#routes)
    - [Defining Routes](#defining-routes)
    - [Route Parameters](#route-parameters)
    - [Redirects](#redirects)
    - [Route Middleware](#route-middleware)
    - [Group Middleware](#group-middleware)
    - [Validators](#validators)
    - [Route Groups](#route-groups)
    - [Direct Pattern Matching](#direct-pattern-matching)
- [Controllers](#controllers)
- [Actions](#actions)
- [Middleware](#middleware)
- [Session](#session)
  - [Configuration](#session-configuration)
  - [Choosing a Driver](#choosing-a-driver)
    - [PostgreSQL Driver](#postgresql-driver)
    - [SQLite Driver](#sqlite-driver)
    - [Redis Driver](#redis-driver)
    - [File Driver](#file-driver)
    - [Cookie Driver](#cookie-driver)
  - [Kernel Middleware](#kernel-middleware)
  - [Session API](#session-api)
  - [Flash Messages](#flash-messages)
  - [Session Invalidation & Regeneration](#session-invalidation--regeneration)
- [Authentication](#authentication)
  - [Generating Auth Scaffolding](#generating-auth-scaffolding)
  - [Scoped Mode](#scoped-mode)
  - [Multiple Auth Models](#multiple-auth-models)
  - [Authenticatable Schema](#authenticatable-schema)
  - [Generated Controllers](#generated-controllers)
  - [Auth & Guest Middleware](#auth--guest-middleware)
  - [Auth Functions](#auth-functions)
- [Form Validation](#form-validation)
- [Views & Responses](#views--responses)
- [Error Pages](#error-pages)
- [Loom Template Engine](#loom-template-engine)
- [Database](#database)
  - [Setup](#setup)
      - [SQLite](#sqlite)
      - [PostgreSQL](#postgresql)
      - [Multiple Databases](#multiple-database-connections)
  - [Migrations](#migrations)
  - [Queries](#queries)
- [Cache](#cache)
  - [Store Types](#store-types)
  - [File Store](#file-store)
  - [Redis Store](#redis-store)
  - [Database Store (SQLite)](#database-store-sqlite)
  - [Database Store (PostgreSQL)](#database-store-postgresql)
  - [Using the Cache](#using-the-cache)
  - [Cache Operations](#cache-operations)
- [Console Commands](#console-commands)
  - [Creating Commands](#creating-commands)
  - [Commands with Database Access](#commands-with-database-access)
  - [Commands with Cache Access](#commands-with-cache-access)
  - [Third-Party Commands](#third-party-commands)
  - [Console Output](#console-output)
- [Configuration](#configuration)
- [Context System](#context-system)
- [Learn More](#learn-more)
- [Contributing](#contributing)
- [License](#license)

## About Glimr

Glimr is a fully featured web framework built for Gleam. It provides a delightful developer experience with type-safe routing, middleware, singletons, and more - all leveraging Gleam's functional programming paradigm.

> **Note:** This repository contains the Glimr application template. If you want to contribute to the core framework, visit the [framework repository](https://github.com/glimr-org/framework).

## Features

- **Type Safe Routing** - Generated pattern matching routes with compile-time type safety
- **Loom Template Engine** - Blade-inspired templates with components, slots, and conditionals
- **Redirect Builder** - Clean redirect API with flash message support
- **Middleware System** - Composable middleware at route and group levels
- **Middleware Groups** - Pre-configured middleware stacks for different route types (Web, API, Custom)
- **Form Validation** - Elegant form validation layer to easily validate requests
- **Context System** - Framework-defined `Context(app)` with embedded request, session, and app state
- **Controller Pattern** - Organized request handlers with clear separation of concerns
- **Configuration Management** - Environment-based configuration with `.env` support
- **Automatic Migrations** - Schema-based migration generation with snapshot diffing
- **SQL Queries** - Write raw SQL files with full editor LSP support, compiled to typed Gleam functions
- **Connection Pooling** - Efficient database connection management for PostgreSQL and SQLite
- **Transaction Support** - Atomic operations with automatic retry on deadlock
- **Caching** - Unified caching API with file, SQLite, and PostgreSQL backends
- **Sessions** - Server-side sessions with flash messages, backed by PostgreSQL, SQLite, Redis, file, or cookie drivers
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
# Run with hot reloading and hook support
./glimr run

# Or run with standard gleam command
gleam run
```

Visit `http://localhost:8000` in your browser.

## Project Structure

```
├── config/                             # Configuration TOML files
├── src/
│   ├── glimr_app.gleam                 # Application entry point
│   ├── app/
│   │   ├── app.gleam                   # Application type definition
│   │   ├── console/                    # Custom console commands ran with `./glimr`
│   │   │   ├── commands/               # Where your custom console commands live
│   │   ├── http/
│   │   │   ├── controllers/            # Request handlers (routes defined here)
│   │   │   ├── middleware/             # Custom middleware
│   │   │   ├── validators/             # Request body validation
│   │   │   ├── rules/                  # Custom validation rules
│   │   │   └── kernel.gleam            # HTTP middleware configuration
│   ├── bootstrap/
│   │   ├── bootstrap.gleam             # Application bootstrapping
│   │   ├── app.gleam                   # App state and resource startup
│   │   └── routes.gleam                # Route group registration
│   ├── compiled/                       # Generated gleam files (loom, routes)
│   ├── database/                       # Database schemas, models, and migrations
│   │   └── main/                       # Connection name (one directory per connection)
│   │       ├── models/                 # Schema definitions and generated models
│   │       └── _migrations/            # Database migrations for connection
│   ├── resources/
│   │   └── views/                      # Loom templates (.loom.html files)
│   │       └── components/             # Reusable Loom components
├── test/                               # Test files
├── .env                                # Environment variables
└── gleam.toml                          # Project configuration
```

## Build Tools

Gleam provides `gleam build` and `gleam run` out of the box, which you can of course use. Glimr however provides similar commands that also support hooks to customize the build process. Also, `gleam run` currently does not support hot reloading, while `./glimr run` does.

### Vite & Tailwind

Glimr uses [Vite](https://vite.dev/) as its asset bundler and [Tailwind CSS](https://tailwindcss.com/) for styling. Your frontend entry point lives at `src/resources/ts/app.ts`, and your stylesheet at `src/resources/css/app.css`.

#### How It Works

In development, `./glimr run` starts the Vite dev server alongside the Gleam application. Vite serves your JavaScript and CSS with hot module replacement — when you change a `.css` or `.ts` file, updates appear instantly in the browser without a full reload.

In production, run `npm run build` before deploying. Vite compiles your assets into hashed files under `priv/static/` and generates a manifest. The framework reads this manifest to emit the correct `<script>` and `<link>` tags automatically.

#### Asset Tags

Use the `vite.tags()` function in your layout to include bundled assets:

```html
---
import glimr/vite
---

<!doctype html>
<html>
  <head>
    {{{ vite.tags("src/resources/ts/app.ts") }}}
  </head>
  <body>
    <slot />
  </body>
</html>
```

In dev mode, this emits tags pointing at Vite's dev server. In production, it reads the Vite manifest and outputs hashed filenames with `/static/` prefixes.

#### Adding JavaScript

Your `src/resources/ts/app.ts` is the entry point. The Loom client runtime is already imported — add your own code below:

```ts
import "../css/app.css";
import "@glimr/loom";

// Your code here
document.addEventListener("DOMContentLoaded", () => {
  console.log("App loaded");
});
```

Vite supports TypeScript out of the box. Use the `@` alias to import from `src/resources/ts/`:

```ts
import { formatDate } from "@/utils";
```

#### Adding Styles

Your `src/resources/css/app.css` imports Tailwind and is where you add custom CSS:

```css
@import "tailwindcss";

/* Custom styles */
.btn-primary {
  @apply bg-blue-500 text-white px-4 py-2 rounded;
}
```

Tailwind automatically scans your `.loom.html` templates for class names.

#### Production Build

```bash
npm run build
```

This outputs hashed assets to `priv/static/` and a manifest at `priv/static/.vite/manifest.json`. The `priv/static/` directory is gitignored — assets should be built during deployment.

#### Static Files

To serve static files like images, fonts, or favicons, place them in the `priv/static/` directory. The `serve_static` middleware serves these files under the `/static/` URL prefix.

For example, a file at `priv/static/images/favicon.svg` is accessible at `/static/images/favicon.svg`:

```html
<link rel="icon" type="image/svg+xml" href="/static/images/favicon.svg" />
<img src="/static/images/logo.png" />
```

### Build Command

```bash
./glimr build
```

This automatically compiles routes, Loom templates, console commands, and database models (based on your `glimr.toml` config flags), runs any configured `pre-build` hooks, compiles your Gleam code, then runs `post-build` hooks.

### Run Command

```bash
./glimr run
```

This automatically compiles routes, Loom templates, console commands, and database models, then runs `pre-run` hooks, starts your application with Vite's dev server, and watches for file changes. When `.gleam` files change, it automatically reloads your application. When template or CSS changes are detected, the browser reloads automatically.

#### Dev Proxy

When running via `./glimr run`, a dev proxy sits in front of your application to provide a seamless development experience. The proxy holds incoming requests during app restarts, so you never see connection errors when the app is recompiling.

```
Browser → Proxy (APP_PORT) → App (DEV_PROXY_PORT)
```

Configure the ports in your `.env` file:

```env
APP_PORT=8000         # Port you access in your browser
DEV_PROXY_PORT=8001   # Internal port for the app (proxy forwards here)
```

Access your app at `http://localhost:8000` (or whatever `APP_PORT` is set to). The proxy handles forwarding to the internal port automatically.

In production (when running directly via `gleam run`), there's no proxy—your app listens directly on `APP_PORT`.

### Hooks

Hooks let you run shell commands or Glimr console commands at specific points during the build/run lifecycle. Configure them in `glimr.toml` at your project root.

Route compilation, Loom template compilation, console command compilation, and database model generation all happen automatically based on the `auto_compile` / `auto_gen` flags in `glimr.toml` — no need to add them as hooks. Hooks are for your own custom extensions (e.g. building CSS, running linters).

#### Available Hooks

| Hook | When it runs |
|------|--------------|
| `hooks.build.pre` | Before `./glimr build` compiles |
| `hooks.build.post` | After `./glimr build` completes |
| `hooks.run.pre` | Once when `./glimr run` starts |
| `hooks.run.reload.pre` | When any `.gleam` file changes (before restart) |
| `hooks.run.reload.post-modified` | After all other reload hooks run, before the actual restart occurs |

### Glimr Commands

Hooks that start with `./glimr` run in-process for better performance:

```toml
[hooks.build]
pre = [
  "./glimr some_command",   # runs in-process (fast)
  "npm run css:build",      # runs as shell command
]
post = [
  "gleam format",           # runs after build completes
]
```

## Routes

Glimr uses annotation-based routing where routes are defined directly in your controller files using doc comments. These annotations are compiled into efficient pattern-matching code, giving you the best of both worlds: ergonomic route definitions and blazing-fast runtime performance.

### Defining Routes

Routes are defined using annotations in doc comments above your controller functions:

```gleam
// src/app/http/controllers/user_controller.gleam
import compiled/loom/welcome
import glimr/http/http.{type Response}

/// @get "/welcome"
pub fn show() -> Response {
  response.html(welcome.render(), 200)
}

// ...
```

You can access the `Context` by just accepting it as a parameter. The context carries the HTTP request, session, response format, and your app state:

```gleam
// src/app/http/controllers/user_controller.gleam
import app/app.{type App}
import glimr/http/context.{type Context}
import glimr/http/http.{type Response}
import compiled/loom/welcome

/// @get "/welcome"
pub fn show(ctx: Context(App)) -> Response {
  // Access the request via ctx.req
  // Access app state via ctx.app

  response.html(welcome.render(), 200)
}

// ...
```

Available HTTP method annotations:
- `@get "/path"` - GET request
- `@post "/path"` - POST request
- `@put "/path"` - PUT request
- `@patch "/path"` - PATCH request
- `@delete "/path"` - DELETE request
- `@head "/path"` - HEAD request
- `@options "/path"` - OPTIONS request

Routes are automatically compiled when using:

```bash
# Routes compile automatically during build and run
./glimr build
./glimr run

# Manually compile routes
./glimr route_compile
```

This compiles to a pattern matched router in `src/compiled/routes/web.gleam`:

```gleam
import app/http/controllers/user_controller
import gleam/http.{Delete, Get, Post, Put}
import glimr/response/response

pub fn routes(path, method, ctx) {
  case path {
    ["users"] ->
      case method {
        Get -> user_controller.index(ctx)
        Post -> user_controller.store(ctx)
        _ -> response.method_not_allowed([Get, Post])
      }

    ["users", id] ->
      case method {
        Get -> user_controller.show(ctx, id)
        Put -> user_controller.update(ctx, id)
        Delete -> user_controller.destroy(ctx, id)
        _ -> response.method_not_allowed([Get, Put, Delete])
      }

    _ -> response.not_found()
  }
}
```

### Route Parameters

Use `:param` syntax in your route path to capture URL segments as parameters:

```gleam
import glimr/http/http.{type Response}

/// @get "/posts/:post_id/comments/:comment_id"
pub fn show(post_id: String, comment_id: String) -> Response {
  // Access post_id and comment_id directly as function parameters
}
```

### Redirects

Add redirects to routes using `@redirect` (303 temporary) or `@redirect_permanent` (308 permanent):

```gleam
import glimr/http/http.{type Response}

/// @redirect "/old-contact"
/// @redirect "/contact-us"
/// @get "/contact"
pub fn show() -> Response {
  // Both /old-contact and /contact-us redirect here
}

/// @redirect_permanent "/legacy-api"
/// @get "/api/v2"
pub fn index() -> Response {
  // /legacy-api permanently redirects here
}
```

### Route Middleware

Apply middleware to individual routes using `middleware.apply` with `use`:

```gleam
import app/http/middleware/auth
import app/http/middleware/rate_limit
import glimr/http/http.{type Response}
import glimr/http/middleware

/// @get "/dashboard"
pub fn show(ctx: Context(App)) -> Response {
  use ctx <- middleware.apply([auth.run, rate_limit.run], ctx)
  // Protected by auth and rate_limit middleware
}
```

### Controller Middleware

Apply middleware to all routes in a controller by defining a `middleware()` function. The route compiler detects this function and wraps every handler in the controller automatically:

```gleam
// src/app/http/controllers/admin_controller.gleam
import app/http/middleware/admin
import app/http/middleware/auth
import glimr/http/http.{type Response}

pub fn middleware() {
  [auth.run, admin.run]
}

/// @get "/admin/dashboard"
pub fn dashboard(ctx: Context(App)) -> Response {
  // Protected by auth and admin middleware
}

/// @get "/admin/settings"
pub fn settings(ctx: Context(App)) -> Response {
  // Also protected by auth and admin middleware
}
```

You can combine controller middleware with route-specific middleware:

```gleam
import app/http/middleware/auth
import app/http/middleware/logging
import glimr/http/http.{type Response}
import glimr/http/middleware

pub fn middleware() {
  [auth.run]
}

/// @get "/dashboard"
pub fn dashboard(ctx: Context(App)) -> Response {
  // Only auth middleware (from controller)
}

/// @get "/reports"
pub fn reports(ctx: Context(App)) -> Response {
  use ctx <- middleware.apply([logging.run], ctx)
  // Auth (from controller) then logging (per-route)
}
```

### Validators

Attach form validators to routes using the `use` syntax for validated and typed form data in your controller functions:

```gleam
import app/http/validators/user_store
import glimr/http/http.{type Response}

/// @post "/users"
pub fn store(ctx: Context(App)) -> Response {
  use validated <- user_store.validate(ctx)

  // validated contains the validated form data
  // Validation errors automatically return 422

  // validated.name
  // validated.email
  // etc.
}
```

See [Form Validation](#form-validation) for details on creating validators.

### Route Groups

Route groups determine which compiled file your routes end up in and which middleware stack they use. Groups are configured in `config/route_group.gleam`:

```toml
# config/route_group.toml

[groups.web]
  prefix = ""
  middleware = "web"

[groups.api]
  prefix = "/api"
  middleware = "api"

```

Routes are matched to groups by their URL prefix:
- A route `@get "/api/users"` matches the `api` group (prefix `/api`) → compiles to `api.gleam`
- A route `@get "/dashboard"` matches the `web` group (empty prefix catch-all) → compiles to `web.gleam`

#### API Routes

By default, routes with the `/api` prefix:
- Compile to `src/compiled/routes/api.gleam`
- Use the `Api` middleware group (JSON error responses)
- The prefix is configured in `config/route_group.toml`

```gleam
// src/app/http/controllers/api/user_controller.gleam
import glimr/http/http.{type Response}

/// @get "/api/users"
pub fn index() -> Response {
  // Returns JSON, errors are JSON formatted
}
```

#### Adding Custom Route Groups

To add a new route group (e.g., `/admin`):

1. Add the group config in `config/route_group.toml`:

```toml
# config/route_group.toml

[groups.web]
  prefix = ""
  middleware = "web"

[groups.api]
  prefix = "/api"
  middleware = "api"

# New route group "admin"
[groups.admin]
  prefix = "/admin"
  middleware = "admin"

```

Create the route file with this command:

```bash
# Create a route file in compiled/routes/admin.gleam
./glimr make_route_file admin

# Create a route file in routes/admin.gleam if you prefer to 
# use direct pattern matching instead of compiled routing
./glimr make_route_file admin --direct
```

2. Register the routes file in `src/bootstrap/routes.gleam`:

```gleam
import compiled/routes/admin
import compiled/routes/api
import compiled/routes/web

pub fn groups() -> List(RouteGroup(Context(App))) {
  use name <- router.load()

  case name {
    "api" -> api.routes
    "admin" -> admin.routes // Register new "admin" route group
    _ -> web.routes
  }
}
```

3. Handle the custom middleware group in `src/app/http/kernel.gleam`:

```gleam
import glimr/http/http.{type Response}

pub fn handle(ctx, middleware_group, router) -> Response {
  case middleware_group {
    kernel.Api -> {
      [
        expects_json.run,
        method_override.run,
        log_request.run,
        rescue_crashes.run,
        handle_head.run,
      ]
      |> middleware.apply(ctx, router)
    }
    kernel.Custom("admin") -> { // <-- Add your middleware group before the web group
      [
        expects_html.run,
        method_override.run,
        log_request.run,
        rescue_crashes.run,
        handle_head.run,
        admin_auth.run,
      ]
      |> middleware.apply(ctx, router)
    }
    kernel.Web | _ -> {
      [
        expects_html.run,
        serve_static.run,
        method_override.run,
        log_request.run,
        rescue_crashes.run,
        handle_head.run,
      ]
      |> middleware.apply(ctx, router)
    }
  }
}
```

> **Note:** Learn more about custom middleware groups in the [Custom Middleware Groups](#creating-custom-groups) section.

### Direct Pattern Matching

If you prefer to write routes manually without annotations, you can bypass the compiler entirely:

1. Set `auto_compile = false` under `[routes]` in `glimr.toml`
2. Create your route files directly in `src/routes/` (or any another location)
3. Write pattern-matching routes:

```gleam
// src/routes/web.gleam
import gleam/http.{Get, Post}
import app/http/controllers/home_controller
import app/http/controllers/user_controller
import glimr/response/response

pub fn routes(path, method, ctx) {
  case path {
    [] ->
      case method {
        Get -> home_controller.show(ctx)
        _ -> response.method_not_allowed([Get])
      }

    ["users"] ->
      case method {
        Get -> user_controller.index(ctx)
        Post -> user_controller.store(ctx)
        _ -> response.method_not_allowed([Get, Post])
      }

    ["users", id] ->
      case method {
        Get -> user_controller.show(ctx, id)
        _ -> response.method_not_allowed([Get])
      }

    _ -> response.not_found()
  }
}
```

4. Update `bootstrap/routes.gleam` to import from your custom location if needed.

## Controllers

Controllers handle HTTP requests and contain your route definitions via annotations. Create controllers in `src/app/http/controllers/`:

```bash
./glimr make_controller user_controller
```

This creates `user_controller.gleam`. Define routes using annotations above your handler functions:

```gleam
// src/app/http/controllers/user_controller.gleam
import app/http/validators/user_store
import compiled/loom/user_show
import glimr/http/http.{type Response}
import glimr/response/redirect
import glimr/response/response

/// @get "/users/:user
pub fn show(ctx: Context(App), user: String) -> Response {
  // get the user...

  response.html(user_show.render(user: user), 200)
}

/// @post "/users"
pub fn store(ctx: Context(App)) -> Response {
  use validated <- user_store.validate(ctx)
  // Handle POST request...

  redirect.back(ctx)
}
```

Create resource controllers with common CRUD functions pre-defined:

```bash
./glimr make_controller user_controller --resource
```

This generates a controller with `index`, `show`, `create`, `store`, `edit`, `update`, and `destroy` functions—add route annotations as needed.

## Actions

Actions help keep controllers clean by extracting complex business logic into reusable modules that can be used in controllers, and console commands. They encapsulate database operations and can return `Result` types for clean error handling on the controller's or command's side.

Create actions in `src/app/actions/`. Use the following command:

```bash
./glimr make_action update_submission
```

This creates `update_submission.gleam`. Actions follow a simple pattern - they perform work and return a Result. If you're going to perform database work within your action, it's preferable to accept a `Pool` rather than an entire `App`, so that this action may be usable from console commands as well:

```gleam
// src/app/actions/update_submission.gleam
import app/http/requests/contact_store_request.{type Data}
import database/models/submission/gen/submission_repository.{type CreateRow}
import glimr/db/db.{type DbError}
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
import app/http/validators/contact_store
import glimr/db/db.{NotFound}
import glimr/http/http.{type Response}

/// @put "/submissions/:submission"
pub fn update(ctx: Context(App), submission: String) -> Response {
  use validated <- contact_store.validate(ctx)
  let assert Ok(submission_id) = int.parse(submission_id)

  case update_submission.run(ctx.app.db, submission_id, validated) {
    Ok(submission) -> {
      redirect.to("/contact/updated")
    }
    Error(NotFound) -> response.not_found()
    Error(_) -> response.internal_server_error()
  }
}
```

### Chaining Multiple Actions

Actions can be composed using `result.try` for sequential operations:

```gleam
import app/http/validators/user_store
import gleam/result
import glimr/http/http.{type Response}

/// @post "/users"
pub fn store(ctx: Context(App)) -> Response {
  use validated <- user_store.validate(ctx)

  case {
    use user <- result.try(create_user.run(ctx.app.db, validated))
    use _ <- result.try(send_welcome_email.run(ctx.app.notif, user))
    use _ <- result.try(notify_admin.run(ctx.app.notif, user))
    Ok(user)
  } {
    Ok(user) -> {
      redirect.to("/users/" <> int.to_string(user.id))
    }
    Error(_) -> response.internal_server_error()
  }
}
```

## Middleware

Middleware intercepts requests before they reach your controllers. Middleware can modify both the request and context, with changes flowing through to subsequent middleware and controllers.

### Creating Middleware

Create custom middleware in `src/app/http/middleware/`. Use the following command:

```bash
./glimr make_middleware logger
```

This creates `logger.gleam`. In it you can add your custom logic.

```gleam
// app/http/middleware/logger.gleam
import app/app.{type App}
import glimr/http/context.{type Context}
import glimr/http/http.{type Response}
import glimr/http/kernel.{type Next}

pub fn run(ctx: Context(App), next: Next(App)) -> Response {
  io.println("Request received")

  // Pass context to next middleware/handler
  next(ctx)
}
```

### Applying Middleware to a Route

Apply middleware to individual routes using `middleware.apply` with `use`:

```gleam
// src/app/http/controllers/dashboard_controller.gleam
import app/http/middleware/auth
import glimr/http/http.{type Response}
import glimr/http/middleware

/// @get "/dashboard"
pub fn show(ctx: Context(App)) -> Response {
  use ctx <- middleware.apply([auth.run], ctx)
  // Protected by auth middleware
}
```

### Applying Middleware to Entire Controllers

Apply middleware to all routes in a controller by defining a `middleware()` function:

```gleam
// src/app/http/controllers/admin_controller.gleam
import app/http/middleware/admin
import app/http/middleware/auth
import glimr/http/http.{type Response}

pub fn middleware() {
  [auth.run, admin.run]
}

/// @get "/admin/dashboard"
pub fn dashboard(ctx: Context(App)) -> Response {
  // Protected by auth and admin middleware
}
```

### Modifying Context in Middleware

Middleware can modify the context, and those changes are visible to downstream middleware and controllers:

```gleam
// middleware/auth.gleam
pub fn run(ctx, next) {
  case authenticate(ctx.req) {
    Ok(user) -> {
      // Add authenticated user to app state
      let updated_ctx = Context(..ctx, app: App(..ctx.app, user: Some(user)))
      next(updated_ctx)
    }
    Error(_) -> response.empty(401)
  }
}
```

Then in your controller:

```gleam
import app/http/middleware/auth
import glimr/http/http.{type Response}
import glimr/http/middleware

/// @get "/dashboard"
pub fn dashboard(ctx: Context(App)) -> Response {
  use ctx <- middleware.apply([auth.run], ctx)
  // Safe to assert because auth middleware guarantees this
  let assert Some(user) = ctx.app.user

  response.html(dashboard.render(user: user), 200)
}
```

### Modifying Responses After Handler

Middleware can also modify responses on the way back up the chain:

```gleam
// middleware/cors.gleam
import glimr/response/response

pub fn run(ctx, next) {
  // Call the next middleware/handler first
  let resp = next(ctx)

  // Modify the response on the way back
  resp
  |> response.header("Access-Control-Allow-Origin", "*")
  |> response.header("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE")
}
```

This allows middleware to:
- Add headers to responses (CORS, security headers, etc.)
- Log response times
- Compress response bodies
- Transform response data

### Middleware Groups

Middleware groups let you define different middleware stacks for different types of routes. By default, Glimr provides `Web` and `Api` groups, but you can create your own.

#### Built-in Groups

Groups are defined in `src/app/http/kernel.gleam`:

```gleam
import app/app.{type App}
import glimr/http/context.{type Context}
import glimr/http/http.{type Response}
import glimr/http/kernel.{type MiddlewareGroup}
import glimr/http/middleware
import glimr/http/middleware/expects_html
import glimr/http/middleware/expects_json
import glimr/http/middleware/handle_head
import glimr/http/middleware/load_session
import glimr/http/middleware/log_request
import glimr/http/middleware/method_override
import glimr/http/middleware/rescue_crashes
import glimr/http/middleware/serve_static

pub fn handle(
  ctx: Context(App),
  middleware_group: MiddlewareGroup,
  router: fn(Context(App)) -> Response,
) -> Response {
  case middleware_group {
    kernel.Api -> {
      [
        expects_json.run,
        method_override.run,
        log_request.run,
        rescue_crashes.run,
        handle_head.run,
        load_session.run,
      ]
      |> middleware.apply(ctx, router)
    }
    kernel.Web | _ -> {
      [
        expects_html.run,
        serve_static.run,
        method_override.run,
        log_request.run,
        rescue_crashes.run,
        handle_head.run,
        load_session.run,
      ]
      |> middleware.apply(ctx, router)
    }
  }
}
```

The `expects_html` and `expects_json` middleware set the response format for each group. This controls how error responses are rendered — `expects_html` returns styled HTML error pages (using custom templates from `views/errors/` if available), while `expects_json` returns structured `{"error": "..."}` responses. They should be the first middleware in each group so all downstream middleware and controllers produce errors in the correct format.

#### Assigning Groups to Routes

Route groups are configured in `/config/route_group.toml`:

```toml
[groups.web]
  prefix = ""
  middleware = "web"

[groups.api]
  prefix = "/api"
  middleware = "api"
```

Routes are automatically assigned to groups based on their URL prefix. See [Route Groups](#route-groups) for details.

#### Creating Custom Groups

Add a custom middleware group using `kernel.Custom("name")`:

```toml
# /config/route_group.toml
[groups.web]
  prefix = ""
  middleware = "web"

[groups.api]
  prefix = "/api"
  middleware = "api"

[groups.admin]
  prefix = "/admin"
  middleware = "admin"
```

Then handle it in `src/app/http/kernel.gleam`:

```gleam
import glimr/http/http.{type Response}

pub fn handle(ctx, middleware_group, router) -> Response {
  case middleware_group {
    kernel.Api -> {
      [
        expects_json.run,
        method_override.run,
        log_request.run,
        rescue_crashes.run,
        handle_head.run,
      ]
      |> middleware.apply(ctx, router)
    }
    kernel.Custom("admin") -> {
      [
        expects_html.run,
        method_override.run,
        log_request.run,
        rescue_crashes.run,
        handle_head.run,
        admin_auth.run,
      ]
      |> middleware.apply(ctx, router)
    }
    kernel.Web | _ -> {
      [
        expects_html.run,
        serve_static.run,
        method_override.run,
        log_request.run,
        rescue_crashes.run,
        handle_head.run,
      ]
      |> middleware.apply(ctx, router)
    }
  }
}
```

This lets you define completely different middleware stacks for different parts of your application.

## Session

Glimr provides a full-featured session layer with support for multiple storage backends. Sessions are backed by an OTP actor per request, giving you mutable state within Gleam's immutable paradigm. The session middleware handles the full lifecycle automatically: reading the cookie, loading data from the store, providing a live session to your controllers, then persisting changes and setting the cookie on the response.

### Session Configuration

Session settings live in `config/session.toml`:

```toml
# config/session.toml

table = "sessions"
cookie = "glimr_session"
lifetime = 120
expire_on_close = false
```

| Setting | Description |
|---------|-------------|
| `table` | Database table name (used by PostgreSQL and SQLite drivers) |
| `cookie` | Cookie name for the session ID |
| `lifetime` | Session lifetime in minutes |
| `expire_on_close` | If `true`, cookie expires when browser closes (no `Max-Age`) |

### Choosing a Driver

Session drivers are initialized in `bootstrap/app.gleam`. Each driver shares the same session API — you only change the start call to switch backends. The `load_session` middleware in your kernel then hydrates a live session for each request automatically.

#### PostgreSQL Driver

Stores sessions in a PostgreSQL table. Shares your existing database pool.

```bash
gleam add glimr_postgres
```

Generate the session table migration:

```bash
# Generate the migration
./glimr make_session_table

# Or generate and run migrations in one step
./glimr make_session_table --migrate
```

Create the session store in your bootstrap:

```gleam
// bootstrap/app.gleam
pub fn start() -> app.App {
  app.App(
    db: postgres.start("main"), 
    cache: redis.start("main"),
  )
}

// bootstrap/bootstrap.gleam (inside init)
postgres.session_store(app.db) |> session.setup()
```

#### SQLite Driver

Stores sessions in a SQLite table. Shares your existing database pool.

```bash
gleam add glimr_sqlite
```

Generate the session table migration:

```bash
./glimr make_session_table

# Or generate and run migrations in one step
./glimr make_session_table --migrate
```

Create the session store in your bootstrap:

```gleam
// bootstrap/app.gleam
pub fn start() -> app.App {
  app.App(
    db: sqlite.start("main"),
    cache: redis.start("main"),
  )
}

// bootstrap/bootstrap.gleam (inside init)
sqlite.session_store(app.db) |> session.setup()
```

#### Redis Driver

Stores sessions in Redis with automatic TTL-based expiration. No garbage collection needed. Also works with Valkey, KeyDB, and Dragonfly.

```bash
gleam add glimr_redis
```

Create the session store in your bootstrap:

```gleam
// bootstrap/app.gleam
pub fn start() -> app.App {
  app.App(
    db: postgres.start("main"),
    cache: redis.start("main"),
  )
}

// bootstrap/bootstrap.gleam (inside init)
redis.session_store("main") |> session.setup()
```

#### File Driver

Stores sessions as files on disk using the file cache pool. No database required.

Create the session store in your bootstrap:

```gleam
// bootstrap/app.gleam
pub fn start() -> app.App {
  app.App(
    db: postgres.start("main"),
    cache: file_cache.start("main"),
  )
}

// bootstrap/bootstrap.gleam (inside init)
file_cache.session_store("main") |> session.setup()
```

#### Cookie Driver

Stores session data directly in a signed cookie. No server-side persistence needed. Best for small payloads under ~4KB.

Create the session store in your bootstrap:

```gleam
// bootstrap/app.gleam
pub fn start() -> app.App {
  app.App(
    db: postgres.start("main"),
    cache: redis.start("main"),
  )
}

// bootstrap/bootstrap.gleam (inside init)
session.cookie_store() |> session.setup()
```

### Kernel Middleware

The `load_session` middleware runs in your kernel and hydrates a live session onto the context for each request. Add it to your middleware groups in `src/app/http/kernel.gleam`:

```gleam
import glimr/http/http.{type Response}

pub fn handle(ctx, middleware_group, router) -> Response {
  case middleware_group {
    kernel.Api -> {
      [
        expects_json.run,
        method_override.run,
        log_request.run,
        rescue_crashes.run,
        handle_head.run,
        load_session.run,
      ]
      |> middleware.apply(ctx, router)
    }
    kernel.Web | _ -> {
      [
        expects_html.run,
        serve_static.run,
        method_override.run,
        log_request.run,
        rescue_crashes.run,
        handle_head.run,
        load_session.run,
      ]
      |> middleware.apply(ctx, router)
    }
  }
}
```

### Session API

All session operations interact with the per-request OTP actor through `ctx.session`:

```gleam
import glimr/http/http.{type Response}
import glimr/response/redirect
import glimr/session/session

/// @post "/profile"
pub fn update(ctx: Context(App)) -> Response {
  // Store a value
  session.put(ctx.session, "user_id", "123")

  // Get a value
  case session.get(ctx.session, "user_id") {
    Ok(user_id) -> {} // use user_id
    Error(Nil) -> {} // not in session
  }

  // Check if a key exists
  let logged_in = session.has(ctx.session, "user_id")

  // Get all session data
  let all_data = session.all(ctx.session)

  // Remove a key
  session.forget(ctx.session, "user_id")

  // Get the session ID
  let id = session.id(ctx.session)

  // Redirect back
  redirect.back(ctx)
}
```

### Flash Messages

Flash messages are one-shot values: set during this request, available only on the next request, then automatically cleared. Ideal for success/error messages after redirects.

```gleam
import glimr/http/context.{type Context}
import glimr/http/http.{type Response}
import glimr/session/session

/// @post "/login"
pub fn login(ctx: Context(App)) -> Response {
  // Set flash messages for the next request
  session.flash(ctx.session, "success", "Welcome back!")

  redirect.to("/dashboard")
}

/// @get "/dashboard"
pub fn dashboard(ctx: Context(App)) -> Response {
  response.html(dashboard.render(ctx), 200)
}
```
And then in your loom file

```html
---
import glimr/session/session
import glimr/http/context.{type Context}
import app/app.{type App}

props(ctx: Context(App))
---

...

<div l-if="session.has_flash(ctx.session, 'message')">
  {{ session.get_flash(ctx.session, "message") }}
</div>

...
```

### Session Invalidation & Regeneration

```gleam
import glimr/http/http.{type Response}
import glimr/session/session

/// @post "/logout"
pub fn logout(ctx: Context(App)) -> Response {
  // Destroy all session data and issue a new session ID
  session.invalidate(ctx.session)

  redirect.to("/login")
}

/// @post "/login"
pub fn login(ctx: Context(App)) -> Response {
  // After authentication, regenerate the session ID to prevent
  // session fixation attacks. Keeps existing data, new ID only.
  session.regenerate(ctx.session)

  session.put(ctx.session, "user_id", user.id)

  redirect.to("/dashboard")
}
```

## Authentication

Glimr provides a `make_auth` command that scaffolds everything needed for model-based authentication — the database model, middleware, controllers, validators, and context wiring.

First, add the `glimr_auth` package to your project:

```bash
gleam add glimr_auth
```

### Generating Auth Scaffolding

```bash
./glimr make_auth user
```

This generates:

- **Model** — schema with `email` and `password` columns, plus CRUD queries in `src/database/{connection}/models/user/`
- **Migration** — a migration for the users table
- **Load middleware** — `src/app/http/middleware/load_user.gleam` — resolves the current user from the session on every request
- **Auth middleware** — `src/app/http/middleware/auth_user.gleam` — redirects unauthenticated visitors to `/login`
- **Guest middleware** — `src/app/http/middleware/guest_user.gleam` — redirects authenticated users away from login/register pages
- **Login validator** — `src/app/http/validators/store_login.gleam` — validates login form data (email + password)
- **Register validator** — `src/app/http/validators/store_register.gleam` — validates registration form data (email + password with confirmation)
- **Login controller** — `src/app/http/controllers/auth/login_controller.gleam` — handles login form display and authentication
- **Logout controller** — `src/app/http/controllers/auth/logout_controller.gleam` — invalidates the session and redirects
- **Register controller** — `src/app/http/controllers/auth/register_controller.gleam` — handles registration with password hashing and automatic login
- **Dashboard controller** — `src/app/http/controllers/dashboard_controller.gleam` — a protected page shown after login
- **Loom views** — `src/resources/views/auth/login.loom.html`, `src/resources/views/auth/register.loom.html`, `src/resources/views/dashboard.loom.html` — ready-to-use Tailwind-styled pages for login, registration, and a post-login dashboard
- **Context patches** — adds a `user: Option(user.User)` field to your `App` type, initializes it in the bootstrap module, and registers the load middleware in the kernel

Add `-m` to run migrations immediately:

```bash
./glimr make_auth user -m
```

### Skipping Views

If you prefer to build your own login, register, and dashboard pages, pass `--no-views` (or `-nv`) to skip generating loom templates:

```bash
./glimr make_auth user --no-views
```

The controllers will still be generated, but their `show()` functions will contain a `todo` instead of rendering a view. Everything else — models, middleware, validators, context patches — is scaffolded as usual.

If you run `make_auth` again for a different model without `--scoped`, it will warn you that unscoped auth already exists and suggest using scoped mode instead.

### Scoped Mode

When your application needs multiple authenticatable models (e.g. users and customers), use `--scoped` for additional models:

```bash
./glimr make_auth customer --scoped
```

Scoped mode namespaces middleware, controllers, and validators to avoid conflicts:

| File | Unscoped (`make_auth user`) | Scoped (`make_auth customer --scoped`) |
|------|---------------------------|----------------------------------------|
| Login validator | `validators/store_login.gleam` | `validators/store_customer_login.gleam` |
| Register validator | `validators/store_register.gleam` | `validators/store_customer_register.gleam` |
| Login controller | `controllers/auth/login_controller.gleam` | `controllers/auth/customer_login_controller.gleam` |
| Dashboard controller | `controllers/dashboard_controller.gleam` | `controllers/customer_dashboard_controller.gleam` |
| Login view | `views/auth/login.loom.html` | `views/auth/customer/login.loom.html` |
| Register view | `views/auth/register.loom.html` | `views/auth/customer/register.loom.html` |
| Dashboard view | `views/dashboard.loom.html` | `views/customer/dashboard.loom.html` |
| Routes | `/login`, `/register`, `/logout`, `/dashboard` | `/customer/login`, `/customer/register`, `/customer/logout`, `/customer/dashboard` |

Middleware (`auth_{model}.gleam`, `guest_{model}.gleam`, `load_{model}.gleam`), the model, and context patches are always model-specific regardless of mode.

### Multiple Auth Models

A common pattern is having regular users and a separate admin panel. With Glimr, this is two commands:

```bash
./glimr make_auth user
./glimr make_auth admin --scoped
```

This generates completely independent auth stacks — each with its own model, middleware, controllers, and session key. Your `App` type ends up with both models available on the context:

```gleam
pub type App {
  App(
    db: glimr_postgres.Pool,
    user: Option(user.User),
    admin: Option(admin.Admin),
  )
}
```

Each model gets its own middleware, controllers, and views. The generated dashboard controllers render model-specific views:

```gleam
// src/app/http/controllers/dashboard_controller.gleam
import glimr/http/http.{type Response}

/// @get "/dashboard"
pub fn show(ctx: Context(App)) -> Response {
  let assert option.Some(user) = ctx.app.user
  response.html(dashboard.render(ctx: ctx, user: user), 200)
}

// src/app/http/controllers/admin_dashboard_controller.gleam
import glimr/http/http.{type Response}

/// @get "/admin/dashboard"
pub fn show(ctx: Context(App)) -> Response {
  let assert option.Some(admin) = ctx.app.admin
  response.html(dashboard.render(ctx: ctx, admin: admin), 200)
}
```

Users log in at `/login`, admins at `/admin/login` — completely separate flows with separate throttling, sessions, and redirects. Registration works the same way — users register at `/register`, admins at `/admin/register`:

```gleam
import glimr/http/http.{type Response}

/// @post "/admin/register"
pub fn store(ctx: Context(App)) -> Response {
  use validated <- store_admin_register.validate(ctx)

  let now = unix_timestamp.now()

  let registered = {
    use pool, hashed_password <- admin.register(
      session: ctx.session,
      pool: ctx.app.db,
      password: validated.password,
    )

    admin.create(
      pool: pool,
      email: validated.email,
      password: hashed_password,
      created_at: now,
      updated_at: now,
    )
  }

  case registered {
    Ok(_) -> {
      let message = "Admin account created"

      session.flash(ctx.session, "message", message)

      redirect.to(guest_admin.auth_redirect)
    }
    Error(_) -> {
      let message = "Registration failed"

      session.flash(ctx.session, "error", message)

      redirect.back(ctx)
    }
  }
}
```

Each model can also have its own throttle limits:

```gleam
// src/database/main/models/admin/admin_schema.gleam
pub const authenticatable = True
pub const max_login_attempts = 3
pub const lockout_seconds = 300
```

### Authenticatable Schema

The generated schema includes constants that control authentication behavior:

```gleam
import glimr/db/schema

pub const table_name = "users"

pub const authenticatable = True

pub const max_login_attempts = 5

pub const lockout_seconds = 60

pub fn definition() {
  schema.table(table_name, [
    schema.id(),
    schema.string("email"),
    schema.string("password"),
    schema.unix_timestamps(),
  ])
  |> schema.indexes([
    schema.unique(["email"]),
  ])
}
```

- `authenticatable = True` — tells the code generator to create `authenticate` and `register` functions plus a `session_key` constant on the generated model
- `max_login_attempts` — number of failed login attempts before lockout (default: 5)
- `lockout_seconds` — how long the lockout lasts in seconds (default: 60)

The generated auth functions automatically detect the primary key type from your schema. If you use `schema.id()`, the generated code wraps the value with `int.to_string`. If you use `schema.uuid("uid")`, the value is used directly since it's already a `String`.

The generated `authenticate` function handles the full login flow — user lookup, timing-safe password verification, session login, and throttling:

```gleam
user.authenticate(
  session: ctx.session,
  pool: ctx.app.db,
  email: validated.email,
  password: validated.password,
)
// -> Result(User, auth.AuthError)
```

Returns `Ok(user)` on success, `Error(auth.InvalidCredentials)` on bad credentials, or `Error(auth.Throttled)` when the login attempt limit is exceeded.

The generated `register` function handles password hashing and automatic login after account creation. It takes a callback so you control exactly which fields get inserted:

```gleam
let registered = {
  use pool, hashed_password <- user.register(
    session: ctx.session,
    pool: ctx.app.db,
    password: validated.password,
  )

  user.create(
    pool: pool,
    email: validated.email,
    password: hashed_password,
    created_at: now,
    updated_at: now,
  )
}
// -> Result(User, db.DbError)
```

The callback receives the database pool and the hashed password. You call your `create` query inside the callback, passing whatever fields your table needs. On success, the user is automatically logged in and the model is returned.

### Generated Controllers

The login controller uses a `middleware()` function to apply guest middleware at the controller level. The `show()` action renders the login view, and `store()` validates input and authenticates:

```gleam
import glimr/http/http.{type Response}

/// Apply the guest middleware to the entire controller
pub fn middleware() -> List(Middleware(App)) {
  [guest_user.run]
}

/// @get "/login"
pub fn show(ctx: Context(App)) -> Response {
  response.html(login.render(ctx: ctx), 200)
}

/// @post "/login"
pub fn store(ctx: Context(App)) -> Response {
  use validated <- store_login.validate(ctx)

  let authenticated = {
    user.authenticate(
      session: ctx.session,
      pool: ctx.app.db,
      email: validated.email,
      password: validated.password,
    )
  }

  case authenticated {
    Ok(user) -> {
      let message = "Welcome back, " <> user.email

      session.flash(ctx.session, "message", message)

      redirect.to(guest_user.auth_redirect)
    }
    Error(_) -> {
      let message = "Invalid email or password"

      session.flash(ctx.session, "error", message)

      redirect.back(ctx)
    }
  }
}
```

The logout controller invalidates the session and flashes a message on the fresh session:

```gleam
import glimr/http/http.{type Response}

/// @post "/logout"
pub fn destroy(ctx: Context(App)) -> Response {
  use ctx <- middleware.apply([auth_user.run], ctx)

  auth.logout(ctx.session)

  session.flash(ctx.session, "message", "You have been logged out.")

  redirect.to(auth_user.guest_redirect)
}
```

The register controller also uses `middleware()` for guest middleware. The `show()` action renders the registration view:

```gleam
import glimr/http/http.{type Response}

/// @get "/register"
pub fn show(ctx: Context(App)) -> Response {
  response.html(register.render(ctx: ctx), 200)
}

/// @post "/register"
pub fn store(ctx: Context(App)) -> Response {
  use validated <- store_register.validate(ctx)

  let now = unix_timestamp.now()

  let registered = {
    use pool, hashed_password <- user.register(
      session: ctx.session,
      pool: ctx.app.db,
      password: validated.password,
    )

    user.create(
      pool: pool,
      email: validated.email,
      password: hashed_password,
      created_at: now,
      updated_at: now,
    )
  }

  case registered {
    Ok(_) -> {
      let message = "Account created successfully"

      session.flash(ctx.session, "message", message)

      redirect.to(guest_user.auth_redirect)
    }
    Error(_) -> {
      let message = "Registration failed"

      session.flash(ctx.session, "error", message)

      redirect.back(ctx)
    }
  }
}
```

The dashboard controller is protected by auth middleware and passes the authenticated model to the view:

```gleam
import glimr/http/http.{type Response}

pub fn middleware() -> List(Middleware(App)) {
  [auth_user.run]
}

/// @get "/dashboard"
pub fn show(ctx: Context(App)) -> Response {
  let assert option.Some(user) = ctx.app.user
  response.html(dashboard.render(ctx: ctx, user: user), 200)
}
```

### Auth & Guest Middleware

The **auth middleware** protects routes that require authentication. It checks `ctx.app.user` and redirects to the login page if the user is not authenticated. Apply it using `middleware.apply`:

```gleam
import app/http/middleware/auth_user
import glimr/http/http.{type Response}

/// @get "/settings"
pub fn show(ctx: Context(App)) -> Response {
  use ctx <- middleware.apply([auth_user.run], ctx)

  // Only authenticated users reach this point.
}
```

The **guest middleware** does the opposite — it redirects authenticated users away from pages like login and registration:

```gleam
import app/http/middleware/guest_user
import glimr/http/http.{type Response}

/// @get "/login"
pub fn show(ctx: Context(App)) -> Response {
  use ctx <- middleware.apply([guest_user.run], ctx)

  // Only unauthenticated users reach this point.
}
```

### Auth Functions

The `glimr_auth` package provides helper functions used by the generated code:

- `auth.login(session, user_id, session_key)` — stores the user ID in the session and regenerates the session ID
- `auth.logout(session)` — invalidates the entire session (clears data, generates fresh ID)
- `auth.check(session, session_key)` — returns `True` if the user is logged in
- `auth.id(session, session_key)` — returns `Ok(user_id)` or `Error(Nil)`
- `auth.check_throttle(session, session_key)` — returns `Error(Throttled)` if locked out
- `auth.record_failure(session, session_key, max_attempts, lockout_seconds)` — increments failed attempt count, sets lockout when threshold reached
- `auth.clear_throttle(session, session_key)` — resets attempt count after successful login
- `hash.make(password)` — hashes a password with bcrypt
- `hash.verify(password, hash)` — verifies a password against a hash
- `hash.dummy_verify(password)` — burns CPU time equivalent to a real verify (timing-safe for nonexistent users)

## Form Validation

Glimr provides a declarative, rule-based validation system for form data. Validation errors are handled automatically based on your route's response format — HTML routes flash errors into the session and redirect back, while API routes return a structured JSON response.

### Creating Form Validators

Create form validator modules in `src/app/http/validators/`. Use the following command:

```bash
./glimr make_validator user_store
```

This creates `user_store.gleam`. In it you can add your custom logic.

```gleam
// src/app/http/validators/user_store.gleam
import app/app.{type App}
import glimr/forms/form.{type UploadedFile}
import glimr/forms/validator.{type FormData, type Rule}
import glimr/http/context.{type Context}
import glimr/http/http.{type Response}
import glimr/response/redirect

/// Define the shape of the data returned after validation
///
pub type Data {
  Data(
    name: String,
    email: String,
    avatar: UploadedFile,
  )
}

/// Define your form's validation rules
///
fn rules(_ctx: Context(App)) -> List(Rule(Context(App))) {
  [
    validator.for("name", [
      validator.Required,
      validator.MinLength(2),
    ]),
    validator.for("email", [
      validator.Required,
      validator.Email,
      validator.MaxLength(255),
    ]),
    validator.for_file("avatar", [
      validator.FileRequired,
      validator.FileMaxSize(5000),
    ]),
  ]
}

/// Set the form data returned after validation. This is also
/// where you can transform validated input data before it
/// reaches your controller.
///
fn data(data: FormData) -> Data {
  Data(
    name: data.get("name"),
    email: data.get("email"),
    avatar: data.get_file("avatar"),
  )
}

/// Run your validation rules. This is your entry point, you
/// don't usually have to adjust anything in this function, but
/// you can if you want to add any custom logic before/after
/// validation.
///
pub fn validate(ctx: Context(App), next: fn(Data) -> Response) {
  use validated <- validator.run(ctx, rules, data, redirect.back(ctx))

  next(validated)
}
```

The `data()` function is also where you can transform validated input before it reaches your controller — normalize values, sanitize strings, or derive new fields:

```gleam
fn data(data: FormData) -> Data {
  Data(
    name: data.get("name") |> string.trim(),
    email: data.get("email") |> string.lowercase(),
    avatar: data.get_file("avatar"),
  )
}
```

### Using Validation in Controllers

Apply validation in your handler using the `use` syntax. If validation fails, errors are handled automatically (flash + redirect for HTML, JSON for API):

```gleam
// app/http/controllers/user_controller.gleam
import app/app.{type App}
import app/http/validators/user_store
import app/repositories/user_repository
import glimr/http/context.{type Context}
import glimr/http/http.{type Response}
import glimr/response/redirect

/// @post "/users"
pub fn store(ctx: Context(App)) -> Response {
  use validated <- user_store.validate(ctx)

  let assert Ok(user) = user_repository.create(
    pool: ctx.app.db,
    name: validated.name,
    email: validated.email,
    avatar: validated.avatar.path,
  )

  session.flash(ctx.session, "message", "User created successfully!")
  redirect.back(ctx)
}
```

### Available Validation Rules

**Text & String Rules:**
- **Required** — Field must have a value
- **Email** — Field must be a valid email address
- **MinLength(Int)** — Field must be at least n characters
- **MaxLength(Int)** — Field must be at most n characters
- **Url** — Field must be a valid URL
- **Confirmed(String)** — Field must match the value of the specified confirmation field
- **Regex(String)** — Field must match the provided regex pattern
- **RequiredIf(String, String)** — Field is required when another field equals a specific value
- **RequiredUnless(String, String)** — Field is required unless another field equals a specific value
- **In(List(String))** — Field must be one of the provided options
- **NotIn(List(String))** — Field must not be any of the provided options
- **Alpha** — Field must contain only letters
- **AlphaNumeric** — Field must contain only letters and digits
- **StartsWith(String)** — Field must start with the given prefix
- **EndsWith(String)** — Field must end with the given suffix
- **Date** — Field must be a valid date (YYYY-MM-DD)
- **Uuid** — Field must be a valid UUID
- **Ip** — Field must be a valid IP address (IPv4 or IPv6)

**Numeric Rules:**
- **Numeric** — Field must be numeric
- **Min(Int)** — Numeric field must be at least n
- **Max(Int)** — Numeric field must be at most n
- **Between(Int, Int)** — Numeric field must be within the given range (inclusive)
- **Digits(Int)** — Field must have exactly n digits
- **MinDigits(Int)** — Field must have at least n digits
- **MaxDigits(Int)** — Field must have at most n digits

**Database Rules** (available because the `rules` function receives `ctx`):
- **Exists(DbPool, String)** — Field value must exist in the given database table (e.g., `Exists(ctx.app.db, "users")`)
- **Unique(DbPool, String)** — Field value must not already exist in the given database table (e.g., `Unique(ctx.app.db, "users")`)

**File Upload Rules:**
- **FileRequired** — File field must have a file uploaded
- **FileMinSize(Int)** — File must be at least n KB
- **FileMaxSize(Int)** — File must be at most n KB
- **FileExtension(List(String))** — File must have one of the allowed extensions (e.g., `["jpg", "png"]`)

### Custom Validation Rules

Create your own validation rules for domain-specific logic using the `Custom` rule in `app/http/rules`. Use the following command:

```bash
./glimr make_rule no_gmail
```

Add your rule's validation logic:

```gleam
// app/http/rules/no_gmail.gleam
import glimr/http/context.{type Context}
import gleam/string
import glimr/forms/validator.{type FormData}

pub fn run(field: String, value: String, _data: FormData, _ctx: Context(App)) -> Result(Nil, String) {
  case string.contains(value, "gmail") {
    False -> Ok(Nil)
    True -> Error(field <> " cannot be a Gmail address")
  }
}
```

Custom rules receive the full form data, so you can access other field values when you need cross-field validation:

```gleam
// app/http/rules/after_start_date.gleam
import glimr/http/context.{type Context}
import glimr/forms/validator.{type FormData}

pub fn run(field: String, value: String, data: FormData, _ctx: Context(App)) -> Result(Nil, String) {
  case value > data.get("start_date") {
    True -> Ok(Nil)
    False -> Error(field <> " must be after the start date")
  }
}
```

```gleam
// app/http/validators/event_validator.gleam
import app/http/rules/after_start_date
import glimr/forms/validator.{Custom, Required}

fn rules(_ctx) {
  [
    validator.for("start_date", [Required]),
    validator.for("end_date", [
      Required,
      Custom(after_start_date.run),
    ]),
  ]
}
```

Use your custom rule in your validator:

```gleam
// app/http/validators/login_validator.gleam
import app/http/rules/no_gmail
import glimr/forms/validator.{Custom, MinLength, MaxLength, Required}

fn rules(_ctx) {
  [
    validator.for("email", [
      Required,
      MinLength(3),
      MaxLength(255),
      Custom(no_gmail.run),
    ]),

    validator.for("password", [Required]),
  ]
}
```

**Custom validation function signature:**
- `fn(String, String, FormData, Context(App)) -> Result(Nil, String)`
- First argument is the field name
- Second argument is the field's value
- Third argument is the form data — use `data.get("other_field")` to access other fields
- Fourth argument is the context for database lookups, config, etc.
- Return `Ok(Nil)` if validation passes
- Return `Error(message)` with an error message if validation fails

### Custom File Validation Rules

Create custom file validation rules using the `FileCustom` rule in `app/http/rules`. Use the following command:

```bash
./glimr make_rule image_dimensions --file
```

Add your rule's validation logic:

```gleam
// app/http/rules/image_dimensions.gleam
import glimr/http/context.{type Context}
import glimr/forms/form.{type UploadedFile}
import glimr/forms/validator.{type FormData}

pub fn run(field: String, file: UploadedFile, _data: FormData, _ctx: Context(App)) -> Result(Nil, String) {
  case get_image_dimensions(file.path) {
    Ok(#(width, height)) if width >= 100 && height >= 100 -> Ok(Nil)
    Ok(_) -> Error(field <> " must be at least 100x100 pixels")
    Error(_) -> Error(field <> " could not read image dimensions")
  }
}
```

Like string custom rules, file custom rules also receive the full form data for cross-field validation:

```gleam
// app/http/rules/image_dimensions.gleam
import glimr/http/context.{type Context}
import glimr/forms/form.{type UploadedFile}
import glimr/forms/validator.{type FormData}

pub fn run(field: String, file: UploadedFile, data: FormData, _ctx: Context(App)) -> Result(Nil, String) {
  // Use form data to conditionally validate
  case data.get("type") {
    "profile" -> validate_square(file)
    "banner" -> validate_wide(file)
    _ -> Ok(Nil)
  }
}
```

Use your custom rule in your validator:

```gleam
// app/http/validators/avatar_upload.gleam
import app/http/rules/image_dimensions
import glimr/forms/validator.{FileCustom, FileRequired, FileMaxSize}

fn rules(_ctx) {
  [
    validator.for_file("avatar", [
      FileRequired,
      FileMaxSize(2048),
      FileCustom(image_dimensions.run),
    ]),
  ]
}
```

**Custom file validation function signature:**
- `fn(String, UploadedFile, FormData, Context(App)) -> Result(Nil, String)`
- First argument is the field name
- Second argument is the uploaded file
- Third argument is the form data — use `data.get("other_field")` to access other fields
- Fourth argument is the context
- Return `Ok(Nil)` if validation passes
- Return `Error(message)` with an error message if validation fails

### Validation Error Handling

When validation fails, Glimr automatically handles errors based on your route's response format (set by the `expects_html` or `expects_json` middleware in your kernel):

**HTML routes** — flashes the first error for each field into the session as `errors.<field_name>` and redirects back. It also flashes old input values as `old.<field_name>` for non-sensitive fields (fields containing "password", "secret", or "token" in their name, or fields with the `Confirmed` rule, are skipped).

Your templates can use the `session.old`, `session.error`, and `session.has_error` helpers to repopulate inputs and display errors:

```html
---
import glimr/http/context
import glimr/session/session
import app/app.{type App}

props(ctx: context.Context(App))
---

<input type="email" name="email" :value="session.old(ctx.session, 'email')" />

<p l-if="session.has_error(ctx.session, 'email')" class="mt-1 text-sm text-red-600">
  {{ session.error(ctx.session, "email") }}
</p>
```

| Helper | Description |
|--------|-------------|
| `session.old(session, field)` | Returns the old input value for a field, or `""` if none |
| `session.error(session, field)` | Returns the first validation error for a field, or `""` if none |
| `session.has_error(session, field)` | Returns `True` if a validation error exists for a field |

These are shorthand for `session.get_flash(session, "old.<field>")`, `session.get_flash(session, "errors.<field>")`, and `session.has_flash(session, "errors.<field>")` respectively.

**API routes** — returns a `422 Unprocessable Entity` response with a structured JSON body:

```json
{
  "errors": {
    "email": ["Email is required", "Email must be a valid email address"],
    "name": ["Name is required"]
  }
}
```

## Views & Responses

Glimr provides a powerful templating engine called Loom, along with a fluent builder pattern for rendering simple html files. To learn more about Loom, check out the [Loom Template Engine](#loom-template-engine).

### Rendering HTML Files

```gleam
import glimr/http/http.{type Response}
import glimr/response/response

pub fn show(ctx: Context(App)) -> Response {
  response.html_file("welcome.html", 200)
}
```

HTML files are found in `src/resources/views`.

### Rendering Raw HTML

```gleam
import glimr/http/http.{type Response}
import glimr/response/response

pub fn show(ctx: Context(App)) -> Response {
  response.html("<h1>This is raw HTML</h1>", 200)
}
```

## Error Pages

Glimr automatically renders error pages for any HTTP error status (400, 404, 500, etc.). When a response has a 400+ status code, Glimr intercepts it and renders a clean error page instead of returning a blank response.

For **HTML requests**, Glimr looks for a custom error template at `src/resources/views/errors/{status}.html` (e.g. `errors/404.html`). If no custom template exists, a built-in generic error page is rendered. 

For **JSON requests**, a `{"error": "Not Found"}` response is returned automatically.

This works for all error responses.

### Custom Error Pages

To override the default error page for a specific status code, create an HTML file in your views directory:

```
src/resources/views/errors/
├── 404.html    <- custom "not found" page
├── 500.html    <- custom "server error" page
└── 403.html    <- custom "forbidden" page
```

Any status code you don't provide a custom page for will use the built-in default.

### `fail.with()`

You can trigger an error response from anywhere in a request handler using `fail.with()`:

```gleam
import glimr/http/fail
import glimr/http/http.{type Response}

pub fn show(ctx: Context(App), id: String) -> Response {
  let user = case get_user(id) {
    Ok(user) -> user
    Error(_) -> fail.with(404)  // stops execution, renders 404 error page
  }

  // ...
}
```

`fail.with()` raises an internal exception that is caught by the `rescue_crashes` middleware. The request is halted and the appropriate error page is rendered. This is the same mechanism that the `_or_fail` [database query variants](#queries) use under the hood.

### Loom Template Engine

Loom is Glimr's template engine — `.loom.html` files that compile to type-safe Gleam code. But Loom is more than a template engine: templates with event handlers (`l-on:*`) automatically become reactive, establishing a WebSocket connection where all state and logic lives on the server. Inspired by [Phoenix LiveView](https://hexdocs.pm/phoenix_live_view), this server-driven model means you build interactive UIs without writing JavaScript.

Here's how it works:

1. The server renders initial HTML and sends it to the browser — the page loads instantly with full content.
2. A WebSocket connection is established.
3. When the user interacts (clicks a button, types in an input), a small event message is sent over the WebSocket.
4. The server processes the event, updates its state, re-renders the template, and computes a minimal diff.
5. Only the changed parts are sent back and patched into the DOM.

No client-side state management. No full page reloads. The server is the single source of truth.

#### Quick Start

The simplest Loom template is just HTML:

**home.loom.html**
```html
<h1>Hello from Loom</h1>
<p>This is a simple template.</p>
```

This compiles to `src/compiled/loom/home.gleam` with a `render` function. Use it in a controller:

```gleam
// src/app/http/controllers/home_controller.gleam
import compiled/loom/home
import glimr/response/response

/// @get "/"
pub fn show() {
  response.html(home.render(), 200)
}
```

Now let's make it reactive. Here's a counter with server-driven state:

**counter.loom.html:**
```html
---
props(count: Int)
---

<p>Count: {{ count }}</p>
<button l-on:click="count = count - 1">-</button>
<button l-on:click="count = count + 1">+</button>
```

```gleam
// src/app/http/controllers/counter_controller.gleam
import compiled/loom/counter
import glimr/response/response

/// @get "/counter"
pub fn show() {
  response.html(counter.render(count: 0), 200)
}
```

That's it — the `l-on:click` handlers tell the compiler this template is reactive. It automatically establishes a WebSocket connection, and clicks update `count` on the server, which re-renders and patches the DOM.

> **Note:** Reactive templates require the Loom client runtime, which is included automatically via `vite.tags()` in your layout. It handles WebSocket management, DOM patching (via morphdom), and event forwarding.

> **Note:** Creating/modifying/deleting `.loom.html` files automatically triggers compilation when `./glimr run` is running. You can also manually compile with `./glimr loom_compile`.

#### Reactivity

A template becomes reactive when it contains `l-on:*` event handlers or `l-model` directives. No explicit opt-in is needed — the compiler detects these automatically and generates the server-side functions required for WebSocket interactivity.

##### Event Handlers

Event handlers are assignment expressions where the left side is the prop to update and the right side is a Gleam expression:

```html
---
import app/loom/counter

props(count: Int)
---

<p>Count: {{ count }}</p>

<!-- Inline expressions -->
<button l-on:click="count = count + 1">Increment</button>
<button l-on:click="count = count - 1">Decrement</button>
<button l-on:click="count = 0">Reset</button>

<!-- Or call your own functions -->
<button l-on:click="count = counter.inc(count)">Increment</button>
<button l-on:click="count = counter.dec(count)">Decrement</button>
<button l-on:click="count = counter.reset()">Reset</button>
```

The handler expression `count = count + 1` is compiled into a Gleam function that receives the current `count` value, evaluates `count + 1`, and returns the new value. The server re-renders the template with the new state and sends a diff.

**Supported events:** `click`, `input`, `change`, `submit`, `keydown`, `keyup`, `focus`, `blur`.

**Using helper modules:**

```gleam
// app/loom/counter.gleam
pub fn increment(count: Int) -> Int {
  count + 1
}

pub fn add(count: Int, amount: Int) -> Int {
  count + amount
}
```

```html
---
import app/loom/counter

props(count: Int, multiplier: Int)
---

<button l-on:click="count = counter.increment(count)">+</button>
<button l-on:click="count = counter.add(count, multiplier)">+{{ multiplier }}</button>
```

##### Special Variables

Handler expressions can reference browser event data via special variables:

| Variable | Description | Available in |
|----------|-------------|--------------|
| `$value` | Current value of input/select/textarea (`e.target.value`) | `l-on:input`, `l-on:change` |
| `$checked` | Checkbox checked state (`e.target.checked`) | `l-on:change` |
| `$key` | Key pressed (`e.key`) | `l-on:keydown`, `l-on:keyup` |

```html
---
props(
  name: String, 
  enabled: Bool, 
  last_key: String
)
---

<input l-on:input="name = $value" />
<input type="checkbox" l-on:change="enabled = $checked" />
<input l-on:keydown="last_key = $key" />
```

##### Two-Way Binding (l-model)

`l-model` is syntactic sugar for the common input binding pattern:

```html
---
props(name: String, email: String)
---

<!-- These are equivalent -->
<input l-model="name" />
<input :value="name" l-on:input="name = $value" />

<!-- Works with all input types -->
<input type="text" l-model="name" />
<input type="email" l-model="email" />
<textarea l-model="bio"></textarea>
<select l-model="country">
  <option value="us">United States</option>
  <option value="uk">United Kingdom</option>
</select>
```

##### Multiple Prop Updates

Update multiple props at once using tuple destructuring:

```html
---
import app/loom/counter

props(count: Int, total: Int)
---

<button l-on:click="#(count, total) = counter.increment_both(count, total)">
  Increment Both
</button>
```

```gleam
// app/loom/counter.gleam
pub fn increment_both(count: Int, total: Int) -> #(Int, Int) {
  #(count + 1, total + 1)
}
```

##### Event Modifiers

Modifiers control browser-side event behavior:

```html
<!-- Prevent default behavior -->
<form l-on:submit.prevent="errors = form.submit(name, email)">

<!-- Stop propagation -->
<button l-on:click.stop="count = count + 1">

<!-- Debouncing -->
<input l-on:input.debounce-300="query = $value" />
```

| Modifier | Effect |
|----------|--------|
| `.prevent` | Calls `event.preventDefault()` |
| `.stop` | Calls `event.stopPropagation()` |
| `.enter` | Only fires on Enter key |
| `.escape` | Only fires on Escape key |
| `.debounce` | Debounces at 150ms (default) |
| `.debounce-N` | Debounces with custom time in ms |

##### Client-Side JavaScript Reactivity

Loom's event handlers are server-driven by design — all state lives on the server. If you need purely client-side interactivity (dropdowns, modals, toggles, clipboard operations) without a server round-trip, we recommend pairing Loom with a lightweight library like [Alpine.js](https://alpinejs.dev/).

Alpine works seamlessly alongside Loom. Install it in your `app.ts`:

```ts
import Alpine from "alpinejs";
Alpine.start();
```

Then use it in your templates:

```html
<div x-data="{ open: false }">
  <button x-on:click="open = !open">Menu</button>

  <div x-show="open" x-transition>
    <a href="/profile">Profile</a>
    <a href="/settings">Settings</a>
  </div>
</div>
```

Use `l-on:*` for anything that needs server state (form submissions, database updates, authentication) and Alpine's `x-on:*` for instant client-side UI interactions.

#### Loading States

Server-driven reactivity introduces a round-trip between user action and UI update. Loom provides built-in loading state management so users get immediate visual feedback.

When a click or submit event is sent to the server:

- The `l-loading` CSS class is added to the triggering element (style it however you want)
- Buttons are automatically disabled to prevent double-clicks (opt out with `l-no-disable`)
- Both are removed when the server responds

##### Loading Text

Swap the element's text during the round-trip:

```html
<button l-on:click="items = save(items)" l-loading-text="Saving...">
  Save
</button>
```

During the round-trip, the button shows "Saving..." and is disabled. When the server responds, the original text is restored.

##### Loading Indicators

For richer feedback (spinners, icons), use the `l-loading` attribute on child elements. Children with `l-loading` are hidden by default and shown during the loading state, while their siblings are hidden:

```html
<button l-on:click="user.save(data)">
  <span>Save</span>
  <span l-loading>
    <x-spinner /> Saving...
  </span>
</button>
```

When the button is clicked: "Save" is hidden, the spinner with "Saving..." appears. When the server responds, it reverts.

##### Remote Loading Scopes

Loading indicators don't have to live inside the triggering element. Give the trigger an `id` and reference it with `l-loading="thatId"`:

```html
<button id="save-btn" l-on:click="items = save(items)">
  <span>Save</span>
  <span l-loading>Saving...</span>
</button>

<div l-loading="save-btn">
  <span>Items are up to date</span>
  <span l-loading>Saving items...</span>
</div>
```

When the button is clicked, both elements enter loading state. `l-loading` (no value) marks an indicator child; `l-loading="someId"` marks a remote scope. Multiple remote scopes can reference the same trigger.

#### SPA Navigation

Loom includes built-in SPA-like navigation. Link clicks are intercepted, pages are fetched over HTTP, and the DOM is swapped — making page transitions feel instant. The WebSocket stays open across navigations; only components are recycled.

Navigation is enabled automatically when the Loom runtime loads. A link is intercepted when:

- Left-click with no modifier keys
- Same-origin href
- No `target` attribute (or `target="_self"`)
- No `download` attribute
- HTTP/HTTPS protocol
- No `l-no-nav` attribute on the element or any ancestor

Links are prefetched on hover (65ms delay) for instant-feeling navigation. If the fetch fails for any reason, Loom falls back to a normal browser navigation.

##### Opting Out

Add `l-no-nav` to any link or ancestor to force a full page load:

```html
<a href="/download" l-no-nav>Download</a>

<nav l-no-nav>
  <a href="/logout">Log out</a>
  <a href="/download">Download</a>
</nav>
```

GET forms are also intercepted. POST/PUT/DELETE forms always submit normally.

#### Template Syntax

##### Props

Use the `props()` declaration in the frontmatter block at the top of a template to declare typed parameters:

```html
---
props(name: String)
---

<h1>Hello, {{ name }}!</h1>
```

Multiple props are comma-separated:

```html
---
props(
  name: String, 
  age: Int, 
  is_admin: Bool
)
---

<p>{{ name }} is {{ age }} years old.</p>
```

For complex types like lists or custom types, use `import` in the frontmatter to bring them into scope:

```html
---
import app/models/user.{type User}

props(users: List(User), title: String)
---

<h1>{{ title }}</h1>
<div l-for="user in users">{{ user.name }}</div>
```

Pass props as labeled arguments to the generated `render` function:

```gleam
// src/app/http/controllers/home_controller.gleam
import compiled/loom/home
import glimr/response/response

/// @get "/"
pub fn show() {
  response.html(
    home.render(name: "John"),
    200,
  )
}
```

##### Expressions

Use double curly braces to output escaped values. You can use simple variables or full Gleam expressions:

```html
<!-- Simple variables -->
<h1>Hello, {{ name }}!</h1>
<p>Your email is {{ user.email }}</p>

<!-- Gleam expressions with function calls -->
<p>{{ string.uppercase(name) }}</p>
<p>Total: {{ int.to_string(list.length(items)) }}</p>
<p>{{ name |> string.uppercase |> string.trim }}</p>
```

When using function calls, make sure to import the required modules in the frontmatter:

```html
---
import gleam/string
import gleam/list
import gleam/int

props(name: String, items: List(Item))
---

<p>{{ string.uppercase(name) }} has {{ int.to_string(list.length(items)) }} items</p>
```

For unescaped (raw) HTML output, use triple curly braces:

```html
{{{ html_content }}}

{{{ string.concat(["<strong>", name, "</strong>"]) }}}
```

To output literal `{{` or `{{{` on the page, prefix with a backslash:

```html
<p>Use \{{ variable }} for escaped output</p>
<p>Use \{{{ raw }}} for unescaped output</p>
```

##### Imports

Use the `import` declaration in the frontmatter block to import modules into your template. Imports are needed for:
- Custom types referenced in `props()`
- Module functions used in expressions (`{{ }}`, `{{{ }}}`)
- Module functions used in conditions (`l-if`, `l-else-if`)

```html
---
import app/models/user.{type User}
import app/models/post.{type Post, type Category}

props(user: User, posts: List(Post))
---

<h1>{{ user.name }}'s Posts</h1>
<div l-for="post in posts">
  <h2>{{ post.title }}</h2>
</div>
```

Imports and props must appear inside a frontmatter block (`---` delimiters) at the beginning of the template, before any HTML content. You can have multiple `import` declarations:

```html
---
import gleam/option.{type Option}
import app/models/user.{type User}

props(current_user: Option(User))
---

<template l-if="option.is_some(current_user)">
  <p>Welcome back!</p>
</template>
```

**Importing standard library modules for expressions:**

```html
---
import gleam/string
import gleam/list
import gleam/int

props(name: String, items: List(String))
---

<p>{{ string.uppercase(name) }}</p>
<p l-if="list.length(items) > 0">{{ int.to_string(list.length(items)) }} items</p>
```

##### String Literals in Attributes

Gleam uses double quotes for strings, but HTML attributes are already double-quoted. Use single quotes inside expression attributes — they're automatically converted to double quotes during compilation:

```html
<div l-if="name == 'Miguel'">Hey!</div>
<button l-on:click="status = 'active'">Activate</button>
```

This applies to all expression attributes: `l-if`, `l-else-if`, `l-show`, `l-on:*`, `l-for`, `l-model`, and `:prop` bindings.

#### Control Flow

##### Conditionals

Loom uses directive attributes for conditionals. Add `l-if` to any HTML element:

```html
<div l-if="show_welcome" class="welcome">Welcome back!</div>

<a l-if="is_admin" href="/admin">Admin Panel</a>
```

You can use `&&` (and) and `||` (or) operators for complex conditions:

```html
<a l-if="is_logged_in && is_admin" href="/admin">Admin Panel</a>

<p l-if="is_guest || !is_verified">Please verify your account</p>
```

For grouping, use `{}` instead of `()` (Gleam syntax):

```html
<button l-if="is_admin || {is_moderator && has_permission}">Delete</button>
```

Conditions support full Gleam expressions, including function calls:

```html
---
import gleam/list
import gleam/string

props(items: List(Item), name: String)
---

<div l-if="list.length(items) > 0">
  <p>You have {{ int.to_string(list.length(items)) }} items</p>
</div>

<p l-if="list.is_empty(items)">No items yet.</p>

<div l-if="string.length(string.trim(name)) > 0">
  Hello, {{ name }}!
</div>
```

Use `l-else` for fallback content on the next sibling element:

```html
<p l-if="is_logged_in">Welcome back, {{ user.name }}!</p>
<p l-else>Please log in to continue.</p>
```

Use `l-else-if` for multiple conditions:

```html
<div l-if="status == 'success'" class="alert-success">Operation completed!</div>
<div l-else-if="status == 'warning'" class="alert-warning">Please review your input.</div>
<div l-else-if="status == 'error'" class="alert-error">Something went wrong.</div>
<div l-else class="alert-info">No status available.</div>
```

You can chain as many `l-else-if` as needed, and `l-else` at the end is optional:

```html
<x-admin-dashboard l-if="user.role == 'admin'" />
<x-mod-dashboard l-else-if="user.role == 'moderator'" />
<x-member-dashboard l-else-if="user.role == 'member'" />
```

Expressions also work in `l-else-if`:

```html
---
import gleam/list

props(items: List(Item))
---

<p l-if="list.is_empty(items)">No items</p>
<p l-else-if="list.length(items) == 1">One item</p>
<p l-else-if="list.length(items) < 5">A few items</p>
<p l-else>Many items</p>
```

##### Conditional Visibility (l-show)

`l-show` hides an element without removing it from the DOM. Unlike `l-if` which removes the element entirely, `l-show` toggles `display: none`:

```html
<div l-show="count > 0">Count is positive</div>
```

When the condition is false, the element renders with `style="display: none"`. When true, no style is added.

`l-show` merges with existing `:style` attributes:

```html
<div l-show="visible" :style="'color: red'">Styled and toggleable</div>
```

| | `l-if` | `l-show` |
|---|---|---|
| DOM behavior | Removes/adds element entirely | Toggles `display: none` |
| Toggle cost | Higher (full subtree diff) | Lower (style change only) |
| Use when... | Branches are rarely toggled | Elements toggle frequently |

##### Conditional Classes and Styles

Use `:class` and `:style` to conditionally apply CSS classes and inline styles:

```html
<!-- Conditional classes -->
<div :class="['antialias', #('active', is_active), #('font-bold', is_active)]">
  Content
</div>

<!-- Conditional styles -->
<div :style="['color: black', #('color: red', has_error), #('font-weight: bold', True)]">
  Content
</div>
```

Each item is either:
- A static string that's always applied (e.g., `'btn primary'`)
- A conditional tuple `#(String, Bool)` where the string is applied only if the condition is `True`

**Example with mixed static and conditional values:**

```html
<!-- Static "btn" class + conditional "active" class -->
<button :class="['btn', #('active', is_selected)]">
  Click me
</button>

<!-- Static margin + conditional color -->
<div :style="['margin: 0', #('color: red', has_error)]">
  Content
</div>
```

**Using `case` expressions:**

You can use Gleam `case` expressions inside `:class` lists to select classes based on a value:

```html
<button
  :class="[
    'py-2 px-4 font-medium rounded-md',
    case variant {
      'secondary' -> 'bg-gray-200 text-gray-700'
      'danger' -> 'bg-red-500 text-white'
      _ -> 'bg-pink-500 text-white'
    },
  ]"
>
  <slot />
</button>
```

Note: Use `:class` with static strings in the list rather than combining `class` and `:class` attributes.

**Using with loop variables:**

This is particularly useful for zebra striping or highlighting specific rows, you'll learn more about the loop variable in the [Loops](#loops) section:

```html
<tr l-for="item in items, loop" :class="[#('bg-gray-100', loop.even), #('bg-white', loop.odd)]">
  <td>{{ item.name }}</td>
</tr>
```

##### Template Wrapper

When you need to conditionally render multiple elements without a wrapper, use `<template>`:

```html
<template l-if="show_details">
  <h2>Details</h2>
  <p>{{ description }}</p>
  <span>{{ extra_info }}</span>
</template>
```

The `<template>` tag itself is not rendered — only its children appear in the output.

##### Loops

Loom uses an `l-for` directive for loops. The syntax is `item in collection`:

```html
<ul>
  <li l-for="item in items">{{ item.name }} - {{ item.price }}</li>
</ul>
```

Nested loops are supported:

```html
<div l-for="category in categories">
  <h2>{{ category.name }}</h2>
  <p l-for="product in category.products">{{ product.name }}</p>
</div>
```

##### Loop Variable

When you need access to loop metadata (like the current index or whether it's the first/last item), add a loop variable after the collection:

```html
<div l-for="user in users, loop">
  <h2 l-if="loop.first">Users:</h2>

  <p :class='[#("bg-gray", loop.even)]'>
    {{ loop.iteration }}. {{ user.name }}
  </p>

  <p l-if="loop.last">Total: {{ loop.count }} users</p>
</div>
```

The loop variable provides these properties:

| Property | Description |
|----------|-------------|
| `loop.index` | The index of the current iteration (starts at 0) |
| `loop.iteration` | The current iteration number (starts at 1) |
| `loop.first` | Whether this is the first iteration |
| `loop.last` | Whether this is the last iteration |
| `loop.even` | Whether this is an even iteration (0-indexed) |
| `loop.odd` | Whether this is an odd iteration (0-indexed) |
| `loop.count` | The total number of items being iterated |
| `loop.remaining` | The iterations remaining after this one |

**Named loop variables for nested loops:**

Unlike other template engines that require accessing parent loops through a special property, Loom lets you name your loop variables for direct access:

```html
<div l-for="user in users, user_loop">
  <div l-for="post in user.posts, post_loop">
    <h3 l-if="user_loop.first">First user's posts:</h3>
    <p>Post {{ post_loop.iteration }} of {{ post_loop.count }}</p>
  </div>
</div>
```

This is cleaner and more explicit than accessing parent loops through a chain like `loop.parent.first`.

**Combining tuple destructuring with loop variable:**

```html
<tr l-for="(player, points) in scores, loop" :class="[#('striped', loop.odd)]">
  <td>{{ loop.iteration }}</td>
  <td>{{ player }}</td>
  <td>{{ points }}</td>
</tr>
```

> **Note:** Adding a loop variable incurs a small performance cost (O(2n) instead of O(n)) because the list length must be computed upfront. Only add a loop variable when you need the metadata.

##### Tuple Destructuring in Loops

When iterating over a list of tuples, you can destructure them directly:

```html
<!-- For List(#(String, String)) -->
<dl>
  <template l-for="(key, value) in items">
    <dt>{{ key }}</dt>
    <dd>{{ value }}</dd>
  </template>
</dl>

<!-- For List(#(String, String, Int)) -->
<p l-for="(name, description, count) in entries">
  {{ name }}: {{ description }} ({{ count }})
</p>
```

#### Components

Components are reusable template partials. Create them in `src/resources/views/components/` and reference them with the `x-` prefix:

**components/alert.loom.html:**
```html
<div :class="['alert', 'alert-' <> type]">
  <slot />
  <button class="close">&times;</button>
</div>
```

```html
<x-alert>
  Your changes have been saved!
</x-alert>
```

##### Props

Use the `props()` declaration in the frontmatter block to define typed props for your component:

```html
<!-- components/alert.loom.html -->
---
props(dismissable: Bool, type: String)
---

<div :class="['alert', 'alert-' <> type]">
  <slot />
  <button l-if="dismissable" class="close">&times;</button>
</div>
```

Then pass props when using the component:

```html
<x-alert type="success" dismissable>
  Your changes have been saved!
</x-alert>

<x-alert type="error" :dismissable="other_data == 'something'">
  Something went wrong.
</x-alert>
```

##### HTML Attributes

When you add attributes to a component that aren't defined in its `props()`, they're treated as HTML attributes and passed through to the component's root element:

```html
<!-- "type" is a prop, "id" and "class" are HTML attributes -->
<x-alert type="success" id="my-alert" class="mb-4">
  Your changes have been saved!
</x-alert>
```

**Merging behavior:**
- `class` and `style` are **merged** with the root element's existing values
- All other attributes **override** any existing values

**Custom placement with `@attributes`:**

By default, HTML attributes are added to the first element. Use `@attributes` to control where they go:

**components/alert.loom.html:**
```html
<div :class="['alert', 'alert-' <> type]">
  <slot />
  <button @attributes class="close">&times;</button>
</div>
```

##### Slots

Slots are defined in component templates using the `<slot>` element. Use `<slot />` for the default slot and `<slot name="x" />` for named slots:

**components/card.loom.html:**
```html
<div class="card">
  <div class="card-header">
    <slot name="header" />
  </div>
  <div class="card-body">
    <slot />
  </div>
  <div class="card-footer">
    <slot name="footer" />
  </div>
</div>
```

**Using slots when calling the component:**
```html
<x-card>
  <slot name="header">
    <h2>Custom Header</h2>
  </slot>

  <p>This is the main content (default slot).</p>

  <slot name="footer">
    <button>Action</button>
  </slot>
</x-card>
```

##### Slot Fallback Content

Slots can have fallback content that displays when no content is provided:

**components/card.loom.html:**
```html
<div class="card">
  <div class="card-header">
    <slot name="header">
      <h3>Default Header</h3>
    </slot>
  </div>
  <div class="card-body">
    <slot>
      <p class="text-muted">No content provided</p>
    </slot>
  </div>
  <div class="card-footer">
    <slot name="footer">
      <small>Default footer</small>
    </slot>
  </div>
</div>
```

When the component is used without providing content for a slot, the fallback is shown:

```html
<!-- Only provides header, body and footer use fallbacks -->
<x-card>
  <slot name="header">
    <h2>My Custom Header</h2>
  </slot>
</x-card>
```

##### Conditional Slot Rendering

Check if a slot has content using `slot` or `slot.name` in `l-if` conditions:

```html
<div class="card">
  <!-- Only show header wrapper if header content was provided -->
  <div l-if="slot.header" class="card-header">
    <slot name="header" />
  </div>

  <div class="card-body">
    <slot />
  </div>

  <!-- Only show footer wrapper if footer content was provided -->
  <template l-if="slot.footer">
    <div class="card-footer">
      <slot name="footer" />
    </div>
  </template>
</div>
```

- `slot` checks if the default slot has content
- `slot.header` checks if the named slot "header" has content

##### Nested Components

Components can be nested within other components:

```html
<x-card>
  <x-card-header>{{ title }}</x-card-header>
  <x-card-body>
    {{ content }}
  </x-card-body>
</x-card>
```

Organize related components in subdirectories with the `x-deeply:nested:component` syntax:

```html
<x-forms:input type="email" :value="email" />
<x-forms:button>Submit</x-forms:button>
```

##### Layouts

Layouts are just components that wrap your page content. Create a layout in `src/resources/views/components/layouts/`:

**components/layouts/app.loom.html:**
```html
---
import glimr/vite
---

<!DOCTYPE html>
<html>
<head>
  <title>{{ title }}</title>
  {{{ vite.tags("src/resources/ts/app.ts") }}}
</head>
<body>
  <header>
    <nav>...</nav>
  </header>

  <main>
    <slot />
  </main>

  <footer>© 2024</footer>
</body>
</html>
```

Use `<slot />` to mark where child content will be inserted. You can also use named slots:

```html
<header>
  <slot name="header" />
</header>
<main>
  <slot />
</main>
<aside>
  <slot name="sidebar" />
</aside>
```

**Using a layout in a view:**
```html
<x-layouts:app :title="page_title">
  <slot name="header">
    Header content...
  </slot>

  <h1>{{ page_title }}</h1>
  <p>Main slot content...</p>

  <slot name="sidebar">
    Sidebar content...
  </slot>
</x-layouts:app>
```

#### Compiling Templates

Loom files are compiled automatically when running `./glimr build` or `./glimr run` via the `[loom] auto_compile = true` setting in your `glimr.toml`. During `./glimr run`, modified templates are also recompiled on the fly.

You can manually compile all templates with the CLI:

```sh
./glimr loom_compile
```

Or compile a specific file:

```sh
./glimr loom_compile --path=src/resources/views/home.loom.html
```

## Redirects

Glimr's redirect builder provides a clean API for redirecting users with flash messages.

### Basic Redirects

```gleam
import glimr/http/http.{type Response}
import glimr/response/redirect

pub fn store(ctx: Context(App)) -> Response {
  // Process form...

  redirect.to("/contact/success")
}
```

### Redirects with Flash Messages

Flash messages persist data across redirects using the [session flash API](#flash-messages):

```gleam
import glimr/http/http.{type Response}

pub fn store(ctx: Context(App)) -> Response {
  // Process form...
  session.flash(ctx.session, "success", "Contact form submitted!")

  redirect.to("/dashboard")
}
```

### Redirect Back

Redirect users back to the previous page:

```gleam
import glimr/http/http.{type Response}

pub fn cancel(ctx: Context(App)) -> Response {
  redirect.back(ctx)
}
```

## Database

Currently supports sqlite via the [glimr-org/sqlite](https://github.com/glimr-org/sqlite) package (built with `lpil/sqlight`) and postgres via the [glimr-org/postgres](https://github.com/glimr-org/postgres) package (built with `lpil/pog`). Both drivers return a unified `db.DbPool` type from the core framework, so your application code is driver-agnostic — queries, transactions, and connection management all use the same API regardless of the underlying database.

### Setup

#### SQLite

Install the `glimr_sqlite` package:

```bash
gleam add glimr_sqlite
```

Configure a SQLite connection in `config/database.toml`:

```toml
[connections.main]
  driver = "sqlite"
  database = "${DB_DATABASE}"
  pool_size = "${DB_POOL_SIZE}"
```

Run the following command to create a directory for your new database connection. This will contain all migrations, queries, repositories, for this database. In our previous example we set the name to "main", so the command below would create `src/database/main/`. This also creates a database file in `src/database/main/data.db`.

```bash
./glimr setup_database main --sqlite
```

Update your .env variables:

```env
DB_DATABASE=src/database/main/data.db
DB_POOL_SIZE=15
```

Add the pool to your app type in `src/app/app.gleam`:

```gleam
import glimr/db/db.{type DbPool}

pub type App {
  App(
    db: DbPool,
    // ...
  )
}
```

Start the pool in `bootstrap/app.gleam`:

```gleam
import app/app
import glimr_sqlite/sqlite

pub fn start() -> app.App {
  app.App(
    db: sqlite.start("main"),
    // ...
  )
}
```

Use `ctx.app.db` in your controllers:

```gleam
import glimr/http/http.{type Response}

/// @get "/users/:user_id"
pub fn show(ctx: Context(App), user_id: String) -> Response {
  let assert Ok(user_id) = int.parse(user_id)

  case user.find(ctx.app.db, user_id) {
    Ok(user) -> {
      response.html(user_show.render(user: user), 200)
    }
    Error(NotFound) -> response.not_found()
    Error(_) -> response.internal_server_error()
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

Install the `glimr_postgres` package:

```bash
gleam add glimr_postgres
```

Configure a PostgreSQL connection in `config/database.toml`:

```toml
[connections.main]
  driver = "postgres"
  host = "${DB_HOST}"
  port = "${DB_PORT}"
  database = "${DB_DATABASE}"
  username = "${DB_USERNAME}"
  password = "${DB_PASSWORD}"
  pool_size = "${DB_POOL_SIZE}"
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

If you'd rather use a `DB_URL` for your postgres connection, use the `postgres_url` driver instead:

```toml
[connections.main]
  driver = "postgres_url"
  url = "${DB_URL}"
  pool_size = "${DB_POOL_SIZE}"
```

Update your .env variables:

```env
DB_URL=postgres://user@host:port/db_name
DB_POOL_SIZE=15
```

Run the following command to create a directory for your new database connection. This will contain all migrations, queries, repositories, for this database. In our previous example we set the name to "main", so the command below would create `src/database/main/`.

```bash
./glimr setup_database main
```
Add the pool to your app type in `src/app/app.gleam`:

```gleam
import glimr/db/db.{type DbPool}

pub type App {
  App(
    db: DbPool,
    // ...
  )
}
```

Start the pool in `bootstrap/app.gleam`:

```gleam
import app/app
import glimr_postgres/postgres

pub fn start() -> app.App {
  app.App(
    db: postgres.start("main"),
    // ...
  )
}
```

Use `ctx.app.db` in your controllers:

```gleam
import glimr/http/http.{type Response}

/// @get "/users/:user_id"
pub fn show(ctx: Context(App), user_id: String) -> Response {
  let assert Ok(user_id) = int.parse(user_id)

  case user.find(ctx.app.db, user_id) {
    Ok(user) -> {
      response.html(user_show.render(user: user), 200)
    }
    Error(NotFound) -> response.not_found()
    Error(_) -> response.internal_server_error()
}
```

### Multiple Databases

Glimr supports multiple database connections at the same time, even with different drivers! Just add them to `config/database.toml`:

```toml
[connections.main]
  driver = "postgres_url"
  url = "${DB_URL}"
  pool_size = "${DB_POOL_SIZE}"

[connections.analytics]
  driver = "sqlite"
  database = "${DB_ANALYTICS_DATABASE}"
  pool_size = "${DB_ANALYTICS_POOL_SIZE}"
```

Add each pool as a flat field on your app type:

```gleam
import glimr/db/db.{type DbPool}

pub type App {
  App(
    db: DbPool,
    db_analytics: DbPool,
    // ...
  )
}
```

Start them in `bootstrap/app.gleam`:

```gleam
import app/app
import glimr_postgres/postgres
import glimr_sqlite/sqlite

pub fn start() -> app.App {
  app.App(
    db: postgres.start("main"),
    db_analytics: sqlite.start("analytics"),
    // ...
  )
}
```

Use them in your controllers:

```gleam
// your "main" postgres connection pool
ctx.app.db

// your "analytics" sqlite connection pool
ctx.app.db_analytics
```

### Migrations

Glimr provides automatic migration generation by comparing your schema definitions against a stored snapshot. It detects changes and generates driver-specific SQL for PostgreSQL or SQLite.

#### Defining Schemas

Start by creating a data model using the following command:

```bash
./glimr make_model user
```

This creates a `user/` folder inside your default database directory `src/database/main/models/`. The folder contains `user_schema.gleam` for defining your table schema, and a `queries/` folder with pre-generated CRUD queries that get compiled into fully typed gleam code. You can add custom queries to this folder as well (see [Queries](#queries) section).

The `make:model` command defines your default connection as the very first one in your `config/database.toml`. All other commands that accept the `--database` flag define it as the first of its driver type instead.

If you need to specify the connection folder you can always pass a `--database` flag:

```bash
./glimr make_model user --database=analytics
```

This creates a `user/` folder inside `src/database/analytics/models/`.

Define the user schema for your migrations:

```gleam
// src/database/main/models/user/user_schema.gleam
import glimr/db/schema

pub const table_name = "users"

pub fn definition() {
  schema.table(table_name, [
    schema.id(),
    schema.foreign("organization_id", "organizations")
      |> schema.nullable()
      |> schema.on_delete(schema.Cascade),
    schema.string("email"),
    schema.string("name"),
    schema.text("bio") |> schema.nullable(),
    schema.boolean("is_admin") |> schema.default_bool(False),
    schema.enum("role", ["admin", "editor", "viewer"]),
    schema.decimal("balance", 10, 2) |> schema.nullable(),
    schema.blob("avatar_data") |> schema.nullable(),
    schema.time("starts_at") |> schema.nullable(),
    schema.unix_timestamps(),
  ])
  |> schema.indexes([
    schema.unique(["email"]),
    schema.index(["name", "role"]),
  ])
}
```

#### Available Column Types

| Function | PostgreSQL | SQLite | Gleam Type |
|----------|------------|--------|------------|
| `schema.id()` | `SERIAL PRIMARY KEY` | `INTEGER PRIMARY KEY AUTOINCREMENT` | `Int` |
| `schema.uuid("name")` | `UUID` | `TEXT` | `String` |
| `schema.string("name")` | `VARCHAR(255)` | `TEXT` | `String` |
| `schema.string_sized("name", 100)` | `VARCHAR(100)` | `TEXT` | `String` |
| `schema.text("name")` | `TEXT` | `TEXT` | `String` |
| `schema.int("name")` | `INTEGER` | `INTEGER` | `Int` |
| `schema.smallint("name")` | `SMALLINT` | `INTEGER` | `Int` |
| `schema.bigint("name")` | `BIGINT` | `INTEGER` | `Int` |
| `schema.float("name")` | `DOUBLE PRECISION` | `REAL` | `Float` |
| `schema.boolean("name")` | `BOOLEAN` | `INTEGER` | `Bool` |
| `schema.timestamp("name")` | `TIMESTAMP` | `TEXT` | `String` |
| `schema.unix_timestamp("name")` | `BIGINT` | `INTEGER` | `Int` |
| `schema.date("name")` | `DATE` | `TEXT` | `String` |
| `schema.json("name")` | `JSONB` | `TEXT` | `String` |
| `schema.foreign("user_id", "users")` | `INTEGER REFERENCES users(id)` | `INTEGER` | `Int` |
| `schema.enum("status", ["active", "inactive"])` | `CREATE TYPE` + type name | `TEXT` + `CHECK` constraint | Custom Gleam type |
| `schema.decimal("price", 10, 2)` | `NUMERIC(10, 2)` | `TEXT` | `String` |
| `schema.blob("data")` | `BYTEA` | `BLOB` | `BitArray` |
| `schema.time("starts_at")` | `TIME` | `TEXT` | `String` |
| `schema.timestamps()` | Creates `created_at` and `updated_at` | | |
| `schema.unix_timestamps()` | Creates `created_at` and `updated_at` as integers | | |
| `schema.soft_deletes()` | Creates nullable `deleted_at` timestamp | | |

#### Column Modifiers

```gleam
// Make a column nullable (default is NOT NULL)
schema.string("bio") |> schema.nullable()

// Set default values
schema.boolean("active") |> schema.default_bool(True)
schema.string("role") |> schema.default_string("user")
schema.int("count") |> schema.default_int(0)
schema.float("rate") |> schema.default_float(0.0)
schema.timestamp("published_at") |> schema.default_now()
schema.unix_timestamp("created_at") |> schema.default_unix_now()
schema.uuid("external_id") |> schema.auto_uuid()
schema.string("deleted_at") 
  |> schema.nullable() 
  |> schema.default_null()

// Array columns
schema.string("tags") |> schema.array()

// nested: List(List(Int))
schema.int("scores") 
  |> schema.array() 
  |> schema.array()  

// Array with default
schema.string("tags") 
  |> schema.array() 
  |> schema.default_empty_array()

// Foreign key actions
schema.foreign("user_id", "users")
  |> schema.on_delete(schema.Cascade)
  |> schema.on_update(schema.Restrict)

// Enum with custom type name override
schema.enum("status", ["active", "inactive"]) |> schema.enum_name("user_status")
```

| Modifier | Description |
|----------|-------------|
| `\|> schema.nullable()` | Allow NULL values (default is NOT NULL) |
| `\|> schema.default_bool(True)` | Set a boolean default value |
| `\|> schema.default_string("value")` | Set a string default value |
| `\|> schema.default_int(0)` | Set an integer default value |
| `\|> schema.default_float(0.0)` | Set a float default value |
| `\|> schema.default_now()` | Default to current timestamp |
| `\|> schema.default_unix_now()` | Default to current Unix timestamp |
| `\|> schema.auto_uuid()` | Default to auto-generated UUID |
| `\|> schema.default_null()` | Default to NULL (use with `schema.nullable()`) |
| `\|> schema.default_empty_array()` | Default to empty array (`'{}'` in Postgres, `'[]'` in SQLite) |
| `\|> schema.array()` | Wrap column type as an array (chainable for nesting) |
| `\|> schema.on_delete(schema.Cascade)` | Set foreign key ON DELETE action |
| `\|> schema.on_update(schema.Restrict)` | Set foreign key ON UPDATE action |
| `\|> schema.enum_name("custom")` | Override auto-generated enum type name |
| `\|> schema.rename_from("old_name")` | Track column rename for migrations |

##### Array Columns

Any column type can be wrapped with the `schema.array()` modifier to create an array column:

| Example | PostgreSQL | SQLite | Gleam Type |
|---------|------------|--------|------------|
| `schema.string("tags") \|> schema.array()` | `VARCHAR(255)[]` | `TEXT` (JSON) | `List(String)` |
| `schema.int("scores") \|> schema.array()` | `INTEGER[]` | `TEXT` (JSON) | `List(Int)` |
| `schema.int("matrix") \|> schema.array() \|> schema.array()` | `INTEGER[][]` | `TEXT` (JSON) | `List(List(Int))` |
| `schema.float("coords") \|> schema.array() \|> schema.nullable()` | `DOUBLE PRECISION[]` | `TEXT` (JSON) | `Option(List(Float))` |

Array columns use native PostgreSQL arrays and are transparently stored as JSON in SQLite. The generated decoders handle both formats automatically.

##### Enum Columns

Enum columns generate a Gleam custom type with compile-time safety instead of raw strings:

```gleam
schema.enum("status", ["active", "inactive", "banned"])
```

This generates:

```gleam
pub type Status {
  Active
  Inactive
  Banned
}

pub fn status_to_string(value: Status) -> String {
  case value {
    Active -> "active"
    Inactive -> "inactive"
    Banned -> "banned"
  }
}

pub fn status_from_string(value: String) -> Result(Status, Nil) {
  case value {
    "active" -> Ok(Active)
    "inactive" -> Ok(Inactive)
    "banned" -> Ok(Banned)
    _ -> Error(Nil)
  }
}
```

The model type uses the generated custom type (`status: Status`) instead of `String`. The type name is derived from the column name in PascalCase. Use `|> schema.enum_name("custom_name")` to override it.

On PostgreSQL, enums use `CREATE TYPE ... AS ENUM (...)`. On SQLite, they use `TEXT` with a `CHECK` constraint.

##### Foreign Key Actions

Foreign key columns support `ON DELETE` and `ON UPDATE` actions:

```gleam
import glimr/db/schema

schema.foreign("user_id", "users")
  |> schema.on_delete(schema.Cascade)
  |> schema.on_update(schema.Restrict)
```

| Action | SQL |
|--------|-----|
| `schema.Cascade` | `CASCADE` |
| `schema.Restrict` | `RESTRICT` |
| `schema.SetNull` | `SET NULL` |
| `schema.SetDefault` | `SET DEFAULT` |
| `schema.NoAction` | `NO ACTION` |

#### Indexes

Define indexes by piping `indexes()` onto your table definition:

```gleam
import glimr/db/schema

schema.table(table_name, [
  schema.id(),
  schema.string("email"),
  schema.string("first_name"),
  schema.string("last_name"),
])
|> schema.indexes([
  schema.unique(["email"]),
  schema.index(["first_name", "last_name"]),
  schema.index(["email"]) |> schema.named("idx_users_email_lookup"),
])
```

| Function | Description |
|----------|-------------|
| `schema.index(["col"])` | Regular index on a single column |
| `schema.index(["col1", "col2"])` | Composite index on multiple columns |
| `schema.unique(["col"])` | Unique index on a single column |
| `schema.unique(["col1", "col2"])` | Composite unique index |

#### Index Modifiers

| Modifier | Description |
|----------|-------------|
| `\|> schema.named("name")` | Custom index name (default: `idx_{table}_{col1}_{col2}`) |

#### Generating Migrations

Run the migration generator:

```bash
# for your default connection
./glimr db_gen

# for a named connection
./glimr db_gen --database=analytics
```

This will:
1. Scan schema files in `src/database/{connection_name}/models/`
2. Compare against the stored snapshot (`._schema_snapshot.json`)
3. Detect changes (new tables, dropped tables, column changes, index changes)
4. Generate SQL in `src/database/{connection_name}/_migrations/{timestamp}_migration.sql`
5. Update the snapshot for the next run

You can also run the following command to generate migrations and also run them:

```bash
# for your default connection
./glimr db_gen --migrate

# for a named connection
./glimr db_gen --database=analytics --migrate
```

Additionally, you can generate migrations/queries for a specific model or multiple models by passing the `--model` flag:

```bash
# for your default connection
./glimr db_gen --model=user,post

# for a named connection
./glimr db_gen --database=analytics --model=user,post
```

#### Renaming Columns

To rename a column without losing data, use the `schema.rename_from` modifier:

```gleam
schema.string("email_address") |> schema.rename_from("email")
```

This generates `ALTER TABLE ... RENAME COLUMN` instead of drop/add. The `schema.rename_from` modifier is automatically removed from your schema file after the migration is generated.

#### Running Migrations

Generated migrations are plain SQL files. Run them with the following command:

```bash
# for your default connection
./glimr migrate

# for a named connection
./glimr migrate --database=analytics
```

#### Rolling Back Migrations

Glimr takes a forward-only approach to migrations. Instead of rollbacks, simply generate a new migration to reverse any changes. This keeps your migration history explicit and auditable.

#### Dropping Tables

To drop a database table, simply delete the model from the `src/database/{connection}/models/` folder. For example, if your model is called `user` in your main connection, delete the `src/database/main/models/user/` folder. Finally, regenerate migrations and rerun them. This will create a new migration to drop the table.

### Queries

Each model includes a `queries/` folder with pre-generated CRUD queries. These are plain SQL files, so you get full SQL language support, autocomplete, and linting from your editor's SQL LSP.

#### Generated CRUD Queries

When you create a model with the `./glimr make_model` command, the following query files are generated for you:

```
src/database/main/models/user/queries/
├── create.sql
├── delete.sql
├── find.sql
├── list.sql
└── update.sql
```

You can modify these queries to fit your needs or delete any you don't need.

#### Creating Custom Queries

Add new `.sql` files to the `queries/` folder for custom queries:

```sql
-- src/database/main/models/user/queries/by_email.sql
SELECT * FROM users WHERE email = $1;
```

```sql
-- src/database/main/models/user/queries/list_active.sql
SELECT * FROM users WHERE is_active = true ORDER BY created_at DESC;
```

#### Query Naming Convention

The file name prefix determines whether the query returns a single row or multiple rows:

| Prefix | Returns | Gleam Return Type |
|--------|---------|-------------------|
| `list` or `list_*` | Multiple rows | `Result(List(User), DbError)` |
| Anything else | Single row | `Result(User, DbError)` |

**Examples:**
- `find.sql` → returns `Result(User, DbError)`
- `by_email.sql` → returns `Result(User, DbError)`
- `list.sql` → returns `Result(List(User), DbError)`
- `list_active.sql` → returns `Result(List(User), DbError)`
- `list_by_role.sql` → returns `Result(List(User), DbError)`

#### Generating the Repository

After adding or modifying queries, run:

```bash
# for your default connection
./glimr db_gen

# for a named connection
./glimr db_gen --database=analytics
```

This generates a fully-typed repository file with Gleam functions for each query. Every query generates **four functions**:

| Function | Accepts | Returns | Use Case |
|----------|---------|---------|----------|
| `find(pool, id)` | Pool | `Result(User, DbError)` | Standard queries with error handling |
| `find_wc(conn, id)` | Connection | `Result(User, DbError)` | Inside transactions |
| `find_or_fail(pool, id)` | Pool | `User` | HTTP handlers — fails with appropriate status on error |
| `find_or_fail_wc(conn, id)` | Connection | `User` | Transactions in HTTP handlers |

The `_or_fail` variants unwrap the result automatically. On error, they halt the request and render the appropriate [error page](#error-pages) — 404 for not found, 503 for connection issues, 500 for everything else. This is the most convenient option for HTTP handlers where you'd otherwise just convert the error to a status code anyway.

If the request is expecting a json response, it will instead return the appropriate  error message as json.

```gleam
// src/database/main/models/user/gen/user.gleam (auto-generated)

// Default functions - return Result for explicit error handling
pub fn find(pool, id) -> Result(User, DbError)
pub fn by_email(pool, email) -> Result(User, DbError)
pub fn list(pool) -> Result(List(User), DbError)

// With-connection variants - for use inside transactions
pub fn find_wc(conn, id) -> Result(User, DbError)
pub fn by_email_wc(conn, email) -> Result(User, DbError)
pub fn list_wc(conn) -> Result(List(User), DbError)

// Or-fail variants - unwrap result or halt with HTTP status
pub fn find_or_fail(pool, id) -> User
pub fn by_email_or_fail(pool, email) -> User
pub fn list_or_fail(pool) -> List(User)

// Or-fail with-connection variants
pub fn find_or_fail_wc(conn, id) -> User
pub fn by_email_or_fail_wc(conn, email) -> User
pub fn list_or_fail_wc(conn) -> List(User)
```

#### Connection Pooling

Glimr manages a pool of database connections to efficiently handle concurrent requests. The pool is initialized in your app state in `bootstrap/app.gleam`.

You can specify the pool size by setting the `DB_POOL_SIZE` env variable, and the config value for your connection in `config/database.toml`. It defaults to 15.

**How it works:**

When you call a query function like `user.find(ctx.app.db, id)`, it automatically:
1. Checks out a connection from the pool
2. Executes the query
3. Returns the connection to the pool
4. Returns the result

This means each query holds a connection only for the duration of the query itself, maximizing pool efficiency.

#### Using Queries in Controllers

The `_or_fail` variants are the most convenient for HTTP handlers — they return values directly and automatically render the appropriate [error page](#error-pages) on failure:

```gleam
import database/models/user/gen/user
import glimr/http/http.{type Response}

pub fn show(ctx: Context(App), id: String) -> Response {
  let assert Ok(user_id) = int.parse(id)
  let user = user.find_or_fail(ctx.app.db, user_id)

  response.html(user_show.render(user: user), 200)
}
```

**List queries:**

```gleam
import database/models/user/gen/user
import glimr/http/http.{type Response}

pub fn index(ctx: Context(App)) -> Response {
  let users = user.list_or_fail(ctx.app.db)
  let count = int.to_string(list.length(users))

  response.html(user_index.render(count: count), 200)
}
```

When you need explicit error handling (e.g. showing a custom error page, or in background jobs), use the default variants which return `Result`:

```gleam
import database/models/user/gen/user
import glimr/db/db.{NotFound}
import glimr/http/http.{type Response}

pub fn show(ctx: Context(App), id: String) -> Response {
  let assert Ok(user_id) = int.parse(id)

  case user.find(ctx.app.db, user_id) {
    Ok(user) -> {
      response.html(user_show.render(user: user), 200)
    }
    Error(NotFound) -> response.not_found()
    Error(_) -> response.internal_server_error()
  }
}
```

#### Inline Queries

Sometimes you need a quick one-off query without creating a `.sql` file and regenerating. The `db` module provides `query_one`, `query_all`, and `exec` for this:

**Fetching a single row with `db.query_one`:**

```gleam
import gleam/dynamic/decode
import glimr/db/db

pub fn count_active_users(ctx: Context(App)) -> Result(Int, db.DbError) {
  db.query_one(
    ctx.app.db,
    "SELECT COUNT(*) FROM users WHERE is_active = $1",
    [db.bool(True)],
    decode.at([0], decode.int),
  )
}
```

`query_one` returns `Ok(row)` for exactly one row, `Error(NotFound)` for zero rows, or `Error(QueryError(...))` if multiple rows are returned.

**Fetching multiple rows with `db.query_all`:**

```gleam
import gleam/dynamic/decode
import glimr/db/db

pub fn admin_emails(ctx: Context(App)) -> Result(List(#(String, Int)), db.DbError) {
  db.query_all(
    ctx.app.db,
    "SELECT email, created_at FROM users WHERE role = $1",
    [db.string("admin")],
    {
      use email <- decode.field(0, decode.string)
      use created_at <- decode.field(1, decode.int)
      decode.success(#(email, created_at))
    },
  )
}
```

**Writing data with `db.exec`:**

```gleam
import glimr/db/db

pub fn deactivate_old_users(ctx: Context(App), cutoff: Int) -> Result(Int, db.DbError) {
  db.exec(
    ctx.app.db,
    "UPDATE users SET is_active = $1 WHERE last_login_at < $2",
    [db.bool(False), db.int(cutoff)],
  )
  // Returns Ok(row_count) — the number of rows affected
}
```

**INSERT with RETURNING using `db.query_one`:**

```gleam
pub fn create_token(ctx: Context(App), user_id: Int) -> Result(String, db.DbError) {
  db.query_one(
    ctx.app.db,
    "INSERT INTO tokens (user_id) VALUES ($1) RETURNING token",
    [db.int(user_id)],
    decode.at([0], decode.string),
  )
}
```

Inside transactions, use the `_wc` (with-connection) variants — `db.query_one_wc`, `db.query_all_wc` — which accept a `Connection` instead of a pool. The lower-level `db.query` and `db.query_with` are still available when you need access to the full `QueryResult(count, rows)`.

**Available parameter helpers:**

| Helper | Type | Example |
|--------|------|---------|
| `db.string(value)` | `String` | `db.string("hello")` |
| `db.int(value)` | `Int` | `db.int(42)` |
| `db.float(value)` | `Float` | `db.float(3.14)` |
| `db.bool(value)` | `Bool` | `db.bool(True)` |
| `db.null()` | `Nil` | `db.null()` |
| `db.blob(value)` | `BitArray` | `db.blob(<<1, 2, 3>>)` |

> **Note:** Always use `$1`, `$2`, etc. for placeholders — Glimr automatically converts them to `?` when running against SQLite, so your queries work with both drivers.

#### Database Transactions

For operations that must succeed or fail together, use transactions. They automatically:
- Check out a connection from the pool
- Begin a transaction
- Commit on success or roll back on error
- Return the connection to the pool
- Retry on deadlock (with configurable retry count)

Transactions are provided by the core `db` module and work with any database driver:

```gleam
import glimr/db/db.{type DbError}

pub fn transfer(
  ctx: Context,
  from_id: Int,
  to_id: Int,
  amount: Int,
) -> Result(Nil, DbError) {
  use conn <- db.transaction(ctx.app.db, 3)

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
import glimr/db/db
import glimr/http/http.{type Response}

pub fn store(ctx: Context(App)) -> Response {
  use validated <- transfer_request.validate(ctx)

  case {
    use conn <- db.transaction(ctx.app.db, 3)
    use _ <- result.try(account_repository.debit_wc(conn, validated.from_id, validated.amount))
    use _ <- result.try(account_repository.credit_wc(conn, validated.to_id, validated.amount))
    Ok(Nil)
  } {
    Ok(_) -> {
      redirect.to("/transfers/success")
    }
    Error(_) -> {
      session.flash(ctx.session, "error", "Transfer failed")
      redirect.to("/transfers")
    }
  }
}
```

> **Note:** Use the `_wc` (with connection) variants of repository functions inside transactions. These accept a `Connection` instead of a `Pool`, allowing all operations to share the same transactional connection.

## Cache

Glimr provides a unified caching API with support for multiple storage backends: file-based caching, SQLite database, and PostgreSQL database. Each driver implements the same operations, making it easy to swap backends without changing application code.

### Store Types

Cache stores are configured in `config/cache.toml`. There are three store types:

```toml
# File-based cache - stores entries as files on disk
[stores.file]
  driver = "file"
  path = "priv/storage/framework/cache/data"

# Database-backed cache - uses your existing database
[stores.database]
  driver = "database"
  database = "main"
  table = "cache"

# Redis cache - stores entries in Redis or compatible kv store
[stores.redis]
  driver = "redis"
  url = "${REDIS_URL}"
  pool_size = "${REDIS_POOL_SIZE}"
```

### File Store

The file store caches values as files on disk using a SHA256 hash-based directory structure for efficient filesystem access.

**Setup:**

The file cache is included with the core `glimr` package. No additional dependencies needed.

Set up the store in `config/cache.toml`:

```toml
[stores.main]
  driver = "file"
  path = "priv/storage/framework/cache/data"
```

Start the cache in `bootstrap/app.gleam`:

```gleam
import glimr/cache/file_cache

pub fn start() -> app.App {
  app.App(
    cache: file_cache.start("main"),
    // ...
  )
}
```

Use it in your controllers:

```gleam
import glimr/cache/cache
import glimr/http/http.{type Response}

pub fn show(ctx: Context(App)) -> Response {
  case cache.get(ctx.app.cache, "user:123") {
    Ok(value) -> // use cached value
    Error(cache.NotFound) -> // cache miss, compute value
    Error(_) -> response.internal_server_error()
  }
}
```

### Redis Store

The Redis store provides high-performance caching using Redis as the backend. It also works with Redis-compatible alternatives like Valkey, KeyDB, and Dragonfly.

**Setup:**

Install `glimr_redis`:

```bash
gleam add glimr_redis
```

Set up the store in `config/cache.toml`:

```toml
[stores.main]
  driver = "redis"
  url = "${REDIS_URL}"
  pool_size = "${REDIS_POOL_SIZE}"
```

Set your `.env` variables:

```env
REDIS_URL=redis://localhost:6379
REDIS_POOL_SIZE=10
```

Start the cache in `bootstrap/app.gleam`:

```gleam
import glimr_redis/redis

pub fn start() -> app.App {
  app.App(
    cache: redis.start("main"),
    // ...
  )
}
```

Use it in your controllers:

```gleam
import glimr/cache/cache
import glimr/http/http.{type Response}

pub fn show(ctx: Context(App)) -> Response {
  case cache.get(ctx.app.cache, "user:123") {
    Ok(value) -> // use cached value
    Error(cache.NotFound) -> // cache miss
    Error(_) -> response.internal_server_error()
  }
}
```

**Redis-Compatible Alternatives:**

The Redis driver works with any Redis-compatible server:

- **[Valkey](https://valkey.io/)** - Open-source Redis fork maintained by the Linux Foundation
- **[KeyDB](https://docs.keydb.dev/)** - Multi-threaded Redis fork with higher throughput
- **[Dragonfly](https://dragonflydb.io/)** - Modern in-memory datastore with Redis compatibility

All of these use port 6379 by default, so no configuration changes are needed — just point `REDIS_URL` at your server.

### Database Store (SQLite)

The SQLite database store caches values in a database table, ideal when you already have SQLite set up and want to avoid additional infrastructure.

**Setup:**

Ensure you have `glimr_sqlite` installed:

```bash
gleam add glimr_sqlite
```

Set up the store in `config/cache.toml`:

```toml
[stores.database]
  driver = "database"
  database = "main"
  table = "cache"
```

Start the cache in `bootstrap/app.gleam`:

```gleam
import app/app
import glimr_sqlite/sqlite

pub fn start() -> app.App {
  let db = sqlite.start("main")

  app.App(
    db: db,
    cache: sqlite.start_cache(db, "database"),
    // ...
  )
}
```

Generate and run the cache table migration:

```bash
# Generate the migration
./glimr make_cache_table

# Or generate and run migrations in one step
./glimr make_cache_table --migrate
```

Use it in your controllers:

```gleam
import glimr/cache/cache
import glimr/http/http.{type Response}

pub fn show(ctx: Context(App)) -> Response {
  case cache.get(ctx.app.cache, "user:123") {
    Ok(value) -> // use cached value
    Error(cache.NotFound) -> // cache miss
    Error(_) -> response.internal_server_error()
  }
}
```

### Database Store (PostgreSQL)

The PostgreSQL database store caches values in a database table, ideal when you already have PostgreSQL set up.

**Setup:**

Ensure you have `glimr_postgres` installed:

```bash
gleam add glimr_postgres
```

Set up the store in `config/cache.toml`:

```toml
[stores.database]
  driver = "database"
  database = "main"
  table = "cache"
```

Start the cache in `bootstrap/app.gleam`:

```gleam
import app/app
import glimr_postgres/postgres

pub fn start() -> app.App {
  let db = postgres.start("main")

  app.App(
    db: db,
    cache: postgres.start_cache(db, "database"),
    // ...
  )
}
```

Generate and run the cache table migration:

```bash
# Generate the migration
./glimr make_cache_table

# Or generate and run migrations in one step
./glimr make_cache_table --migrate
```

Use it in your controllers:

```gleam
import glimr/cache/cache
import glimr/http/http.{type Response}

pub fn show(ctx: Context(App)) -> Response {
  case cache.get(ctx.app.cache, "user:123") {
    Ok(value) -> // use cached value
    Error(cache.NotFound) -> // cache miss
    Error(_) -> response.internal_server_error()
  }
}
```

### Using the Cache

All cache backends share the same unified API through a single import:

```gleam
import glimr/cache/cache
```

The `CachePool` type returned by all backends (`file_cache.start`, `redis.start`, `postgres.start_cache`, `sqlite.start_cache`) is driver-agnostic — you use the same `cache.get`, `cache.put`, etc. regardless of which backend is active.

### Cache Operations

All cache drivers support these operations:

| Operation | Description |
|-----------|-------------|
| `get(pool, key)` | Get a value by key |
| `put(pool, key, value, ttl)` | Store with TTL (seconds) |
| `put_forever(pool, key, value)` | Store without expiration |
| `forget(pool, key)` | Delete a key |
| `has(pool, key)` | Check if key exists |
| `flush(pool)` | Delete all cached values |
| `pull(pool, key)` | Get and delete in one operation |
| `increment(pool, key, by)` | Increment numeric value |
| `decrement(pool, key, by)` | Decrement numeric value |
| `remember(pool, key, ttl, fn)` | Get or compute and cache |
| `remember_forever(pool, key, fn)` | Get or compute (no expiration) |

**JSON operations** (for structured data):

| Operation | Description |
|-----------|-------------|
| `get_json(pool, key, decoder)` | Get and decode JSON |
| `put_json(pool, key, value, encoder, ttl)` | Encode and store JSON |
| `put_json_forever(pool, key, value, encoder)` | Store JSON permanently |
| `remember_json(pool, key, ttl, decoder, fn, encoder)` | Get or compute JSON |

**Database-only operations** (via `glimr/cache/database`):

| Operation | Description |
|-----------|-------------|
| `create_table(db_pool, table)` | Create the cache table |
| `cleanup_expired(db_pool, table)` | Remove expired entries |

#### Basic Usage

```gleam
import glimr/cache/cache

// Store a value for 1 hour (3600 seconds)
cache.put(ctx.app.cache, "user:123:name", "Alice", 3600)

// Get a value
case cache.get(ctx.app.cache, "user:123:name") {
  Ok(name) -> io.println("Hello, " <> name)
  Error(cache.NotFound) -> io.println("Cache miss")
  Error(_) -> io.println("Cache error")
}

// Store permanently
cache.put_forever(ctx.app.cache, "config:site_name", "My App")

// Delete a value
cache.forget(ctx.app.cache, "user:123:name")

// Check existence
case cache.has(ctx.app.cache, "user:123:name") {
  True -> io.println("Cached")
  False -> io.println("Not cached")
}
```

#### JSON Caching

The cache stores strings, so to cache structured data you need to provide an encoder and decoder. Generated models include `encoder()` and `decoder()` functions for JSON out of the box:

```gleam
// Store JSON — uses the generated encoder/decoder
cache.put_json(ctx.app.cache, "user:123", user, user.encoder(), 3600)

// Retrieve JSON
case cache.get_json(ctx.app.cache, "user:123", user.decoder()) {
  Ok(user) -> {} // use user
  Error(cache.NotFound) -> {} // cache miss
  Error(cache.SerializationError(_)) -> {} // invalid JSON
  Error(_) -> {} // other error
}
```

For non-generated types, you can write encoder and decoder functions by hand:

```gleam
import gleam/dynamic/decode
import gleam/json

let my_encoder = fn(item: MyType) {
  json.object([
    #("id", json.int(item.id)),
    #("name", json.string(item.name)),
  ])
}

let my_decoder = {
  use id <- decode.field("id", decode.int)
  use name <- decode.field("name", decode.string)
  decode.success(MyType(id: id, name: name))
}
```

#### Remember Pattern

The remember pattern gets a value from cache, or computes and stores it if missing. The compute callback is only called on a cache miss — its return value gets cached and returned directly.

Use `remember` for string values:

```gleam
let cache_key = "user:" <> id <> ":name"

// Remember a string value for 1 hour
let name = {
  use <- cache.remember(ctx.app.cache, cache_key, 3600)
  user.find_or_fail(ctx.app.db, id).name
}

// Remember forever (only cleared by forget or flush)
let name = {
  use <- cache.remember_forever(ctx.app.cache, cache_key)
  user.find_or_fail(ctx.app.db, id).name
}
```

Use `remember_json` for structured data — the compute callback goes last so you can use `use <-` syntax:

```gleam
// Remember a JSON object for 1 hour
let user = {
  use <- cache.remember_json(
    ctx.app.cache,
    "user:" <> id,
    3600,
    user.decoder(),
    user.encoder(),
  )

  user.find_or_fail(ctx.app.db, id)
}

// Remember a JSON object forever
let user = {
  use <- cache.remember_json_forever(
    ctx.app.cache,
    "user:" <> id,
    user.decoder(),
    user.encoder(),
  )

  user.find_or_fail(ctx.app.db, id)
}

// Handle errors yourself inside the callback
let user = {
  use <- cache.remember_json(
    ctx.app.cache,
    "user:" <> id,
    3600,
    user.decoder(),
    user.encoder(),
  )
  case user.find(ctx.app.db, id) {
    Ok(user) -> user
    Error(_) -> User(name: "Guest", email: "")
  }
}
```

#### Increment/Decrement

For counters and rate limiting:

```gleam
// Increment page view counter
let assert Ok(views) = cache.increment(ctx.app.cache, "page:home:views", 1)

// Rate limiting example
let rate_key = "rate:" <> user_id <> ":" <> current_minute()
case cache.increment(ctx.app.cache, rate_key, 1) {
  Ok(count) if count > 100 -> Error("Rate limit exceeded")
  Ok(_) -> Ok("Allowed")
  Error(_) -> Ok("Allowed") // fail open
}
```

#### Cache Errors

All cache operations return `Result(value, CacheError)`:

```gleam
import glimr/cache/cache.{type CacheError, NotFound, SerializationError, ConnectionError}

case cache.get(pool, key) {
  Ok(value) -> // success
  Error(NotFound) -> // key doesn't exist or expired
  Error(SerializationError(msg)) -> // JSON decode/encode failed
  Error(ConnectionError(msg)) -> // storage backend error
}
```

## Console Commands

Glimr provides a console command system (Similar to Laravel's artisan) for running tasks from the command line. Commands are defined using a fluent API and can optionally receive database access.

### Creating Commands

Create a new command using the following command:

```bash
./glimr make_command app_send_emails
```

Custom commands are preferred to have a prefix like `app_` or the package name as a prefix to avoid naming collisions, but it's not required.

This creates `src/app/console/commands/app_send_emails.gleam`:

```gleam
import glimr/console/command.{type Command, type Args}

const description = "Command description"

pub fn command() -> Command {
  command.new()
  |> command.description(description)
  |> command.handler(run)
}

fn run(args: Args) -> Nil {
  // Your command logic here
  todo
}

pub fn main() {
  command.run(command())
}
```

### Adding Arguments, Flags, and Options

Commands can accept three types of inputs:

- **Arguments** - Required positional values
- **Flags** - Optional boolean switches (e.g., `--verbose` or `-v`)
- **Options** - Optional values (e.g., `--format=json` or `-f=json`)

```gleam
import gleam/result
import glimr/console/command.{type Command, type Args, Argument, Flag, Option}

pub fn command() -> Command {
  command.new()
  |> command.description("Send emails to users")
  |> command.args([
    Argument(name: "recipient", description: "The email recipient"),
    Flag(name: "dry-run", short: "d", description: "Preview without sending"),
    Option(name: "format", description: "Output format", default: "text"),
  ])
  |> command.handler(run)
}

fn run(args: Args) -> Nil {
  let recipient = command.get_arg(args, "recipient")
  let dry_run = command.has_flag(args, "dry-run")
  let format = command.get_option(args, "format")

  // Use recipient, dry_run, and format...
}

// ...
```

### Run Your Command

You can now run your newly created command the same way you run Glimr commands:

```bash
./glimr app_send_emails
```

### Registering Your Command

For your command to appear in the command list, it needs to be compiled into your registry. Compilation occurs automatically when running `./glimr build` or `./glimr run`, but can be called manually with `./glimr command_compile`.

Your command will now appear in the command list when running:

```bash
./glimr

# or running this directly...
./glimr command_list
```

Just like with Glimr commands, you'll automatically be able to get help output for your custom commands by running:

```bash
./glimr app_send_emails --help
```

Run with arguments:

```bash
./glimr app_send_emails user@example.com --dry-run --format=json
```

### Commands with Database Access

For commands that need database access, pass a driver option with the connection name:

```bash
# PostgreSQL
./glimr make_command seed_database --db-postgres=main

# SQLite
./glimr make_command seed_database --db-sqlite=main
```

This generates a command that starts the pool explicitly:

```gleam
import glimr/console/command.{type Command, type Args}
import glimr_postgres/postgres

const description = "Command description"

pub fn command() -> Command {
  command.new()
  |> command.description(description)
  |> command.handler(run)
}

fn run(_args: Args) -> Nil {
  let pool = postgres.start("main")

  // Your command logic here
  todo
}

pub fn main() {
  command.run(command())
}
```

The connection name (e.g. `"main"`) matches a connection defined in `config/database.toml`.

### Commands with Cache Access

For commands that need cache access, pass a cache driver option with the store name:

```bash
# Redis
./glimr make_command warm_cache --cache-redis=main

# File
./glimr make_command warm_cache --cache-file=main

# PostgreSQL-backed cache
./glimr make_command warm_cache --cache-postgres=main

# SQLite-backed cache
./glimr make_command warm_cache --cache-sqlite=main
```

For example, `--cache-redis=main` generates:

```gleam
import glimr/console/command.{type Command, type Args}
import glimr_redis/redis

const description = "Command description"

pub fn command() -> Command {
  command.new()
  |> command.description(description)
  |> command.handler(run)
}

fn run(_args: Args) -> Nil {
  let pool = redis.start("main")

  // Your command logic here
  todo
}

pub fn main() {
  command.run(command())
}
```

Database-backed cache stubs (`--cache-postgres`, `--cache-sqlite`) also start a database pool for the cache table:

```gleam
fn run(_args: Args) -> Nil {
  // Update "main" below if your database connection has a different name
  let db_pool = postgres.start("main")
  let pool = postgres.start_cache(db_pool, "main")

  // Your command logic here
  todo
}
```

The store name (e.g. `"main"`) matches a store defined in `config/cache.toml`. Only one driver option can be used per command.

### Driver-Agnostic Commands

The `db_handler`, `cache_handler`, and `cache_db_handler` functions in `command.gleam` exist for framework and third-party package commands that must work with any driver. These use `--database` and `--cache` options for runtime driver selection:

```gleam
// Used by framework/third-party commands — not for user commands
command.new()
|> command.db_handler(fn(args, pool) { ... })
```

User commands should prefer explicit driver starts (via `make_command --db-postgres=main` etc.) so the driver dependency is visible at compile time.

### Third-Party Commands

Register packages that offer console commands in `glimr.toml`:

```toml
[commands]
  auto_compile = true
  packages = [
    "glimr",
    "package_name" # <-- Register the package here 
  ]
```

This allows third party packages to provide commands for your app in the same way Glimr does, providing a seamless and unified experience.

### Console Output

The `glimr/console/console` module provides helpers for printing styled terminal output in your commands.

**Printing lines** — each function prints immediately and returns `Nil`:

```gleam
import glimr/console/console

fn run(args: Args) -> Nil {
  console.line("Processing files...")
  console.line_success("Created: src/app/example.gleam")
  console.line_error("Failed to write file")
  console.line_warning("File already exists, skipping")
  console.line_info("Running migrations...")
  console.new_line(1)
}
```

**Inline colors** — for coloring parts of a line, use the string-returning helpers:

```gleam
// These return a colored String, not Nil
console.line(console.success("✓ ") <> "Migration applied")
console.line(console.warning("⚠ ") <> "Check your config")
```

Available inline color functions: `console.success()` (green), `console.warning()` (yellow), `console.error()` (red), `console.info()` (blue).

## Configuration

All configuration lives in TOML files under `config/`. At boot, `config.load()` reads every `*.toml` file in that directory and caches the merged result. You then access values anywhere via dot-separated paths where the first segment is the filename:

```gleam
import glimr/config/config
import glimr/http/http.{type Response}

pub fn show(ctx: Context(App)) -> Response {
  let app_name = config.get_string("app.name")
  let app_url = config.get_string("app.url")
  let session_lifetime = config.get_int("session.lifetime")
  let debug_mode = config.get_bool("app.debug")

  // Use configuration...
}
```

### Getter Variants

Each getter has two variants:

| Function | Behavior |
|----------|----------|
| `config.get_string(path)` | Returns the value or **panics** if missing |
| `config.get_string_or(path)` | Returns `Result(String, Nil)` |
| `config.get_int(path)` | Returns the value or **panics** if missing |
| `config.get_int_or(path)` | Returns `Result(Int, Nil)` |
| `config.get_bool(path)` | Returns the value or **panics** if missing |
| `config.get_bool_or(path)` | Returns `Result(Bool, Nil)` |

Use the panicking variants when you know the key exists (defined in your TOML files). Use the `_or` variants when you want to handle missing keys gracefully.

### Environment Variable Interpolation

TOML values support `${VAR}` and `${VAR:-fallback}` syntax:

```toml
# config/app.toml

name = "${APP_NAME:-Glimr}"
port = "${APP_PORT:-8000}"
key = "${APP_KEY}"
```

- `${APP_NAME:-Glimr}` — reads `APP_NAME` from the environment, falls back to `"Glimr"`
- `${APP_KEY}` — reads `APP_KEY` from the environment, panics if unset (when using `get_string`)

### Adding Configuration

Drop any `.toml` file in `config/` and access it immediately. For example, creating `config/mail.toml`:

```toml
# config/mail.toml

driver = "smtp"
host = "${MAIL_HOST:-localhost}"
port = "${MAIL_PORT:-587}"
```

Access it with `config.get_string("mail.driver")`, `config.get_int("mail.port")`, etc.

## Context System

The framework provides a `Context(app)` type that carries the HTTP request, response format, session, and your application state through the entire middleware and controller pipeline.

The framework owns the outer `Context` — it manages the request, session, and response format automatically. You define only your application-specific state in `src/app/app.gleam`:

```gleam
import glimr/cache/cache.{type CachePool}
import glimr/db/db.{type DbPool}

pub type App {
  App(
    db: DbPool,
    cache: CachePool,
    // Add your own fields here
  )
}
```

Access everything through the unified context in controllers:

```gleam
import glimr/http/http.{type Response}

pub fn show(ctx: Context(App)) -> Response {
  // Framework state: ctx.req, ctx.session, ctx.response_format
  // App state: ctx.app.db, ctx.app.cache, etc.
  case user.find(ctx.app.db, user_id) {
    Ok(user) -> // ...
    Error(_) -> response.not_found()
  }
}
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
