#!/bin/bash

APPLICATION_DIR="${BASH_SOURCE%/*}/../../../application"

JENKINS_CHART_DIR="${APPLICATION_DIR}/chart"
JENKINS_RELEASE="jenkins"
JENKINS_NAMESPACE="jenkins"

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
