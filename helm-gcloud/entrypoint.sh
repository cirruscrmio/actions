#!/bin/sh

set -e

echo "$INPUT_GCLOUDAUTH" | base64 -d > "$HOME"/gcloud.json
gcloud auth activate-service-account --key-file="$HOME"/gcloud.json $*
gcloud config set project "$INPUT_PROJECTNAME"
gcloud container clusters get-credentials "$INPUT_CLUSTERNAME" --zone "$INPUT_CLUSTERZONE"

if [ -f "$INPUT_VALUES" ]; then
	helm upgrade --install "$INPUT_RELEASENAME" --values "$INPUT_VALUES" --set x=x,"$INPUT_SET" "$INPUT_CHARTPATH"
else
	helm upgrade --install "$INPUT_RELEASENAME" --set x=x,"$INPUT_SET" "$INPUT_CHARTPATH"
fi
