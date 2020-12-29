#!/bin/bash

CHART_VERSION=$1
CONTROLLER_IMAGE_TAG=$2

IMAGE_REGISTRY_PREFIX=`kubectl get secrets jenkins-controller-from-terraform -o jsonpath="{.data.image_registry_prefix}" | base64 --decode`

GOOGLE_OAUTH_CLIENT_ID=`kubectl get secrets jenkins-controller-from-manual-config -o jsonpath="{.data.google_oauth_client_id}" | base64 --decode`
GOOGLE_OAUTH_CLIENT_SECRET=`kubectl get secrets jenkins-controller-from-manual-config -o jsonpath="{.data.google_oauth_client_secret}" | base64 --decode`
SUBDOMAIN_NAME=`kubectl get secrets jenkins-controller-from-manual-config -o jsonpath="{.data.hostname}" | base64 --decode`
STATIC_IP_ADDRESS_NAME=`kubectl get secrets jenkins-controller-from-terraform -o jsonpath="{.data.ingress_static_ip_address_name}" | base64 --decode`

CONTROLLER_IMAGE="${IMAGE_REGISTRY_PREFIX}/ue-jenkins-controller"

UE_JENKINS_BUILDTOOLS_IMAGE="${IMAGE_REGISTRY_PREFIX}/ue-jenkins-buildtools"
UE_JENKINS_BUILDTOOLS_IMAGE_TAG="undefined"

RELEASE="jenkins-controller"
CHART="jenkins/jenkins"

helm upgrade --install --values values/values.yaml --values values/gke/serviceType.yaml --values values/gke/nodeSelector.yaml --values values/gke/ingress.yaml --values values/gke/gke-image.yaml --version=${CHART_VERSION} ${RELEASE} ${CHART} --debug --set GOOGLE_OAUTH_CLIENT_ID=${GOOGLE_OAUTH_CLIENT_ID} --set GOOGLE_OAUTH_CLIENT_SECRET=${GOOGLE_OAUTH_CLIENT_SECRET} --set controller.ingress.annotations.kubernetes\\.io/ingress\\.global-static-ip-name=${STATIC_IP_ADDRESS_NAME} --set controller.image=${CONTROLLER_IMAGE} --set controller.tag=${CONTROLLER_IMAGE_TAG} --set controller.ingress.hostName=${SUBDOMAIN_NAME} --set controller.containerEnv[0].name=UE_JENKINS_BUILDTOOLS_IMAGE --set controller.containerEnv[0].value=${UE_JENKINS_BUILDTOOLS_IMAGE} --set controller.containerEnv[1].name=UE_JENKINS_BUILDTOOLS_IMAGE_TAG --set controller.containerEnv[1].value=${UE_JENKINS_BUILDTOOLS_IMAGE_TAG} 
