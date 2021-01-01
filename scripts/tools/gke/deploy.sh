#!/bin/bash

HELM_CONFIG_FILE="$1"

APPLICATION_DIR="${BASH_SOURCE%/*}/../../../application"

GOOGLE_OAUTH_CLIENT_ID=`kubectl get secrets jenkins-controller-from-manual-config -o jsonpath="{.data.google_oauth_client_id}" | base64 --decode`
GOOGLE_OAUTH_CLIENT_SECRET=`kubectl get secrets jenkins-controller-from-manual-config -o jsonpath="{.data.google_oauth_client_secret}" | base64 --decode`
SUBDOMAIN_NAME=`kubectl get secrets jenkins-controller-from-manual-config -o jsonpath="{.data.hostname}" | base64 --decode`
STATIC_IP_ADDRESS_NAME=`kubectl get secrets jenkins-controller-from-terraform -o jsonpath="{.data.ingress_static_ip_address_name}" | base64 --decode`

HELM_CONFIG_JSON=`cat ${HELM_CONFIG_FILE}`

CONTROLLER_IMAGE=`echo $HELM_CONFIG_JSON | jq -r ".controller_image"`
CONTROLLER_IMAGE_TAG=`echo $HELM_CONFIG_JSON | jq -r ".controller_image_tag"`

UE_BUILDTOOLS_LINUX_IMAGE=`echo $HELM_CONFIG_JSON | jq -r ".ue_buildtools_linux_image"`
UE_BUILDTOOLS_LINUX_IMAGE_TAG=`echo $HELM_CONFIG_JSON | jq -r ".ue_buildtools_linux_image_tag"`

RELEASE="jenkins-controller"
CHART_NAME=`echo $HELM_CONFIG_JSON | jq -r ".chart_name"`
CHART_VERSION=`echo $HELM_CONFIG_JSON | jq -r ".chart_version"`

helm upgrade --install --values "${APPLICATION_DIR}/values/values.yaml" --values "${APPLICATION_DIR}/values/gke/serviceType.yaml" --values "${APPLICATION_DIR}/values/gke/nodeSelector.yaml" --values "${APPLICATION_DIR}/values/gke/ingress.yaml" --values "${APPLICATION_DIR}/values/gke/gke-image.yaml" --version=${CHART_VERSION} ${RELEASE} ${CHART_NAME} --debug --set GOOGLE_OAUTH_CLIENT_ID=${GOOGLE_OAUTH_CLIENT_ID} --set GOOGLE_OAUTH_CLIENT_SECRET=${GOOGLE_OAUTH_CLIENT_SECRET} --set controller.ingress.annotations.kubernetes\\.io/ingress\\.global-static-ip-name=${STATIC_IP_ADDRESS_NAME} --set controller.image=${CONTROLLER_IMAGE} --set controller.tag=${CONTROLLER_IMAGE_TAG} --set controller.ingress.hostName=${SUBDOMAIN_NAME} --set controller.containerEnv[0].name=UE_BUILDTOOLS_LINUX_IMAGE --set controller.containerEnv[0].value=${UE_BUILDTOOLS_LINUX_IMAGE} --set controller.containerEnv[1].name=UE_BUILDTOOLS_LINUX_IMAGE_TAG --set controller.containerEnv[1].value=${UE_BUILDTOOLS_LINUX_IMAGE_TAG} --wait
