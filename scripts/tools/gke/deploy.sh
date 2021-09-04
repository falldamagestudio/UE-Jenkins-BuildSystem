#!/bin/bash

HELM_CONFIG_FILE=$1

APPLICATION_DIR=${BASH_SOURCE%/*}/../../../application

CHART_DIR=${APPLICATION_DIR}/helm-charts/charts/jenkins

GOOGLE_OAUTH_CLIENT_ID=$(kubectl get secrets jenkins-controller-from-manual-config -o jsonpath="{.data.google_oauth_client_id}" | base64 --decode)
GOOGLE_OAUTH_CLIENT_SECRET=$(kubectl get secrets jenkins-controller-from-manual-config -o jsonpath="{.data.google_oauth_client_secret}" | base64 --decode)
SUBDOMAIN_NAME=$(kubectl get secrets jenkins-controller-from-manual-config -o jsonpath="{.data.hostname}" | base64 --decode)

GOOGLE_PROJECT=$(kubectl get secrets jenkins-controller-from-terraform -o jsonpath="{.data.project}" | base64 --decode)
GOOGLE_REGION=$(kubectl get secrets jenkins-controller-from-terraform -o jsonpath="{.data.region}" | base64 --decode)
GOOGLE_ZONE=$(kubectl get secrets jenkins-controller-from-terraform -o jsonpath="{.data.zone}" | base64 --decode)
EXTERNAL_STATIC_IP_ADDRESS_NAME=$(kubectl get secrets jenkins-controller-from-terraform -o jsonpath="{.data.external_ingress_static_ip_address_name}" | base64 --decode)
INTERNAL_STATIC_IP_ADDRESS_NAME=$(kubectl get secrets jenkins-controller-from-terraform -o jsonpath="{.data.internal_ingress_static_ip_address_name}" | base64 --decode)
LONGTAIL_STORE_BUCKET_NAME=$(kubectl get secrets jenkins-controller-from-terraform -o jsonpath="{.data.longtail_store_bucket_name}" | base64 --decode)
AGENT_LISTENER_SERVICE_LOAD_BALANCER_IP=$(kubectl get secrets jenkins-controller-from-terraform -o jsonpath="{.data.agent_listener_service_load_balancer_ip}" | base64 --decode)

HELM_CONFIG_JSON=$(cat "${HELM_CONFIG_FILE}")

CONTROLLER_IMAGE=$(echo "${HELM_CONFIG_JSON}" | jq -r ".controller_image")
# Split string into image and tag sections at the last ':' in the string
CONTROLLER_IMAGE_ONLY=${CONTROLLER_IMAGE%:*}
CONTROLLER_TAG_ONLY=${CONTROLLER_IMAGE##*:}

UE_JENKINS_INBOUND_AGENT_LINUX_IMAGE=$(echo "${HELM_CONFIG_JSON}" | jq -r ".ue_jenkins_inbound_agent_linux_image")
# Split string into image and tag sections at the last ':' in the string
UE_JENKINS_INBOUND_AGENT_LINUX_IMAGE_ONLY=${UE_JENKINS_INBOUND_AGENT_LINUX_IMAGE%:*}
UE_JENKINS_INBOUND_AGENT_LINUX_TAG_ONLY=${UE_JENKINS_INBOUND_AGENT_LINUX_IMAGE##*:}

UE_JENKINS_INBOUND_AGENT_WINDOWS_IMAGE=$(echo "${HELM_CONFIG_JSON}" | jq -r ".ue_jenkins_inbound_agent_windows_image")

UE_JENKINS_BUILDTOOLS_LINUX_IMAGE=$(echo "${HELM_CONFIG_JSON}" | jq -r ".ue_jenkins_buildtools_linux_image")
UE_JENKINS_BUILDTOOLS_WINDOWS_IMAGE=$(echo "${HELM_CONFIG_JSON}" | jq -r ".ue_jenkins_buildtools_windows_image")

PLASTIC=$(echo "${HELM_CONFIG_JSON}" | jq -r ".plastic")

RELEASE="jenkins-controller"

SEED_JOB_URL=$(echo "${HELM_CONFIG_JSON}" | jq -r ".seed_job_url")
SEED_JOB_BRANCH=$(echo "${HELM_CONFIG_JSON}" | jq -r ".seed_job_branch")

VALUES_FILES=()

# Include platform-independent values files
readarray -d '' VALUES_FILES_DEFAULT < <(find "${APPLICATION_DIR}/values" -maxdepth 1 -name '*.yaml' -print0)
VALUES_FILES+=(${VALUES_FILES_DEFAULT[@]})

# Include GKE-related values files
readarray -d '' VALUES_FILES_GKE < <(find "${APPLICATION_DIR}/values/gke" -name '*.yaml' -print0)
VALUES_FILES+=(${VALUES_FILES_GKE[@]})

# Include Plastic-related values files, if Plastic is enabled in config
if [[ ${PLASTIC} == "true" ]]; then

    readarray -d '' VALUES_FILES_PLASTIC < <(find "${APPLICATION_DIR}/values/plastic" -name '*.yaml' -print0)
    VALUES_FILES+=(${VALUES_FILES_PLASTIC[@]})

fi

# Convert an array like this:
#  a.yaml b.yaml c.yaml
# to this:
#  --values a.yaml --values b.yaml --values c.yaml

VALUES=()

for VALUES_FILE in "${VALUES_FILES[@]}"
do
    VALUES+=("--values" "${VALUES_FILE}")
done

helm upgrade \
    --install \
    ${VALUES[*]} \
    "${RELEASE}" \
    "${CHART_DIR}" \
    --debug \
    --set "controller.agentListenerLoadBalancerIP=${AGENT_LISTENER_SERVICE_LOAD_BALANCER_IP}" \
    --set "controller.ingress.annotations.kubernetes\\.io/ingress\\.global-static-ip-name=${EXTERNAL_STATIC_IP_ADDRESS_NAME}" \
    --set "controller.secondaryingress.annotations.kubernetes\\.io/ingress\\.regional-static-ip-name=${INTERNAL_STATIC_IP_ADDRESS_NAME}" \
    --set "controller.image=${CONTROLLER_IMAGE_ONLY}" \
    --set "controller.tag=${CONTROLLER_TAG_ONLY}" \
    --set "agent.image=${UE_JENKINS_INBOUND_AGENT_LINUX_IMAGE_ONLY}" \
    --set "agent.tag=${UE_JENKINS_INBOUND_AGENT_LINUX_TAG_ONLY}" \
    --set "controller.ingress.hostName=${SUBDOMAIN_NAME}" \
    --set "controller.managedsslcertificate.domains[0]=${SUBDOMAIN_NAME}" \
    --set "GOOGLE_OAUTH_CLIENT_ID=${GOOGLE_OAUTH_CLIENT_ID}" \
    --set "GOOGLE_OAUTH_CLIENT_SECRET=${GOOGLE_OAUTH_CLIENT_SECRET}" \
    --set "GOOGLE_PROJECT=${GOOGLE_PROJECT}" \
    --set "GOOGLE_REGION=${GOOGLE_REGION}" \
    --set "GOOGLE_ZONE=${GOOGLE_ZONE}" \
    --set "UE_JENKINS_INBOUND_AGENT_LINUX_IMAGE=${UE_JENKINS_INBOUND_AGENT_LINUX_IMAGE}" \
    --set "UE_JENKINS_INBOUND_AGENT_WINDOWS_IMAGE=${UE_JENKINS_INBOUND_AGENT_WINDOWS_IMAGE}" \
    --set "UE_JENKINS_BUILDTOOLS_LINUX_IMAGE=${UE_JENKINS_BUILDTOOLS_LINUX_IMAGE}" \
    --set "UE_JENKINS_BUILDTOOLS_WINDOWS_IMAGE=${UE_JENKINS_BUILDTOOLS_WINDOWS_IMAGE}" \
    --set "LONGTAIL_STORE_BUCKET_NAME=${LONGTAIL_STORE_BUCKET_NAME}" \
    --set "SEED_JOB_URL=${SEED_JOB_URL}" \
    --set "SEED_JOB_BRANCH=${SEED_JOB_BRANCH}" \
    --wait
