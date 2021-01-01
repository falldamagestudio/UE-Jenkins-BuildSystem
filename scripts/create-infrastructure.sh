#!/bin/bash

ENVIRONMENT_DIR=$1

if [ -z "${ENVIRONMENT_DIR}" ]; then
	echo "Usage: create-infrastructure.sh <environment dir>"
	exit 1
fi

ROOT_MODULE_DIR="${BASH_SOURCE%/*}/../infrastructure/root_module"

terraform init -backend-config="${ENVIRONMENT_DIR}/backend.hcl" "${ROOT_MODULE_DIR}"

terraform apply "${ROOT_MODULE_DIR}"
