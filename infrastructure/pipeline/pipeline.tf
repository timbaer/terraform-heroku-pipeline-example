resource "heroku_pipeline" "app" {
  name = "${var.app_name}"
  depends_on = ["heroku_pipeline.app"]
}

resource "heroku_pipeline_coupling" "end2end" {
  app      = "${heroku_app.end2end.name}"
  pipeline = "${heroku_pipeline.app.id}"
  stage    = "development"
  depends_on = ["heroku_pipeline.app", "heroku_app.end2end"]
}

resource "heroku_pipeline_coupling" "staging" {
  app      = "${heroku_app.staging.name}"
  pipeline = "${heroku_pipeline.app.id}"
  stage    = "staging"
  depends_on = ["heroku_pipeline.app", "heroku_app.staging"]
}

resource "heroku_pipeline_coupling" "production" {
  app      = "${heroku_app.production.name}"
  pipeline = "${heroku_pipeline.app.id}"
  stage    = "production"
  depends_on = ["heroku_pipeline.app", "heroku_app.production"]
}
