#!/bin/bash

SCRIPTS_DIR="${BASH_SOURCE%/*}/"

USERNAME=$1
API_TOKEN=$2

if [ $# -ne 2 ]; then
	1>&2 echo "Usage: set-swarm-config.sh <username> <API token>"
	exit 1
fi

if `gcloud secrets describe swarm-agent-username >/dev/null 2>&1`; then
	echo -n "$1" | gcloud secrets versions add swarm-agent-username --data-file=-
else
	echo -n "$1" | gcloud secrets create swarm-agent-username --data-file=-
	gcloud secrets add-iam-policy-binding swarm-agent-username --member=serviceAccount:ue4-jenkins-agent-vm@kalms-ue-jenkins-buildsystem.iam.gserviceaccount.com --role=roles/secretmanager.secretAccessor
fi

if `gcloud secrets describe swarm-agent-api-token >/dev/null 2>&1`; then
	echo -n "$2" | gcloud secrets versions add swarm-agent-api-token --data-file=-
else
	echo -n "$2" | gcloud secrets create swarm-agent-api-token --data-file=-
	gcloud secrets add-iam-policy-binding swarm-agent-api-token --member=serviceAccount:ue4-jenkins-agent-vm@kalms-ue-jenkins-buildsystem.iam.gserviceaccount.com --role=roles/secretmanager.secretAccessor
fi
