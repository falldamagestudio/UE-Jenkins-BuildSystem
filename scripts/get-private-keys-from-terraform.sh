#!/bin/bash

SCRIPTS_DIR="${BASH_SOURCE%/*}/"

CONFIG_DIR="${SCRIPTS_DIR}/../config"

if [ $# -ne 0 ]; then
	1>&2 echo "Usage: get-private-keys-from-terraform.sh"
	exit 1
fi

ANSIBLE_PRIVATE_KEY=$(cd "${CONFIG_DIR}/terraform/remote/controller" && terraform show -json | jq -r ".values.outputs.controller_vm_ansible_private_key.value")
echo "${ANSIBLE_PRIVATE_KEY}" > "${CONFIG_DIR}/ansible/remote/ansible.private_key"
chmod go-r "${CONFIG_DIR}/ansible/remote/ansible.private_key"

CONTROLLER_VM_SERVICE_ACCOUNT_KEY=$(cd "${CONFIG_DIR}/terraform/remote/controller" && terraform show -json | jq -r ".values.outputs.controller_vm_service_account_key.value")
echo "${CONTROLLER_VM_SERVICE_ACCOUNT_KEY}" > "${CONFIG_DIR}/docker/shared/google_application_credentials.json"
chmod go-r "${CONFIG_DIR}/docker/shared/google_application_credentials.json"
