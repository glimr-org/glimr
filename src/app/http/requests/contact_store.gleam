import app/http/rules/no_gmail
import glimr/forms/form
import glimr/forms/validator.{
  Custom, Email, FileExtension, FileMaxSize, FileRequired, MaxLength, MinLength,
  Required,
}
import wisp.{type FormData, type UploadedFile}

pub type Data {
  Data(name: String, email: String, avatar: UploadedFile)
}

pub fn rules(form: FormData) {
  [
    form |> validator.for("name", [Required, MinLength(2)]),

    form
      |> validator.for("email", [
        Required,
        Email,
        MinLength(2),
        MaxLength(255),
        Custom(no_gmail.run),
      ]),

    form
      |> validator.for_file("avatar", [
        FileRequired,
        FileExtension(["jpg", "png"]),
        FileMaxSize(5000),
      ]),
  ]
}

pub fn data(form: FormData) -> Data {
  Data(
    name: form.get(form, "name"),
    email: form.get(form, "email"),
    avatar: form.get_file(form, "avatar"),
  )
}
