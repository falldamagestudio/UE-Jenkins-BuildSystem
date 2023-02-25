
###################################################################################################

.PHONY: terraform-apply-core terraform-apply-controller terraform-apply-agents

terraform-apply-core:
	cd config/fd/terraform/core && terraform init && terraform apply

terraform-apply-controller:
	cd config/fd/terraform/controller && terraform init && terraform apply

terraform-apply-agents:
	cd config/fd/terraform/agents && terraform init && terraform apply

###################################################################################################

.PHONY: install-controller update-config start-controller stop-controller restart-controller

install-controller:
	ansible-galaxy install collections -r ansible/requirements.yml
	ANSIBLE_STDOUT_CALLBACK=debug ansible-playbook -i config/fd/ansible/hosts.ini ansible/install.yml

update-config:
	ansible-galaxy install collections -r ansible/requirements.yml
	ANSIBLE_STDOUT_CALLBACK=debug ansible-playbook -i config/fd/ansible/hosts.ini ansible/update_config.yml

start-controller:
	ansible-galaxy install collections -r ansible/requirements.yml
	ANSIBLE_STDOUT_CALLBACK=debug ansible-playbook -i config/fd/ansible/hosts.ini ansible/start.yml

stop-controller:
	ansible-galaxy install collections -r ansible/requirements.yml
	ANSIBLE_STDOUT_CALLBACK=debug ansible-playbook -i config/fd/ansible/hosts.ini ansible/stop.yml

restart-controller:
	ansible-galaxy install collections -r ansible/requirements.yml
	ANSIBLE_STDOUT_CALLBACK=debug ansible-playbook -i config/fd/ansible/hosts.ini ansible/restart.yml
