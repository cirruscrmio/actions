#!/bin/sh

set -e

echo "$INPUT_GCLOUDAUTH" | base64 -d > "$HOME"/gcloud.json
gcloud auth activate-service-account --key-file=$HOME/gcloud.json $*
gcloud auth configure-docker -q

docker build -t ${INPUT_IMAGE}:${INPUT_TAG} -f ${INPUT_DOCKERFILE} .
docker push ${INPUT_IMAGE}:${INPUT_TAG}