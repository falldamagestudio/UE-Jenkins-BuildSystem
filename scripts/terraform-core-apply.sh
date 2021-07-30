#!/bin/bash

ENVIRONMENT_DIR=$1

if [ -z "${ENVIRONMENT_DIR}" ]; then
	echo "Usage: terraform-core-apply.sh <environment dir>"
	exit 1
fi

# Initialize Terraform
(cd "${ENVIRONMENT_DIR}/core" && terraform init) || exit $?

# Update infrastructure
(cd "${ENVIRONMENT_DIR}/core" && terraform apply) || exit $?
