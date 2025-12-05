import app/http/context/ctx.{type Context}
import app/http/requests/store_contact
import glimr/routing/route.{type RouteRequest}
import wisp.{type Response}

pub fn store(req: RouteRequest, _ctx: Context) -> Response {
  use _form <- store_contact.validate(req)

  wisp.html_response("Contact form submitted successfully!", 200)
}
