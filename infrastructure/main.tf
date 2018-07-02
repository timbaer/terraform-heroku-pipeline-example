module "pipeline" {
  source  = "./pipeline"
  app_name = "${var.app_name}"
}

# Creates a new release for the application using a slug id
resource "heroku_app_release" "app-release" {
    app = "${module.pipeline.heroku_app.end2end.name}"
    slug_id = "${var.slug_id}"
}

# Update the web formation for the application's web
resource "heroku_formation" "app-web" {
    app = "${module.pipeline.heroku_app.end2end.name}"
    type = "web"
    quantity = 2
    size = "standard-1x"

    # Tells Terraform that this formation must be created/updated only after the app release has been created
    depends_on = ["heroku_app_release.app-release"]
}
