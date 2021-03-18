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

UE_JENKINS_INBOUND_AGENT_LINUX_IMAGE=`echo $HELM_CONFIG_JSON | jq -r ".ue_jenkins_inbound_agent_linux_image"`

UE_JENKINS_BUILDTOOLS_LINUX_IMAGE=`echo $HELM_CONFIG_JSON | jq -r ".ue_jenkins_buildtools_linux_image"`

PLASTIC=`echo $HELM_CONFIG_JSON | jq -r ".plastic"`

RELEASE="jenkins-controller"
CHART_NAME=`echo $HELM_CONFIG_JSON | jq -r ".chart_name"`
CHART_VERSION=`echo $HELM_CONFIG_JSON | jq -r ".chart_version"`

SEED_JOB_URL=`echo $HELM_CONFIG_JSON | jq -r ".seed_job_url"`

VALUES_FILES=("${APPLICATION_DIR}/values/values.yaml" )

# Include local-related values files
readarray -d '' VALUES_FILES_LOCAL < <(find "${APPLICATION_DIR}/values/local" -name '*.yaml' -print0)
VALUES_FILES+=(${VALUES_FILES_LOCAL[@]})

# Include Plastic-related values files, if Plastic is enabled in config
if [[ ${PLASTIC} -eq "true" ]]; then

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
    --version=${CHART_VERSION} ${RELEASE} ${CHART_NAME} \
    --debug \
    --set controller.image=${CONTROLLER_IMAGE} \
    --set controller.tag=${CONTROLLER_IMAGE_TAG} \
    --set GOOGLE_OAUTH_CLIENT_ID=${GOOGLE_OAUTH_CLIENT_ID} \
    --set GOOGLE_OAUTH_CLIENT_SECRET=${GOOGLE_OAUTH_CLIENT_SECRET} \
    --set controller.containerEnv[0].name=UE_JENKINS_BUILDTOOLS_LINUX_IMAGE \
    --set controller.containerEnv[0].value=${UE_JENKINS_BUILDTOOLS_LINUX_IMAGE} \
    --set controller.containerEnv[1].name=SEED_JOB_URL \
    --set controller.containerEnv[1].value=${SEED_JOB_URL} \
    --set controller.containerEnv[2].name=UE_JENKINS_INBOUND_AGENT_LINUX_IMAGE \
    --set controller.containerEnv[2].value=${UE_JENKINS_INBOUND_AGENT_LINUX_IMAGE} \
    --wait
