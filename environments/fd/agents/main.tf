module "agents" {

    source = "../../../infrastructure/agents"

    project_id = data.terraform_remote_state.core.outputs.project_id
    zone = data.terraform_remote_state.core.outputs.zone

    agent_vms_network = data.terraform_remote_state.core.outputs.agent_vms_network
    agent_vms_subnetwork = data.terraform_remote_state.core.outputs.agent_vms_subnetwork

    internal_ip_address = data.terraform_remote_state.core.outputs.internal_ip_address

    longtail_store_bucket_name = data.terraform_remote_state.core.outputs.longtail_store_bucket_name
    cloud_config_store_bucket_name = data.terraform_remote_state.core.outputs.cloud_config_store_bucket_name

    windows_vm_ssh_public_key = data.terraform_remote_state.core.outputs.ssh_vm_public_key_windows

    docker_ssh_agent = var.docker_ssh_agent
    docker_swarm_agent = var.docker_swarm_agent

    docker_dynamic_agent_templates = var.docker_dynamic_agent_templates

    docker_static_agent_templates = var.docker_static_agent_templates
    docker_static_agents = var.docker_static_agents

    ssh_agent = var.ssh_agent
    swarm_agent = var.swarm_agent

    dynamic_agent_templates = var.dynamic_agent_templates

    static_agent_templates = var.static_agent_templates
    static_agents = var.static_agents
}
