#!/bin/bash

SCRIPTS_DIR="${BASH_SOURCE%/*}"
APPLICATION_DIR="${SCRIPTS_DIR}/../application"

ENVIRONMENT_DIR=$1
GITHUB_PAT=$2

if [ $# -ne 2 ]; then
	1>&2 echo "Usage: set-github-pat.sh <environment dir> <personal access token for GitHub>"
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

cat "${APPLICATION_DIR}/github-pat.yaml" | sed "s/\<password\>/${GITHUB_PAT}/" | kubectl apply -f -
