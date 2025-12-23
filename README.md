# Glimr ✨

A batteries-included web framework for Gleam that brings functional programming elegance and developer productivity to web development.

If you'd like to stay updated on Glimr's development, Follow [@migueljarias](https://x.com/migueljarias) on X (that's me) for updates.

## Table of Contents

- [About Glimr](#about-glimr)
- [Features](#features)
- [Installation](#installation)
- [Project Structure](#project-structure)
- [Quick Start](#quick-start)
  - [Defining Routes](#defining-routes)
  - [Creating Controllers](#creating-controllers)
  - [Route Parameters](#route-parameters)
  - [Middleware](#middleware)
  - [Form Validation](#form-validation)
  - [Views & Responses](#views--responses)
  - [Database](#database)
      - [Migrations](#migrations)
      - [Queries](#queries)
  - [Creating Actions](#creating-actions)
  - [Route Groups](#route-groups)
  - [API Routes](#api-routes)
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

#### Route Redirects

Define redirects directly in your routes:

```gleam
["old-contact"] -> wisp.redirect("/contact")
```

### Creating Controllers

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

### Creating Actions

Actions help keep controllers clean by extracting complex business logic into reusable modules. They can be chained together using the `use <-` syntax and always expect a callback that returns a `wisp.Response`.

Create actions in `src/app/http/actions/`. Use the following command:

```bash
./glimr make:action store_submission
```

This creates `store_submission_action.gleam`. Actions follow a simple pattern - they perform some work and pass results to a callback:

```gleam
// src/app/http/actions/store_submission_action.gleam
import app/http/context/ctx.{type Context}
import app/http/requests/contact_store_request.{type Data}
import data/models/submission/gen/submission_repository.{type CreateRow}
import glimr/db/pool
import wisp.{type Response}

pub fn run(
  ctx: Context,
  data: Data,
  next: fn(CreateRow) -> Response,
) -> Response {
  use conn <- pool.get_connection(ctx.db.pool)
  use submission <- submission_repository.create(
    conn: conn,
    name: data.name,
    email: data.email,
    message: data.message,
  )

  next(submission)
}
```

Use actions in controllers with the `use <-` syntax:

```gleam
// src/app/http/controllers/contact_controller.gleam
import app/http/actions/store_submission_action
import app/http/requests/contact_store_request

pub fn store(req: Request, ctx: Context) -> Response {
  use validated <- contact_store_request.validate(req, ctx)
  use submission <- store_submission_action.run(ctx, validated)

  redirect.build()
  |> redirect.to("/contact/success")
  |> redirect.flash([#("message", "Thanks " <> submission.name <> "!")])
  |> redirect.go()
}
```

**Chaining multiple actions:**

Actions compose naturally, keeping your controllers focused on the response:

```gleam
pub fn store(req: Request, ctx: Context) -> Response {
  use validated <- user_store_request.validate(req, ctx)
  use user <- create_user_action.run(ctx, validated)
  use _ <- send_welcome_email_action.run(ctx, user)
  use _ <- notify_admin_action.run(ctx, user)

  redirect.build()
  |> redirect.to("/users/" <> int.to_string(user.id))
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
  req: Request,
  ctx: Context
) -> Response {
  // Use slug and comment_id...
}
```

### Middleware

Middleware intercepts requests before they reach your controllers. Middleware can modify both the request and context, with changes flowing through to subsequent middleware and controllers.

#### Creating Middleware

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

#### Applying Middleware to Route Handlers

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

#### Modifying Context in Middleware

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

#### Modifying Responses After Handler

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

### Form Validation

Glimr provides a declarative, rule-based validation system for form data. Create form request modules to define validation rules and handle requests.

#### Creating Form Requests

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
```

#### Using Validation in Controllers

Use the `use` syntax for clean, readable validation handling:

```gleam
import app/http/requests/user_store
import app/repositories/user_repository
import glimr/forms/validator

// app/http/controllers/user_controller.gleam
pub fn store(req: Request, ctx: Context) -> Response {
  // Form validation errors are handled automatically
  use validated <- validator.run(
    req, 
    ctx, 
    user_store.rules, 
    user_store.data
  )

  // Do something with your validated data
  // validated.name : String
  // validated.email : String
  // validated.avatar : UploadedFile
  user_repository.create(validated)

  // Redirect back with a success message
  redirect.build()
  |> redirect.back(req)
  |> redirect.flash([#("message", "User created successfully!")])
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

#### Custom Validation Rules

Create your own validation rules for domain-specific logic using the `Custom` rule in `app/http/rules`. Use the following command:

```bash
./glimr make:rule username_available
```

Add your rule's validation logic:

```gleam
// app/http/rules/username_available.gleam
pub fn run(username: String) -> Result(Nil, String) {
  case db.username_exists(username) {
    // Error is automatically prepended with "Username " so
    // the full message would be: "Username is already taken"
    True -> Error("is already taken") 
    False -> Ok(Nil)
  }
}
```

Use your custom rule in your request:

```gleam
// app/http/requests/login_request.gleam
import glimr/forms/validator.{Custom, MinLength, Required}
import app/http/rules/username_available.{run as username_available}

pub fn rules(form: FormData) {
  [
    validator.for(form, "username", [
      Required,
      MinLength(3),
      Custom(username_available), // <-----
    ]),

    validator.for(form, "password", [Required]),
  ]
}
```

**Custom validation function structure:**
- Take a `String` value as input
- Return `Ok(Nil)` if validation passes
- Return `Error(message)` with an error message if validation fails

#### Custom File Validation Rules

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

### Views & Responses

Glimr provides a fluent builder pattern for rendering views with layouts and template variables.

#### Rendering Views

```gleam
import glimr/response/view

pub fn show(req: Request, ctx: Context) -> Response {
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

pub fn show(req: Request, ctx: Context) -> Response {
  let model = contact_form.init(Nil)

  view.build()
  |> view.lustre(contact_form.view(model))
  |> view.data([#("title", "Contact Us")])
  |> view.render()
}
```

#### Set Layout

Set a layout for a specific view:

```gleam
view.build()
|> view.html("dashboard.html")
// Layouts are set in src/resources/views/layouts/*
|> view.layout("admin.html")
|> view.data([#("title", "Admin Dashboard")])
|> view.render()
```

#### Template Variables

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

### Redirects

Glimr's redirect builder provides a clean API for redirecting users with flash messages.

#### Basic Redirects

```gleam
import glimr/response/redirect

pub fn store(req: Request, ctx: Context) -> wisp.Response {
  // Process form...

  redirect.build()
  |> redirect.to("/contact/success")
  |> redirect.go()
}
```

#### Redirects with Flash Messages

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

#### Redirect Back

Redirect users back to the previous page:

```gleam
pub fn cancel(req: Request, ctx: Context) -> Response {
  redirect.build()
  |> redirect.back(req)
  |> redirect.go()
}
```

## Database

Curently supports sqlite via the [lpil/sqlight](https://github.com/lpil/sqlight) package and postgres via the [lpil/pog](https://github.com/lpil/pog) package.

### Migrations

Glimr provides automatic migration generation by comparing your schema definitions against a stored snapshot. It detects changes and generates driver-specific SQL for PostgreSQL or SQLite.

#### Setup

Ensure your `.env` file has the database driver configured:

```env
DB_DRIVER=sqlite  # or "postgres"
```

#### Defining Schemas

Start by creating a data model using the following command:

```env
./glimr make:model user
```

This creates a `user/` folder inside `src/data/models/`. The folder contains `user_schema.gleam` for defining your table schema, and a `queries/` folder with pre-generated CRUD queries that get compiled into fully typed gleam code. You can add custom queries to this folder as well (see [Queries](#queries) section).

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

Run the migration generator:

```bash
./glimr gen:db
```

This will:
1. Scan schema files in `src/data/models/`
2. Compare against the stored snapshot (`.schema_snapshot.json`)
3. Detect changes (new tables, dropped tables, column changes)
4. Generate SQL in `src/data/_migrations/{timestamp}_migration.sql`
5. Update the snapshot for the next run

Example output:

```
Glimr Migration Generator
=========================
Driver: postgres
Found 3 table(s)

Detected 2 change(s):
  - Create table: posts
  - Add column: users.avatar

Generated: src/data/_migrations/20241223150000_migration.sql
Updated: src/data/.schema_snapshot.json

Done!
```
You can also run the following command to generate migrations and also run them:

```bash
./glimr gen:db --migrate
```

#### Renaming Columns

To rename a column without losing data, use the `rename_from` modifier:

```gleam
// Before: string("email")
// After:
string("email_address") |> rename_from("email")
```

This generates `ALTER TABLE ... RENAME COLUMN` instead of drop/add. The `rename_from` modifier is automatically removed from your schema file after the migration is generated.

#### Generated Migration Example

```sql
-- Generated by glimr/db/gen/migrate (postgres)

CREATE TABLE posts (
  id SERIAL PRIMARY KEY NOT NULL,
  title VARCHAR(255) NOT NULL,
  body TEXT NOT NULL,
  user_id INTEGER REFERENCES users(id) NOT NULL,
  created_at TIMESTAMP NOT NULL,
  updated_at TIMESTAMP NOT NULL
);

ALTER TABLE users ADD COLUMN avatar VARCHAR(255);
```

#### Running Migrations

Generated migrations are plain SQL files. Run them with the following command:

```bash
./glimr db:migrate
```

#### Rolling Back Migrations

Glimr takes a forward-only approach to migrations. Instead of rollbacks, simply generate a new migration to reverse any changes. This keeps your migration history explicit and auditable.

#### Dropping Tables

To drop a database table, simply delete the model from the `src/data/models/` folder. For example, if your model is called `user`, delete the `src/data/models/user/` folder. Finally, regenerate migrations and rerun them.

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
./glimr db:gen
```

This generates a fully-typed repository file with Gleam functions for each query. Every query generates **two functions**:

| Function | Error Handling | Return Type |
|----------|----------------|-------------|
| `find()` | Automatic (404/500 pages) | Expects a callback that returns a `Response` |
| `find_or()` | Manual (you handle errors) | `Result(User, Nil)` |

```gleam
// src/data/models/user/user_repository.gleam (auto-generated)

// Automatic error handling - returns 404 or 500 error pages
pub fn find(db, id, callback) -> Response
pub fn find_by_email(db, email, callback) -> Response

// Manual error handling - returns Result for you to handle
pub fn find_or(db, id) -> Result(User, Nil)
pub fn find_by_email_or(db, email) -> Result(User, Nil)

// List queries (no _or variant needed since empty list is valid)
pub fn list_all(db) -> List(User)
pub fn list_active(db) -> List(User)
```

#### Connection Pooling

Before executing queries, you need to get a connection from the pool. Glimr manages a pool of database connections to efficiently handle concurrent requests. 

You can specify the amount of connections you want initialized in your pool by setting the `DB_POOL_SIZE` env variable. It defaults to 5.

The pool is typically initialized in your context and accessed via `ctx.db.pool`. There are several ways to get a connection:

| Function | Error Handling | Safety | Return Type |
|----------|----------------|--------|-------------|
| `get_connection` | Automatic (500 page) | Safe | Expects a callback that returns a `Response` |
| `get_connection_or` | Manual | Safe | `Result(a, DbError)` |
| `checkout` / `release` | Manual | Unsafe | Must remember to release |

**With automatic error handling (recommended):**

`get_connection` automatically returns connections to the pool and returns a 500 error page if the pool is exhausted. Great for usage in controllers.

```gleam
import glimr/db/pool
import gleam/int

pub fn show(user_id: String, req: Request, ctx: Context) -> Response {
  let assert Ok(user_id) = int.parse(user_id)

  use conn <- pool.get_connection(ctx.db.pool)
  use user <- user_repository.find(conn, user_id)

  view.build()
  |> view.html("users/show.html")
  |> view.data([#("user", user.name)])
  |> view.render()
}
```

**Reusing connections for multiple queries:**

Once you have a connection, you can reuse it across multiple queries. This is more efficient than getting a new connection for each query:

```gleam
import glimr/db/pool

pub fn show(id: String, req: Request, ctx: Context) -> Response {
  let assert Ok(user_id) = int.parse(id)

  use conn <- pool.get_connection(ctx.db.pool)
  use user <- user_repository.find(conn, user_id)

  // Reuse the same connection for additional queries
  let posts = post_repository.list_by_user(conn, user_id)
  let comments = comment_repository.list_by_user(conn, user_id)

  view.build()
  |> view.html("users/show.html")
  |> view.data([
    #("user", user.name),
    #("post_count", int.to_string(list.length(posts))),
    #("comment_count", int.to_string(list.length(comments))),
  ])
  |> view.render()
}
```

**With manual error handling:**

`get_connection_or` returns a `Result`, letting you handle pool errors yourself:

```gleam
import glimr/db/pool

pub fn show(req: Request, ctx: Context) -> Response {
  case pool.get_connection_or(ctx.db.pool, fn(conn) {
    user_repository.find_or(conn, 1)
  }) {
    Ok(user) -> {
      view.build()
      |> view.html("users/show.html")
      |> view.data([#("user", user.name)])
      |> view.render()
    }
    Error(_) -> {
      // Handle connection or query error
      wisp.internal_server_error()
    }
  }
}
```

**Manual checkout/release (unsafe):**

For advanced use cases, you can manually manage connections with `checkout` and `release`. This is **unsafe** because you must remember to release the connection, or it will leak from the pool:

```gleam
import glimr/db/pool

pub fn batch_operation(ctx: Context) -> Response {
  case pool.checkout(ctx.db.pool) {
    Ok(conn) -> {
      // Perform multiple operations...
      let result1 = user_repository.find_or(conn, 1)
      let result2 = post_repository.list_by_user_or(conn, 1)

      // IMPORTANT: Always release the connection when done
      pool.release(ctx.db.pool, conn)

      // Return response...
      wisp.ok()
    }
    Error(_) -> wisp.internal_server_error()
  }
}
```

> **Warning:** Prefer `get_connection` or `get_connection_or` over manual `checkout`/`release`. Forgetting to release connections will exhaust the pool and cause your application to hang.

#### Using Queries in Controllers

**With automatic error handling (recommended):**

The non-`_or` repository functions can leverage the `use <-` syntax and automatically return a 404 page if the record isn't found, or a 500 error page for database errors, while still looking very clean. Your callback receives the found record and must return a `wisp.Response`.

```gleam
import data/models/user/user_repository
import glimr/db/pool

pub fn show(id: String, req: Request, ctx: Context) -> Response {
  let assert Ok(user_id) = int.parse(id)

  use conn <- pool.get_connection(ctx.db.pool)
  use user <- user_repository.find(conn, user_id)

  // This only runs if the user was found
  // If not found, a 404 page is automatically returned
  // If a different database error occurs, a 500 page
  // is automatically returned.
  view.build()
  |> view.html("users/show.html")
  |> view.data([#("user", user.name)])
  |> view.render()
}
```

**With manual error handling:**

The `_or` repository functions return a `Result`, giving you full control over error handling:

```gleam
import data/models/user/user_repository
import glimr/db/connection.{NotFound}
import glimr/db/pool


pub fn show(id: String, req: Request, ctx: Context) -> Response {
  let assert Ok(user_id) = int.parse(id)

  use conn <- pool.get_connection(ctx.db.pool)

  case user_repository.find_or(conn, user_id) {
    Ok(user) -> {
      view.build()
      |> view.html("users/show.html")
      |> view.data([#("user", user.name)])
      |> view.render()
    }
    Error(NotFound) -> {
      // Custom error handling for not found
      redirect.build()
      |> redirect.to("/users")
      |> redirect.flash([#("error", "User not found")])
      |> redirect.go()
    }
    Error(_) -> wisp.internal_server_error()
  }
}
```

**List queries:**

```gleam
import data/models/user/user_repository
import glimr/db/pool

pub fn index(req: Request, ctx: Context) -> Response {
  use conn <- pool.get_connection(ctx.db.pool)
  use users <- user_repository.list_all(conn)

  view.build()
  |> view.html("users/index.html")
  |> view.data([#("users", users)])
  |> view.render()
}
```

#### Database Transactions

For operations that must succeed or fail together, use `db.transaction`. It automatically:
- Checks out a connection from the pool
- Begins a transaction
- Commits on success or rolls back on error
- Returns the connection to the pool
- Retries on deadlock (with configurable retry count)

```gleam
import glimr/db/db
import glimr/db/connection.{type DbError}

pub fn transfer(
  ctx: Context,
  from_id: Int,
  to_id: Int,
  amount: Int,
) -> Result(Nil, DbError) {
  use conn <- db.transaction(ctx.db.pool, 3)

  // Both operations use the same connection within the transaction
  use _ <- result.try(account_repository.debit_or(conn, from_id, amount))
  use _ <- result.try(account_repository.credit_or(conn, to_id, amount))
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

pub fn store(req: Request, ctx: Context) -> Response {
  use validated <- transfer_request.validate(req, ctx)

  case {
    use conn <- db.transaction(ctx.db.pool, 3)
    use _ <- result.try(account_repository.debit_or(conn, validated.from_id, validated.amount))
    use _ <- result.try(account_repository.credit_or(conn, validated.to_id, validated.amount))
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

> **Note:** Use the `_or` variants of repository functions inside transactions since they return `Result` types that can be composed with `result.try`.

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

pub fn show(req: Request, ctx: Context) -> Response {
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
- [Wisp Documentation](https://hexdocs.pm/wisp/) - Web server library

### Built With

Glimr is built on top of these excellent Gleam libraries:

- [**Wisp**](https://hexdocs.pm/wisp/) - The web framework that powers Glimr's HTTP handling
- [**gleam_http**](https://hexdocs.pm/gleam_http/) - HTTP types and utilities
- [**gleam_json**](https://hexdocs.pm/gleam_json/) - JSON encoding and decoding
- [**gleam_stdlib**](https://hexdocs.pm/gleam_stdlib/) - Gleam's standard library
- [**gleam_time**](https://github.com/gleam-lang/time) - Work with time in Gleam!

Special thanks to the Gleam community for building such an awesome ecosystem!

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

The Glimr framework is open-sourced software licensed under the [MIT](https://opensource.org/license/MIT) license.

## Credits

Glimr is inspired by [Laravel](https://laravel.com/) and adapted for Gleam's functional programming paradigm.
