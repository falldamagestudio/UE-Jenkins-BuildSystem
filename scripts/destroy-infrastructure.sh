#!/bin/bash

ENVIRONMENT_DIR=$1

if [ -z "${ENVIRONMENT_DIR}" ]; then
	echo "Usage: destroy-infrastructure.sh <environment dir>"
	exit 1
fi

RELATIVE_ROOT_MODULE_DIR="../../infrastructure/root_module"

# Update infrastructure
(cd "${ENVIRONMENT_DIR}" && terraform destroy -var-file="terraform.tfvars" "${RELATIVE_ROOT_MODULE_DIR}") || exit $?
