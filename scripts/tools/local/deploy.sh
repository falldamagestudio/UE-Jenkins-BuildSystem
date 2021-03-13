#!/bin/bash

HELM_CONFIG_FILE="$1"

APPLICATION_DIR="${BASH_SOURCE%/*}/../../../application"

GOOGLE_OAUTH_CLIENT_ID=`kubectl get secrets jenkins-controller-from-manual-config -o jsonpath="{.data.google_oauth_client_id}" | base64 --decode`
GOOGLE_OAUTH_CLIENT_SECRET=`kubectl get secrets jenkins-controller-from-manual-config -o jsonpath="{.data.google_oauth_client_secret}" | base64 --decode`

HELM_CONFIG_JSON=`cat ${HELM_CONFIG_FILE}`

CONTROLLER_IMAGE_AND_TAG=`echo $HELM_CONFIG_JSON | jq -r ".controller_image"`
# Split string into image and tag sections at the last ':' in the string
CONTROLLER_IMAGE=${CONTROLLER_IMAGE_AND_TAG%:*}
CONTROLLER_IMAGE_TAG=${CONTROLLER_IMAGE_AND_TAG##*:}

UE_JENKINS_BUILDTOOLS_LINUX_IMAGE=`echo $HELM_CONFIG_JSON | jq -r ".ue_jenkins_buildtools_linux_image"`

RELEASE="jenkins-controller"
CHART_NAME=`echo $HELM_CONFIG_JSON | jq -r ".chart_name"`
CHART_VERSION=`echo $HELM_CONFIG_JSON | jq -r ".chart_version"`

SEED_JOB_URL=`echo $HELM_CONFIG_JSON | jq -r ".seed_job_url"`

helm upgrade --install --values "${APPLICATION_DIR}/values/values.yaml" --values "${APPLICATION_DIR}/values/local/jenkinsUrl.yaml" --values "${APPLICATION_DIR}/values/local/local-image.yaml"  --values "${APPLICATION_DIR}/values/plastic/volumes.yaml" --version=${CHART_VERSION} ${RELEASE} ${CHART_NAME} --debug --set controller.image=${CONTROLLER_IMAGE} --set controller.tag=${CONTROLLER_IMAGE_TAG} --set GOOGLE_OAUTH_CLIENT_ID=${GOOGLE_OAUTH_CLIENT_ID} --set GOOGLE_OAUTH_CLIENT_SECRET=${GOOGLE_OAUTH_CLIENT_SECRET}  --set controller.containerEnv[0].name=UE_JENKINS_BUILDTOOLS_LINUX_IMAGE --set controller.containerEnv[0].value=${UE_JENKINS_BUILDTOOLS_LINUX_IMAGE} --set controller.containerEnv[1].name=SEED_JOB_URL --set controller.containerEnv[1].value=${SEED_JOB_URL} --wait
