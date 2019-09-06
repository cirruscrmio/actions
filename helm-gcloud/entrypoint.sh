#!/bin/sh

set -e

echo "$INPUT_GCLOUDAUTH" | base64 -d > "$HOME"/gcloud.json
gcloud auth activate-service-account --key-file=$HOME/gcloud.json $*
gcloud config set project ${INPUT_PROJECTNAME}
gcloud container clusters get-credentials ${INPUT_CLUSTERNAME} --zone ${INPUT_CLUSTERZONE}

helm upgrade ${INPUT_RELEASENAME} --set x=x,${INPUT_SET} ${INPUT_CHARTPATH}