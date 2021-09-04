#!/bin/bash

SCRIPTS_DIR="${BASH_SOURCE%/*}/"

ENVIRONMENT_DIR=$1
USERNAME=$2
ENCRYPTED_PASSWORD=$3
SERVER=$4
ENCRYPTED_CONTENT_ENCRYPTION_KEY=$5

if [ $# -ne 5 ]; then
	1>&2 echo "Usage: set-plastic-kubernetes-config.sh <environment dir> <username> <encrypted password> <server> <encrypted content encryption key>"
	exit 1
fi

if [ "${ENCRYPTED_PASSWORD::5}" != "|SoC|" ]; then
	1>&2 echo "Error: Encrypted password should begin with '|SoC|'"
	exit 1
fi

if [ "${ENCRYPTED_CONTENT_ENCRYPTION_KEY::5}" != "|SoC|" ]; then
	1>&2 echo "Error: Encrypted content encryption key should begin with '|SoC|'"
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

# Construct config files for Plastic:
# client.conf <- contains a lot of user settings, and username + encrypted password
# cryptedservers.conf <- references a single server/cloud organization, and an associated key file
# cryptedserver.key <- contains the encrypted content password for that server/cloud organization

SECURITY_CONFIG="::0:${USERNAME}:${ENCRYPTED_PASSWORD:5}:" # The string in client.conf should not include the '|SoC|' prefix

SERVER=${SERVER} SECURITY_CONFIG=${SECURITY_CONFIG} envsubst < "${SCRIPTS_DIR}/../application/plastic/client.conf.template" > "${SCRIPTS_DIR}/client.conf"
SERVER=${SERVER} envsubst < "${SCRIPTS_DIR}/../application/plastic/cryptedservers.conf.template" > "${SCRIPTS_DIR}/cryptedservers.conf"
ENCRYPTED_CONTENT_ENCRYPTION_KEY=${ENCRYPTED_CONTENT_ENCRYPTION_KEY} envsubst < "${SCRIPTS_DIR}/../application/plastic/cryptedserver.key.template" > "${SCRIPTS_DIR}/cryptedserver.key"

# Add config files to Kubernetes secret
# These will be used by Kubernetes build jobs that use Plastic

if kubectl get secret plastic-config > /dev/null 2>&1; then
    kubectl delete secret plastic-config
fi

kubectl create secret generic plastic-config \
    "--from-file=client.conf=${SCRIPTS_DIR}/client.conf" \
    "--from-file=cryptedservers.conf=${SCRIPTS_DIR}/cryptedservers.conf" \
    "--from-file=cryptedserver.key=${SCRIPTS_DIR}/cryptedserver.key"

# Remove temp files

rm "${SCRIPTS_DIR}/client.conf" "${SCRIPTS_DIR}/cryptedservers.conf" "${SCRIPTS_DIR}/cryptedserver.key"
