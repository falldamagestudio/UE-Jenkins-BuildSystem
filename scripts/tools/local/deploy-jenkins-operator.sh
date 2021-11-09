#!/bin/bash

HELM_CONFIG_FILE=$1

OPERATOR_DIR=${BASH_SOURCE%/*}/../../../operator

OPERATOR_CHART_NAME="jenkins-operator"
OPERATOR_CHART_VERSION="0.5.3"
OPERATOR_RELEASE="jenkins-operator"

HELM_CONFIG_JSON=$(cat "${HELM_CONFIG_FILE}")
OPERATOR_NAMESPACE=$(echo "${HELM_CONFIG_JSON}" | jq -r ".namespace")

VALUES_FILES=()

# Include platform-independent values files
readarray -d '' VALUES_FILES_DEFAULT < <(find "${OPERATOR_DIR}/values" -maxdepth 1 -name '*.yaml' -print0)
VALUES_FILES+=(${VALUES_FILES_DEFAULT[@]})

# Include local-related values files
readarray -d '' VALUES_FILES_LOCAL < <(find "${OPERATOR_DIR}/values/local" -name '*.yaml' -print0)
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

# Create namespace for jenkins operator

if ! kubectl get namespace "${OPERATOR_NAMESPACE}" > /dev/null 2>&1; then
    kubectl create namespace "${OPERATOR_NAMESPACE}"
fi

# Install/update/configure Jenkins Operator

helm upgrade \
    --install \
    ${VALUES[*]} \
    "${OPERATOR_RELEASE}" \
    "${OPERATOR_CHART_NAME}" \
    "--version" "${OPERATOR_CHART_VERSION}" \
    "--repo" "https://raw.githubusercontent.com/jenkinsci/kubernetes-operator/master/chart" \
    "--namespace" "${OPERATOR_NAMESPACE}" \
    --debug \
    --wait
