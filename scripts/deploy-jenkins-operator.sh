#!/bin/bash

ENVIRONMENT_DIR=$1

SCRIPTS_DIR="${BASH_SOURCE%/*}"

if [ $# -ne 1 ]; then
	1>&2 echo "Usage: deploy-jenkins-operator.sh <environment dir>"
	exit 1
fi

CLUSTER_TYPE=$(jq -r ".cluster_type" "${ENVIRONMENT_DIR}/kube-config.json")

if [ -z "${CLUSTER_TYPE}" ]; then
	1>&2 echo "You must specify cluster_type in kube-config.json"
	exit 1
fi

CLUSTER_NAME=$(jq -r ".cluster_name" "${ENVIRONMENT_DIR}/kube-config.json")

if [ -z "${CLUSTER_NAME}" ]; then
	1>&2 echo "You must specify cluster_name in kube-config.json"
	exit 1
fi

"${SCRIPTS_DIR}/tools/activate_cluster.sh" "${CLUSTER_NAME}" || exit 1

if [ "${CLUSTER_TYPE}" = "local" ] || [ "${CLUSTER_TYPE}" = "gke" ]; then
	"${SCRIPTS_DIR}/tools/${CLUSTER_TYPE}/deploy-jenkins-operator.sh" "${ENVIRONMENT_DIR}/operator-helm-config.json" || exit 1
else
	1>&2 echo "Cluster type ${CLUSTER_TYPE} is not supported"
	exit 1
fi
