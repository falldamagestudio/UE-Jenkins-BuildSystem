

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

.PHONY: install-controller update-config start-controller stop-controller restart-controller

install-controller:
	ansible-galaxy install collections -r ansible/requirements.yml
	ANSIBLE_STDOUT_CALLBACK=debug ansible-playbook -i $(ENV)/ansible/hosts.ini ansible/install.yml

update-config:
	ansible-galaxy install collections -r ansible/requirements.yml
	ANSIBLE_STDOUT_CALLBACK=debug ansible-playbook -i $(ENV)/ansible/hosts.ini ansible/update_config.yml

start-controller:
	ansible-galaxy install collections -r ansible/requirements.yml
	ANSIBLE_STDOUT_CALLBACK=debug ansible-playbook -i $(ENV)/ansible/hosts.ini ansible/start.yml

stop-controller:
	ansible-galaxy install collections -r ansible/requirements.yml
	ANSIBLE_STDOUT_CALLBACK=debug ansible-playbook -i $(ENV)/ansible/hosts.ini ansible/stop.yml

restart-controller:
	ansible-galaxy install collections -r ansible/requirements.yml
	ANSIBLE_STDOUT_CALLBACK=debug ansible-playbook -i $(ENV)/ansible/hosts.ini ansible/restart.yml
