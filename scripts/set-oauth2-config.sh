#!/bin/bash

SCRIPTS_DIR="${BASH_SOURCE%/*}/"

ENVIRONMENT_DIR=$1
OAUTH2_CLIENT_ID=$2
OAUTH2_CLIENT_SECRET=$3

if [ $# -ne 3 ]; then
	1>&2 echo "Usage: set-oauth2-config.sh <environment dir> <OAuth2 Client ID> <OAuth2 Client Secret>"
	exit 1
fi

PROJECT_ID=$(jq -r ".project_id" "${ENVIRONMENT_DIR}/gcloud-config.json")

if [ -z "${PROJECT_ID}" ]; then
	1>&2 echo "You must specify project_id in gcloud-config.json"
	exit 1
fi

"${SCRIPTS_DIR}/tools/activate-gcloud-project.sh" "${PROJECT_ID}" || exit 1

OAUTH2_CLIENT_ID_SECRET_NAME=OAUTH2_CLIENT_ID

if gcloud secrets describe "${OAUTH2_CLIENT_ID_SECRET_NAME}" >/dev/null 2>&1; then
	echo -n "${OAUTH2_CLIENT_ID}" | gcloud secrets versions add "${OAUTH2_CLIENT_ID_SECRET_NAME}" --data-file=-
else
	echo -n "${OAUTH2_CLIENT_ID}" | gcloud secrets create "${OAUTH2_CLIENT_ID_SECRET_NAME}" --data-file=- --labels=jenkins-credentials-type=string --replication-policy=automatic
fi

OAUTH2_CLIENT_SECRET_SECRET_NAME=OAUTH2_CLIENT_SECRET

if gcloud secrets describe "${OAUTH2_CLIENT_SECRET_SECRET_NAME}" >/dev/null 2>&1; then
        echo -n "${OAUTH2_CLIENT_SECRET}" | gcloud secrets versions add "${OAUTH2_CLIENT_SECRET_SECRET_NAME}" --data-file=-
else
        echo -n "${OAUTH2_CLIENT_SECRET}" | gcloud secrets create "${OAUTH2_CLIENT_SECRET_SECRET_NAME}" --data-file=- --labels=jenkins-credentials-type=string --replication-policy=automatic
fi


