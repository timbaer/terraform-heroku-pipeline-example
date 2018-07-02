#!/bin/sh

APP_NAME=terraform-test-app
APP_NAME_END2END=terraform-test-app-end2end
APP_INDEX_FILE=server.js

NODE_VERSION=v8.11.3

echo "### Creating app deployable ###"

$(cd app/;npm install)

echo "### Check if node is already installed ###"
if [[ ! -d app/node-$NODE_VERSION-linux-x64 ]]; then
  echo "Installing node-$NODE_VERSION-linux-x64 into app/"
  $(cd app/;curl -s https://nodejs.org/dist/$NODE_VERSION/node-$NODE_VERSION-linux-x64.tar.xz | tar xzv)
fi
echo "### Creating slug ###"
rm slug.tgz
tar czf slug.tgz ./app

export HEROKU_API_KEY=$(heroku auth:token)

register=$(curl -s -X POST -H 'Content-Type: application/json' \
            -H 'Accept: application/vnd.heroku+json; version=3' \
            -H "Authorization: Bearer $HEROKU_API_KEY" \
            -d '{"process_types":{"web":"node-'$NODE_VERSION'-linux-x64/bin/node '$APP_INDEX_FILE'"}}' \
            -n https://api.heroku.com/apps/$APP_NAME_END2END/slugs)

SLUG_UPLOAD_URL=$(echo $register |python -c "import sys, json; print json.load(sys.stdin)['blob']['url']")
SLUG_ID=$(echo $register |python -c "import sys, json; print json.load(sys.stdin)['id']")

echo "### Uploading slug with id $SLUG_ID to $SLUG_UPLOAD_URL ####"

curl -X PUT -H "Content-Type:" --data-binary @slug.tgz "$SLUG_UPLOAD_URL"

echo "### Releasing slug $SLUG_ID ####"

export TF_VAR_app_name=$APP_NAME
export TF_VAR_slug_id=$SLUG_ID

docker run -ti --rm -e HEROKU_API_KEY -e HEROKU_EMAIL -v $(pwd)/infrastructure:/terraform -w /terraform hashicorp/terraform:light init
docker run -ti --rm -e HEROKU_API_KEY -e HEROKU_EMAIL -e TF_VAR_app_name -e TF_VAR_slug_id -v $(pwd)/infrastructure:/terraform -w /terraform hashicorp/terraform:light plan -out=tfplan -input=false
docker run -ti --rm -e HEROKU_API_KEY -e HEROKU_EMAIL -e TF_VAR_app_name -e TF_VAR_slug_id -v $(pwd)/infrastructure:/terraform -w /terraform hashicorp/terraform:light apply -input=false tfplan
