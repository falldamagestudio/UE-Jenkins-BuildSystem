#!/bin/bash

ENVIRONMENT_DIR=$1

if [ -z "${ENVIRONMENT_DIR}" ]; then
	echo "Usage: create-infrastructure.sh <environment dir>"
	exit 1
fi

RELATIVE_ROOT_MODULE_DIR="../../infrastructure/root_module"

(cd "${ENVIRONMENT_DIR}" && tfenv use) || exit $?

(cd "${ENVIRONMENT_DIR}" && terraform init -backend-config="backend.hcl" "${RELATIVE_ROOT_MODULE_DIR}") || exit $?

(cd "${ENVIRONMENT_DIR}" && terraform apply -var-file="terraform.tfvars" "${RELATIVE_ROOT_MODULE_DIR}") || exit $?
