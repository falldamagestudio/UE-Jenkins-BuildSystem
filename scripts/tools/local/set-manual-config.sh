#!/bin/bash

if [[ $# -ne 2 ]]; then
    1>&2 echo "Usage: set-manual-config.sh <GOOGLE_OAUTH_CLIENT_ID> <GOOGLE_OAUTH_CLIENT_SECRET>"
    exit 1
fi

GOOGLE_OAUTH_CLIENT_ID=$1
GOOGLE_OAUTH_CLIENT_SECRET=$2

if `kubectl get secret jenkins-controller-from-manual-config > /dev/null 2>&1`; then
    kubectl delete secret jenkins-controller-from-manual-config
fi

kubectl create secret generic jenkins-controller-from-manual-config \
    --from-literal=google_oauth_client_id=$GOOGLE_OAUTH_CLIENT_ID \
    --from-literal=google_oauth_client_secret=$GOOGLE_OAUTH_CLIENT_SECRET
