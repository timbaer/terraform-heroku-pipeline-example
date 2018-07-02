#!/bin/sh

APP_NAME=terraform-test-app

export TF_VAR_app_name=$APP_NAME
export TF_VAR_slug_id="not_set"

docker run -ti --rm -e HEROKU_API_KEY -e HEROKU_EMAIL -v $(pwd):/terraform -w /terraform hashicorp/terraform:light init -target=pipeline
docker run -ti --rm -e HEROKU_API_KEY -e HEROKU_EMAIL -e TF_VAR_app_name -e TF_VAR_slug_id -v $(pwd):/terraform -w /terraform hashicorp/terraform:light plan -out=tfplan -input=false -target=module.pipeline
docker run -ti --rm -e HEROKU_API_KEY -e HEROKU_EMAIL -e TF_VAR_app_name -e TF_VAR_slug_id -v $(pwd):/terraform -w /terraform hashicorp/terraform:light apply -input=false tfplan
