#!/bin/bash

SCRIPTS_DIR="${BASH_SOURCE%/*}/"

ENVIRONMENT_DIR=$1
USERNAME=$2
API_TOKEN=$3

if [ $# -ne 3 ]; then
	1>&2 echo "Usage: set-swarm-config.sh <environment dir> <username> <API token>"
	exit 1
fi

PROJECT_ID=`cat "${ENVIRONMENT_DIR}/gcloud-config.json" | jq -r ".project_id"`

if [ -z "${PROJECT_ID}" ]; then
	1>&2 echo "You must specify project_id in gcloud-config.json"
	exit 1
fi

"${SCRIPTS_DIR}/tools/activate-gcloud-project.sh" "${PROJECT_ID}" || exit 1

if `gcloud secrets describe swarm-agent-username >/dev/null 2>&1`; then
	echo -n "${USERNAME}" | gcloud secrets versions add swarm-agent-username --data-file=-
else
	echo -n "${USERNAME}" | gcloud secrets create swarm-agent-username --data-file=-
fi
gcloud secrets add-iam-policy-binding swarm-agent-username --member=serviceAccount:ue-jenkins-agent-vm@${PROJECT_ID}.iam.gserviceaccount.com --role=roles/secretmanager.secretAccessor

if `gcloud secrets describe swarm-agent-api-token >/dev/null 2>&1`; then
	echo -n "${API_TOKEN}" | gcloud secrets versions add swarm-agent-api-token --data-file=-
else
	echo -n "${API_TOKEN}" | gcloud secrets create swarm-agent-api-token --data-file=-
fi
gcloud secrets add-iam-policy-binding swarm-agent-api-token --member=serviceAccount:ue-jenkins-agent-vm@${PROJECT_ID}.iam.gserviceaccount.com --role=roles/secretmanager.secretAccessor
