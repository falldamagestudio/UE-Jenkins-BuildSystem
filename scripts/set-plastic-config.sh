#!/bin/bash

SCRIPTS_DIR="${BASH_SOURCE%/*}/"

ENVIRONMENT_DIR=$1
USERNAME=$2
ENCRYPTED_PASSWORD=$3
SERVER=$4
ENCRYPTED_CONTENT_ENCRYPTION_KEY=$5

if [ $# -ne 5 ]; then
	1>&2 echo "Usage: set-plastic-config.sh <environment dir> <username> <encrypted password> <server> <encrypted content encryption key>"
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

SECURITY_CONFIG="::0:${USERNAME}:${ENCRYPTED_PASSWORD}:"

SECURITY_CONFIG=${SECURITY_CONFIG} envsubst < "${SCRIPTS_DIR}/../application/plastic/client.conf.template" > "${SCRIPTS_DIR}/client.conf"
SERVER=${SERVER} envsubst < "${SCRIPTS_DIR}/../application/plastic/cryptedservers.conf.template" > "${SCRIPTS_DIR}/cryptedservers.conf"
ENCRYPTED_CONTENT_ENCRYPTION_KEY=${ENCRYPTED_CONTENT_ENCRYPTION_KEY} envsubst < "${SCRIPTS_DIR}/../application/plastic/cryptedserver.key.template" > "${SCRIPTS_DIR}/cryptedserver.key"

if `kubectl get secret plastic-config > /dev/null 2>&1`; then
    kubectl delete secret plastic-config
fi

kubectl create secret generic plastic-config \
    "--from-file=client.conf=${SCRIPTS_DIR}/client.conf" \
    "--from-file=cryptedservers.conf=${SCRIPTS_DIR}/cryptedservers.conf" \
    "--from-file=cryptedserver.key=${SCRIPTS_DIR}/cryptedserver.key"

rm "${SCRIPTS_DIR}/client.conf" "${SCRIPTS_DIR}/cryptedservers.conf" "${SCRIPTS_DIR}/cryptedserver.key"
