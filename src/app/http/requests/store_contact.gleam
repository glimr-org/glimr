import glimr/helpers/validation.{Email, MaxLength, MinLength, Required}

pub fn rules(form) {
  validation.start([
    form |> validation.for("name", [Required, MinLength(2)]),

    form
      |> validation.for("email", [
        Required,
        Email,
        MinLength(2),
        MaxLength(255),
      ]),
  ])
}

pub fn validate(req, on_valid) {
  rules |> validation.handle(req, on_valid)
}
