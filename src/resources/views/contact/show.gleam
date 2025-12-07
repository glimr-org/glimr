import lustre
import lustre/attribute.{attribute, class, name, placeholder, type_}
import lustre/element.{type Element}
import lustre/element/html.{button, div, form, h1, input, label, text}
import lustre/event

pub type Model {
  Model(name: String, email: String)
}

pub type Msg {
  UpdateName(String)
  UpdateEmail(String)
}

pub fn app() {
  lustre.simple(init, update, view)
}

pub fn init(_flags) -> Model {
  Model(name: "", email: "")
}

fn update(model: Model, msg: Msg) -> Model {
  case msg {
    UpdateName(value) -> Model(..model, name: value)
    UpdateEmail(value) -> Model(..model, email: value)
  }
}

pub fn view(model: Model) -> Element(Msg) {
  div([class("container")], [
    h1([class("title")], [text("Contact Us")]),
    form(
      [
        attribute("method", "post"),
        attribute("action", "/contact"),
        attribute("enctype", "multipart/form-data"),
      ],
      [
        div([class("field")], [
          label([class("label")], [text("Name")]),
          div([class("control")], [
            input([
              class("input"),
              type_("text"),
              name("name"),
              placeholder("Your name"),
              attribute("value", model.name),
              event.on_input(UpdateName),
            ]),
          ]),
        ]),
        div([class("field")], [
          label([class("label")], [text("Email")]),
          div([class("control")], [
            input([
              class("input"),
              type_("email"),
              name("email"),
              placeholder("your@email.com"),
              attribute("value", model.email),
              event.on_input(UpdateEmail),
            ]),
          ]),
        ]),
        div([class("field")], [
          label([class("label")], [text("Avatar")]),
          div([class("control")], [
            input([
              class("input"),
              type_("file"),
              name("avatar"),
              attribute("accept", ".jpg,.png"),
            ]),
          ]),
        ]),
        div([class("field")], [
          div([class("control")], [
            button([class("button is-primary"), type_("submit")], [
              text("Send Message"),
            ]),
          ]),
        ]),
      ],
    ),
  ])
}
