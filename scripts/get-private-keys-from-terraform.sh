#!/bin/bash

SCRIPTS_DIR="${BASH_SOURCE%/*}/"

ENVIRONMENT_DIR=$1

if [ $# -ne 1 ]; then
	1>&2 echo "Usage: get-private-keys-from-terraform.sh <environment dir>"
	exit 1
fi

ANSIBLE_PRIVATE_KEY=$(cd "${ENVIRONMENT_DIR}/terraform/controller" && terraform show -json | jq -r ".values.outputs.controller_vm_ansible_private_key.value")
echo "${ANSIBLE_PRIVATE_KEY}" > "${ENVIRONMENT_DIR}/ansible/ansible.private_key"
chmod go-r "${ENVIRONMENT_DIR}/ansible/ansible.private_key"

CONTROLLER_VM_SERVICE_ACCOUNT_KEY=$(cd "${ENVIRONMENT_DIR}/terraform/controller" && terraform show -json | jq -r ".values.outputs.controller_vm_service_account_key.value")
echo "${CONTROLLER_VM_SERVICE_ACCOUNT_KEY}" > "${ENVIRONMENT_DIR}/../shared/docker/google_application_credentials.json"
chmod go-r "${ENVIRONMENT_DIR}/../shared/docker/google_application_credentials.json"
