
# TODO: remove hardcoded controller host IP
# This should be sourced from $(ENV)/... somewhere
CONTROLLER_HOST_IP:=130.211.54.100


# Default to 'fd' environment, if the ENV variable is not set
ifndef ENV
ENV:=config/fd
endif

###################################################################################################

.PHONY: terraform-apply-core terraform-apply-controller terraform-apply-agents

terraform-apply-core:
	cd $(ENV)/terraform/core && terraform init && terraform apply

terraform-apply-controller:
	cd $(ENV)/terraform/controller && terraform init && terraform apply

terraform-apply-agents:
	cd $(ENV)/terraform/agents && terraform init && terraform apply

###################################################################################################

.PHONY: terraform-destroy-core terraform-destroy-controller terraform-destroy-agents

terraform-destroy-core:
	cd $(ENV)/terraform/core && terraform init && terraform destroy

terraform-destroy-controller:
	cd $(ENV)/terraform/controller && terraform init && terraform destroy

terraform-destroy-agents:
	cd $(ENV)/terraform/agents && terraform init && terraform destroy

###################################################################################################

.PHONY: ssh-controller

ssh-controller:
	ssh -i $(ENV)/ansible/ansible.private_key ansible@$(CONTROLLER_HOST_IP)

###################################################################################################

.PHONY: install-controller update-controller-config start-controller stop-controller restart-controller

install-controller:
	ansible-galaxy install collections -r ansible/requirements.yml
	ANSIBLE_STDOUT_CALLBACK=debug ansible-playbook -i $(ENV)/ansible/hosts.ini ansible/install_controller.yml

update-controller-config:
	ansible-galaxy install collections -r ansible/requirements.yml
	ANSIBLE_STDOUT_CALLBACK=debug ansible-playbook -i $(ENV)/ansible/hosts.ini ansible/update_controller_config.yml

start-controller:
	ansible-galaxy install collections -r ansible/requirements.yml
	ANSIBLE_STDOUT_CALLBACK=debug ansible-playbook -i $(ENV)/ansible/hosts.ini ansible/start_controller.yml

stop-controller:
	ansible-galaxy install collections -r ansible/requirements.yml
	ANSIBLE_STDOUT_CALLBACK=debug ansible-playbook -i $(ENV)/ansible/hosts.ini ansible/stop_controller.yml

restart-controller:
	ansible-galaxy install collections -r ansible/requirements.yml
	ANSIBLE_STDOUT_CALLBACK=debug ansible-playbook -i $(ENV)/ansible/hosts.ini ansible/restart_controller.yml

###################################################################################################

.PHONY: install-controller-agent update-controller-agent-config start-controller-agent stop-controller-agent restart-controller-agent

install-controller-agent:
	ansible-galaxy install collections -r ansible/requirements.yml
	ANSIBLE_STDOUT_CALLBACK=debug ansible-playbook -i $(ENV)/ansible/hosts.ini ansible/install_controller_agent.yml

update-controller-agent-config:
	ansible-galaxy install collections -r ansible/requirements.yml
	ANSIBLE_STDOUT_CALLBACK=debug ansible-playbook -i $(ENV)/ansible/hosts.ini ansible/update_controller_agent_config.yml

start-controller-agent:
	ansible-galaxy install collections -r ansible/requirements.yml
	ANSIBLE_STDOUT_CALLBACK=debug ansible-playbook -i $(ENV)/ansible/hosts.ini ansible/start_controller_agent.yml

stop-controller-agent:
	ansible-galaxy install collections -r ansible/requirements.yml
	ANSIBLE_STDOUT_CALLBACK=debug ansible-playbook -i $(ENV)/ansible/hosts.ini ansible/stop_controller_agent.yml

restart-controller-agent:
	ansible-galaxy install collections -r ansible/requirements.yml
	ANSIBLE_STDOUT_CALLBACK=debug ansible-playbook -i $(ENV)/ansible/hosts.ini ansible/restart_controller_agent.yml
