#!/bin/bash

SCRIPTS_DIR="${BASH_SOURCE%/*}/"

ENVIRONMENT_DIR="${SCRIPTS_DIR}/../config"
GITHUB_PAT=$1

if [ $# -ne 1 ]; then
	1>&2 echo "Usage: set-github-pat.sh <personal access token for GitHub>"
	exit 1
fi

PROJECT_ID=$(jq -r ".project_id" "${ENVIRONMENT_DIR}/terraform/remote/gcloud-config.json")

if [ -z "${PROJECT_ID}" ]; then
	1>&2 echo "You must specify project_id in gcloud-config.json"
	exit 1
fi

"${SCRIPTS_DIR}/tools/activate-gcloud-project.sh" "${PROJECT_ID}" || exit 1

SECRET_NAME=github-user

if gcloud secrets describe github-user >/dev/null 2>&1; then
	echo -n "${GITHUB_PAT}" | gcloud secrets versions add github-user --data-file=-
else
	echo -n "${GITHUB_PAT}" | gcloud secrets create "${SECRET_NAME}" --data-file=- --labels=jenkins-credentials-type=username-password,jenkins-credentials-username=github-user --replication-policy=automatic
fi
# gcloud secrets add-iam-policy-binding github-user "--member=serviceAccount:ue-jenkins-controller@${PROJECT_ID}.iam.gserviceaccount.com" --role=roles/secretmanager.secretAccessor

