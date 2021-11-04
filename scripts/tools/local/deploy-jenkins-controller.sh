#!/bin/bash

APPLICATION_DIR="${BASH_SOURCE%/*}/../../../application"

JENKINS_CHART_DIR="${APPLICATION_DIR}/chart"
JENKINS_RELEASE="jenkins"
JENKINS_NAMESPACE="jenkins"

VALUES_FILES=()

# Include platform-independent values files
readarray -d '' VALUES_FILES_DEFAULT < <(find "${APPLICATION_DIR}/values" -maxdepth 1 -name '*.yaml' -print0)
VALUES_FILES+=(${VALUES_FILES_DEFAULT[@]})

# Include local-related values files
readarray -d '' VALUES_FILES_LOCAL < <(find "${APPLICATION_DIR}/values/local" -name '*.yaml' -print0)
VALUES_FILES+=(${VALUES_FILES_LOCAL[@]})

# Convert an array like this:
#  a.yaml b.yaml c.yaml
# to this:
#  --values a.yaml --values b.yaml --values c.yaml

VALUES=()

for VALUES_FILE in "${VALUES_FILES[@]}"
do
    VALUES+=("--values" "${VALUES_FILE}")
done

# Create namespace for jenkins instance

if ! kubectl get namespace "${JENKINS_NAMESPACE}" > /dev/null 2>&1; then
    kubectl create namespace "${JENKINS_NAMESPACE}"
fi

# Install/update/configure Jenkins instance CR

helm upgrade \
    --install \
    ${VALUES[*]} \
    "${JENKINS_RELEASE}" \
    "${JENKINS_CHART_DIR}" \
    "--namespace" "${JENKINS_NAMESPACE}" \
    --debug \
    --wait
