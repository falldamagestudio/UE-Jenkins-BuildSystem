#!/bin/bash

CHART_VERSION=$1
CONTROLLER_IMAGE_TAG=$2

GOOGLE_OAUTH_CLIENT_ID=`kubectl get secrets jenkins-controller-from-manual-config -o jsonpath="{.data.google_oauth_client_id}" | base64 --decode`
GOOGLE_OAUTH_CLIENT_SECRET=`kubectl get secrets jenkins-controller-from-manual-config -o jsonpath="{.data.google_oauth_client_secret}" | base64 --decode`

RELEASE="jenkins-controller"
CHART="jenkins/jenkins"
CONTROLLER_IMAGE="jenkins/jenkins"

helm upgrade --install --values values/values.yaml --values values/local/jenkinsUrl.yaml --values values/local/local-image.yaml --version=${CHART_VERSION} ${RELEASE} ${CHART} --debug --set controller.image=${CONTROLLER_IMAGE} --set controller.tag=${CONTROLLER_IMAGE_TAG} --set GOOGLE_OAUTH_CLIENT_ID=${GOOGLE_OAUTH_CLIENT_ID} --set GOOGLE_OAUTH_CLIENT_SECRET=${GOOGLE_OAUTH_CLIENT_SECRET} --wait

kubectl port-forward service/jenkins-controller 8080:8080
