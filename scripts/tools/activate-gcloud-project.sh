#!/bin/bash

PROJECT_ID=$1

if [ -z "${PROJECT_ID}" ]; then
	1>&2 echo "You must specify a project id"
	exit 1
fi

gcloud config configurations activate "${PROJECT_ID}"