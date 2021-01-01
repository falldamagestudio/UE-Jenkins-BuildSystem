#!/bin/bash

ENVIRONMENT_DIR=$1

APPLICATION_DIR="${BASH_SOURCE%/*}/../application"


if [ -z "${ENVIRONMENT_DIR}" ]; then
	1>&2 echo "Usage: create-infrastructure.sh <environment dir>"
	exit 1
fi

CHART_VERSION=`cat "${ENVIRONMENT_DIR}/helm-config.json" | jq -r ".chart_version"`

if [ -z "${CHART_VERSION}" ]; then
	1>&2 echo "You must specify chart version in helm-config.json"
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

./tools/activate_cluster.sh "${CLUSTER_NAME}" || exit 1

if [ "${CLUSTER_TYPE}" = "local" ]; then

	./tools/local/deploy.sh "${CHART_VERSION}" || exit 1

	PORT_FORWARD=`cat "${ENVIRONMENT_DIR}/kube-config.json" | jq -r ".port_forward"`

	if [ -z "${PORT_FORWARD}" ]; then
		1>&2 echo "You must specify port_forward in kube-config.json for local clusters"
		exit 1
	fi

	if [ "${PORT_FORWARD}" == "yes" ]; then

		./tools/local/port_forward.sh

	fi

else
	1>&2 echo "Cluster type ${CLUSTER_TYPE} is not supported"
	exit 1
fi
