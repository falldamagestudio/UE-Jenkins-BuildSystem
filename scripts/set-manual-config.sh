#!/bin/bash

ENVIRONMENT_DIR=$1

SCRIPTS_DIR="${BASH_SOURCE%/*}/"


if [ -z "${ENVIRONMENT_DIR}" ]; then
	1>&2 echo "Usage: set-manual-config.sh <environment dir> <vars>"
	exit 1
fi

CLUSTER_TYPE=`cat "${ENVIRONMENT_DIR}/kube-config.json" | jq -r ".cluster_type"`

if [ -z "${CLUSTER_TYPE}" ]; then
	1>&2 echo "You must specify cluster_type in kube-config.json"
	exit 1
fi

CLUSTER_NAME=`cat "${ENVIRONMENT_DIR}/kube-config.json" | jq -r ".cluster_name"`

if [ -z "${CLUSTER_NAME}" ]; then
	1>&2 echo "You must specify cluster_name in kube-config.json"
	exit 1
fi

"${SCRIPTS_DIR}/tools/activate_cluster.sh" "${CLUSTER_NAME}" || exit 1

shift

if [ "${CLUSTER_TYPE}" = "local" ] || [ "${CLUSTER_TYPE}" = "gke" ]; then
	"${SCRIPTS_DIR}/tools/${CLUSTER_TYPE}/set-manual-config.sh" $@ || exit 1
else
	1>&2 echo "Cluster type ${CLUSTER_TYPE} is not supported"
	exit 1
fi
