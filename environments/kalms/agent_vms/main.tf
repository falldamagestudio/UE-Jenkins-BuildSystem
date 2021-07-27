module "agent_vms" {

    source = "../../../infrastructure/agent_vms"

    project_id = data.terraform_remote_state.core.outputs.project_id
    region = data.terraform_remote_state.core.outputs.region
    zone = data.terraform_remote_state.core.outputs.zone

    agent_vms_network = data.terraform_remote_state.core.outputs.agent_vms_network
    agent_vms_subnetwork = data.terraform_remote_state.core.outputs.agent_vms_subnetwork

    internal_ip_address = data.terraform_remote_state.core.outputs.internal_ip_address

    longtail_store_bucket_name = data.terraform_remote_state.core.outputs.longtail_store_bucket_name
    cloud_config_store_bucket_name = data.terraform_remote_state.core.outputs.cloud_config_store_bucket_name

    ssh_vm_public_key_windows = data.terraform_remote_state.core.outputs.ssh_vm_public_key_windows

    ssh_agent_vm_image_linux = var.ssh_agent_vm_image_linux
    ssh_agent_vm_cloud_config_url_linux = var.ssh_agent_vm_cloud_config_url_linux
    ssh_agent_vm_image_windows = var.ssh_agent_vm_image_windows

    swarm_agent_vm_image_linux = var.swarm_agent_vm_image_linux
    swarm_agent_cloud_config_url_linux = var.swarm_agent_cloud_config_url_linux
    swarm_agent_vm_image_windows = var.swarm_agent_vm_image_windows

    ssh_agent_docker_image_url_linux = var.ssh_agent_docker_image_url_linux
    ssh_agent_docker_image_url_windows = var.ssh_agent_docker_image_url_windows

    swarm_agent_docker_image_url_linux = var.swarm_agent_docker_image_url_linux
    swarm_agent_docker_image_url_windows = var.swarm_agent_docker_image_url_windows

    windows_build_agents = var.windows_build_agents
    linux_build_agents = var.linux_build_agents

    windows_build_agent_templates = var.windows_build_agent_templates
    linux_build_agent_templates = var.linux_build_agent_templates

}
