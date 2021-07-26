#!/bin/bash

HELM_CONFIG_FILE="$1"

APPLICATION_DIR="${BASH_SOURCE%/*}/../../../application"

CHART_DIR="${APPLICATION_DIR}/helm-charts/charts/jenkins"

GOOGLE_OAUTH_CLIENT_ID=`kubectl get secrets jenkins-controller-from-manual-config -o jsonpath="{.data.google_oauth_client_id}" | base64 --decode`
GOOGLE_OAUTH_CLIENT_SECRET=`kubectl get secrets jenkins-controller-from-manual-config -o jsonpath="{.data.google_oauth_client_secret}" | base64 --decode`

HELM_CONFIG_JSON=`cat ${HELM_CONFIG_FILE}`

CONTROLLER_IMAGE=`echo $HELM_CONFIG_JSON | jq -r ".controller_image"`
# Split string into image and tag sections at the last ':' in the string
CONTROLLER_IMAGE_ONLY=${CONTROLLER_IMAGE%:*}
CONTROLLER_TAG_ONLY=${CONTROLLER_IMAGE##*:}

UE_JENKINS_INBOUND_AGENT_LINUX_IMAGE=`echo $HELM_CONFIG_JSON | jq -r ".ue_jenkins_inbound_agent_linux_image"`
# Split string into image and tag sections at the last ':' in the string
UE_JENKINS_INBOUND_AGENT_LINUX_IMAGE_ONLY=${UE_JENKINS_INBOUND_AGENT_LINUX_IMAGE%:*}
UE_JENKINS_INBOUND_AGENT_LINUX_TAG_ONLY=${UE_JENKINS_INBOUND_AGENT_LINUX_IMAGE##*:}

UE_JENKINS_BUILDTOOLS_LINUX_IMAGE_AND_TAG=`echo $HELM_CONFIG_JSON | jq -r ".ue_jenkins_buildtools_linux_image"`

PLASTIC=`echo $HELM_CONFIG_JSON | jq -r ".plastic"`

RELEASE="jenkins-controller"

SEED_JOB_URL=`echo $HELM_CONFIG_JSON | jq -r ".seed_job_url"`
SEED_JOB_BRANCH=`echo $HELM_CONFIG_JSON | jq -r ".seed_job_branch"`

VALUES_FILES=()

# Include platform-independent values files
readarray -d '' VALUES_FILES_DEFAULT < <(find "${APPLICATION_DIR}/values" -maxdepth 1 -name '*.yaml' -print0)
VALUES_FILES+=(${VALUES_FILES_DEFAULT[@]})

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
    ${RELEASE} \
    ${CHART_DIR} \
    --debug \
    --set controller.image=${CONTROLLER_IMAGE_ONLY} \
    --set controller.tag=${CONTROLLER_TAG_ONLY} \
    --set agent.image=${UE_JENKINS_INBOUND_AGENT_LINUX_IMAGE_ONLY} \
    --set agent.tag=${UE_JENKINS_INBOUND_AGENT_LINUX_TAG_ONLY} \
    --set GOOGLE_OAUTH_CLIENT_ID=${GOOGLE_OAUTH_CLIENT_ID} \
    --set GOOGLE_OAUTH_CLIENT_SECRET=${GOOGLE_OAUTH_CLIENT_SECRET} \
    --set UE_JENKINS_BUILDTOOLS_LINUX_IMAGE=${UE_JENKINS_BUILDTOOLS_LINUX_IMAGE} \
    --set UE_JENKINS_INBOUND_AGENT_LINUX_IMAGE=${UE_JENKINS_INBOUND_AGENT_LINUX_IMAGE} \
    --set SEED_JOB_URL=${SEED_JOB_URL} \
    --set SEED_JOB_BRANCH=${SEED_JOB_BRANCH} \
    --wait
