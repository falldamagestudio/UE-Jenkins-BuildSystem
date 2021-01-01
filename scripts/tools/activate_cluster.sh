#!/bin/bash

CLUSTER_NAME=$1

if [ -z "${CLUSTER_NAME}" ]; then
	1>&2 echo "You must specify a cluster name"
	exit 1
fi

kubectl config use-context $1
