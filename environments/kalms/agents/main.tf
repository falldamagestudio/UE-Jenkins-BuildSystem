module "agents" {

    source = "../../../infrastructure/agents"

    project_id = data.terraform_remote_state.core.outputs.project_id
    zone = data.terraform_remote_state.core.outputs.zone

    agent_vms_network = data.terraform_remote_state.core.outputs.agent_vms_network
    agent_vms_subnetwork = data.terraform_remote_state.core.outputs.agent_vms_subnetwork

    internal_ip_address = data.terraform_remote_state.core.outputs.internal_ip_address

    longtail_store_bucket_name = data.terraform_remote_state.core.outputs.longtail_store_bucket_name
    cloud_config_store_bucket_name = data.terraform_remote_state.core.outputs.cloud_config_store_bucket_name

    ssh_agent = {
        linux = var.ssh_agent.linux
        windows = {
            vm_image_name = var.ssh_agent.windows.vm_image_name
            vm_ssh_public_key = data.terraform_remote_state.core.outputs.ssh_vm_public_key_windows
            docker_image_url = var.ssh_agent.windows.docker_image_url
        }
    }
    swarm_agent = var.swarm_agent

    windows_build_agents = var.windows_build_agents
    linux_build_agents = var.linux_build_agents

    dynamic_agent_templates = var.dynamic_agent_templates
}
