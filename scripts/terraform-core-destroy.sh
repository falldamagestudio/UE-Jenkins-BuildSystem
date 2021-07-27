#!/bin/bash

ENVIRONMENT_DIR=$1

if [ -z "${ENVIRONMENT_DIR}" ]; then
	echo "Usage: terraform-core-destroy.sh <environment dir>"
	exit 1
fi

# Destroy infrastructure
(cd "${ENVIRONMENT_DIR}/core" && terraform destroy) || exit $?

