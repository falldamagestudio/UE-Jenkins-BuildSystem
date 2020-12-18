#!/bin/bash

GOOGLE_OAUTH_CLIENT_ID=$1
GOOGLE_OAUTH_CLIENT_SECRET=$2

kubectl delete secret jenkins-controller-from-manual-config
kubectl create secret generic jenkins-controller-from-manual-config \
    --from-literal=google_oauth_client_id=${GOOGLE_OAUTH_CLIENT_ID} \
    --from-literal=google_oauth_client_secret=${GOOGLE_OAUTH_CLIENT_SECRET}
