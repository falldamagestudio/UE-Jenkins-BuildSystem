#!/bin/bash

ENVIRONMENT_DIR=$1

if [ -z "${ENVIRONMENT_DIR}" ]; then
	echo "Usage: terraform-agent_vms-apply.sh <environment dir>"
	exit 1
fi

# Initialize Terraform
(cd "${ENVIRONMENT_DIR}/agent_vms" && terraform init -backend-config="backend.hcl") || exit $?

# Update infrastructure
(cd "${ENVIRONMENT_DIR}/agent_vms" && terraform apply -var-file="terraform.tfvars") || exit $?
