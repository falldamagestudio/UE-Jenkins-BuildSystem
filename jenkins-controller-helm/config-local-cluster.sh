#!/bin/bash

GOOGLE_OAUTH_CLIENT_ID=$1
GOOGLE_OAUTH_CLIENT_SECRET=$2

cat jenkins-controller-from-manual-config.yaml | sed s/\$\{GOOGLE_OAUTH_CLIENT_ID\}/`echo ${GOOGLE_OAUTH_CLIENT_ID} | base64 --wrap 0`/ | sed s/\$\{GOOGLE_OAUTH_CLIENT_SECRET\}/`echo ${GOOGLE_OAUTH_CLIENT_SECRET} | base64 --wrap 0`/ | kubectl apply -f -

# Local node should be part of agent node pool
kubectl label nodes --overwrite docker-desktop jenkins-agent-node-pool=true