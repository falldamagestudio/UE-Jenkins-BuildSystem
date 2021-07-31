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

# Construct config files for Plastic:
# client.conf <- contains a lot of user settings, and username + encrypted password
# cryptedservers.conf <- references a single server/cloud organization, and an associated key file
# cryptedserver.key <- contains the encrypted content password for that server/cloud organization

SECURITY_CONFIG="::0:${USERNAME}:${ENCRYPTED_PASSWORD}:"

SECURITY_CONFIG=${SECURITY_CONFIG} envsubst < "${SCRIPTS_DIR}/../application/plastic/client.conf.template" > "${SCRIPTS_DIR}/client.conf"
SERVER=${SERVER} envsubst < "${SCRIPTS_DIR}/../application/plastic/cryptedservers.conf.template" > "${SCRIPTS_DIR}/cryptedservers.conf"
ENCRYPTED_CONTENT_ENCRYPTION_KEY=${ENCRYPTED_CONTENT_ENCRYPTION_KEY} envsubst < "${SCRIPTS_DIR}/../application/plastic/cryptedserver.key.template" > "${SCRIPTS_DIR}/cryptedserver.key"

# Add config files to Kubernetes secret
# These will be used by Kubernetes build jobs that use Plastic

if `kubectl get secret plastic-config > /dev/null 2>&1`; then
    kubectl delete secret plastic-config
fi

kubectl create secret generic plastic-config \
    "--from-file=client.conf=${SCRIPTS_DIR}/client.conf" \
    "--from-file=cryptedservers.conf=${SCRIPTS_DIR}/cryptedservers.conf" \
    "--from-file=cryptedserver.key=${SCRIPTS_DIR}/cryptedserver.key"

# Add .zipped config files to GCP's Secrets Manager
# These will be used by non-Kubernetes build jobs on Windows

(cd "${SCRIPTS_DIR}" && zip plastic-config.zip client.conf cryptedservers.conf cryptedserver.key >/dev/null)

if `gcloud secrets describe plastic-config-zip >/dev/null 2>&1`; then
	gcloud secrets versions add plastic-config-zip "--data-file=${SCRIPTS_DIR}/plastic-config.zip"
else
	gcloud secrets create plastic-config-zip "--data-file=${SCRIPTS_DIR}/plastic-config.zip"
fi
gcloud secrets add-iam-policy-binding plastic-config-zip --member=serviceAccount:ue4-jenkins-agent-vm@kalms-ue-jenkins-buildsystem.iam.gserviceaccount.com --role=roles/secretmanager.secretAccessor


# Add .tgz'ed config files to GCP's Secrets Manager
# These will be used by non-Kubernetes build jobs on Linux

(cd "${SCRIPTS_DIR}" && tar -czvf plastic-config.tgz client.conf cryptedservers.conf cryptedserver.key >/dev/null)

if `gcloud secrets describe plastic-config-tgz >/dev/null 2>&1`; then
	gcloud secrets versions add plastic-config-tgz "--data-file=${SCRIPTS_DIR}/plastic-config.tgz"
else
	gcloud secrets create plastic-config-tgz "--data-file=${SCRIPTS_DIR}/plastic-config.tgz"
fi
gcloud secrets add-iam-policy-binding plastic-config-tgz --member=serviceAccount:ue4-jenkins-agent-vm@kalms-ue-jenkins-buildsystem.iam.gserviceaccount.com --role=roles/secretmanager.secretAccessor

# Remove temp files

rm "${SCRIPTS_DIR}/client.conf" "${SCRIPTS_DIR}/cryptedservers.conf" "${SCRIPTS_DIR}/cryptedserver.key" "${SCRIPTS_DIR}/plastic-config.zip" "${SCRIPTS_DIR}/plastic-config.tgz"
