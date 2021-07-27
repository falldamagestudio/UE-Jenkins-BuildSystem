#!/bin/bash

ENVIRONMENT_DIR=$1

if [ -z "${ENVIRONMENT_DIR}" ]; then
	echo "Usage: terraform-agent_vms-destroy.sh <environment dir>"
	exit 1
fi

# Destroy infrastructure
(cd "${ENVIRONMENT_DIR}/agent_vms" && terraform destroy) || exit $?

