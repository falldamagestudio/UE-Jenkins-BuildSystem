#!/bin/bash

ENVIRONMENT_DIR=$1

if [ -z "${ENVIRONMENT_DIR}" ]; then
	echo "Usage: create-infrastructure.sh <environment dir>"
	exit 1
fi

RELATIVE_ROOT_MODULE_DIR="../../infrastructure/root_module"

# Initialize Terraform
(cd "${ENVIRONMENT_DIR}" && terraform init -backend-config="backend.hcl" "${RELATIVE_ROOT_MODULE_DIR}") || exit $?

# Enable APIs in GCP
#
# "terraform apply" will check state of all resources before starting application.
# In order to check state for all items in the tf project, a number of Google APIs
#  need to be enabled first (otherwise the state check will fail with permission errors).
# Those APIs are not yet enabled when bringing up the infrastructure from scratch - and thus,
#  the first apply would fail. This script allows us to bring up google APIs first and then
#  handle the full infrastructure in setup-infrastructure.sh.
#
# The google APIs should ideally be a separate tf project. That requires having a separate state store and more refactoring,
#   so we cheat a bit by running only the first portion of the tf project (that will only state check the google APIs,
#   which is permitted, and it will then enable the APIs that are necessary for a full run).
(cd "${ENVIRONMENT_DIR}" && terraform apply -var-file="terraform.tfvars" -target=module.google_apis "${RELATIVE_ROOT_MODULE_DIR}") || exit $?
