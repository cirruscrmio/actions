#!/bin/sh

set -e

echo "$INPUT_GCLOUDAUTH" | base64 -d > "$HOME"/gcloud.json
gcloud auth activate-service-account --key-file="$HOME"/gcloud.json $*
gcloud config set project "$INPUT_PROJECTNAME"
gcloud container clusters get-credentials "$INPUT_CLUSTERNAME" --zone "$INPUT_CLUSTERZONE"

helm_args=

if [ "$INPUT_ATOMIC" = "true" ]; then
	helm_args="$helm_args --atomic"
fi

if [ -n "$INPUT_TIMEOUT" ]; then
	helm_args="$helm_args --timeout $INPUT_TIMEOUT"
fi

if [ -n "$INPUT_VALUES" ]; then
	helm_args="$helm_args --values $INPUT_VALUES"
fi

helm upgrade \
	$helm_args \
	--install \
	--namespace "$INPUT_NAMESPACE" \
	--set x=x,"$INPUT_SET" \
	"$INPUT_RELEASENAME" \
	"$INPUT_CHARTPATH"
