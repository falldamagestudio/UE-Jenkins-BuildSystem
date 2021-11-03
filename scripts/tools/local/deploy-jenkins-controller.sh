#!/bin/bash

APPLICATION_DIR="${BASH_SOURCE%/*}/../../../application"

JENKINS_NAMESPACE="jenkins"

# Create namespace for jenkins instance

if ! kubectl get namespace "${JENKINS_NAMESPACE}" > /dev/null 2>&1; then
    kubectl create namespace "${JENKINS_NAMESPACE}"
fi

# Install/update/configure Jenkins CR

kubectl apply -f "${APPLICATION_DIR}/jenkins_instance.yaml"
