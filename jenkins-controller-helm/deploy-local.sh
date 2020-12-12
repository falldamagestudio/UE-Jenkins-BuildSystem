#!/bin/bash

GOOGLE_OAUTH_CLIENT_ID=$1
GOOGLE_OAUTH_CLIENT_SECRET=$2

RELEASE="jenkins-controller"
CHART="jenkins/jenkins"
VERSION="v3.0.2"
VALUES="values/values.yaml"

if [[ `helm list --filter ${RELEASE} -o json | jq ".[0]"` != "null" ]]; then
    OPERATION="upgrade"
else
    OPERATION="install"
fi

helm ${OPERATION} --values ${VALUES} --values values/local/jenkinsUrl.yaml --values values/local/local-image.yaml --version=${VERSION} ${RELEASE} ${CHART} --debug --set GOOGLE_OAUTH_CLIENT_ID=${GOOGLE_OAUTH_CLIENT_ID} --set GOOGLE_OAUTH_CLIENT_SECRET=${GOOGLE_OAUTH_CLIENT_SECRET}
