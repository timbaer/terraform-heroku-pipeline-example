provider "heroku" {}

resource "heroku_app" "end2end" {
  name   = "${var.app_name}-end2end"
  region = "eu"
  acm = false
}

resource "heroku_app" "staging" {
  name   = "${var.app_name}-staging"
  region = "eu"
  acm = false
}

resource "heroku_app" "production" {
  name   = "${var.app_name}-production"
  region = "eu"
  acm = false
}
