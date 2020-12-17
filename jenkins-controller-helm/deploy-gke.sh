#!/bin/bash

GOOGLE_OAUTH_CLIENT_ID=$1
GOOGLE_OAUTH_CLIENT_SECRET=$2
STATIC_IP_ADDRESS_NAME=$3
IMAGE_TAG=$4
SUBDOMAIN_NAME=$5

RELEASE="jenkins-controller"
CHART="jenkins/jenkins"
VERSION="v3.0.2"
VALUES="values/values.yaml"

PROJECT="kalms-ue4-jenkins-buildsystem"
REGION="europe-west1"

IMAGE="${REGION}-docker.pkg.dev/${PROJECT}/docker-build-artifacts/ue-jenkins-controller"

if [[ `helm list --filter ${RELEASE} -o json | jq ".[0]"` != "null" ]]; then
    OPERATION="upgrade"
else
    OPERATION="install"
fi

helm ${OPERATION} --values ${VALUES} --values values/gke/serviceType.yaml --values values/gke/nodeSelector.yaml --values values/gke/ingress.yaml --values values/gke/gke-image.yaml --version=${VERSION} ${RELEASE} ${CHART} --debug --set GOOGLE_OAUTH_CLIENT_ID=${GOOGLE_OAUTH_CLIENT_ID} --set GOOGLE_OAUTH_CLIENT_SECRET=${GOOGLE_OAUTH_CLIENT_SECRET} --set controller.ingress.annotations.kubernetes\\.io/ingress\\.global-static-ip-name=${STATIC_IP_ADDRESS_NAME} --set controller.image=${IMAGE} --set controller.tag=${IMAGE_TAG} --set controller.ingress.hostName=$5
