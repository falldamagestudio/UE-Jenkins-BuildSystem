module "agent_vms" {

  source = "../services/agent_vms"

  region = var.region

  agent_vms_network = var.agent_vms_network
  agent_vms_subnetwork = var.agent_vms_subnetwork

  ssh_agent_vm_image_linux = var.ssh_agent_vm_image_linux
  ssh_agent_vm_cloud_config_url_linux = var.ssh_agent_vm_cloud_config_url_linux
  ssh_agent_vm_image_windows = var.ssh_agent_vm_image_windows

  swarm_agent_vm_image_linux = var.swarm_agent_vm_image_linux
  swarm_agent_cloud_config_url_linux = var.swarm_agent_cloud_config_url_linux
  swarm_agent_vm_image_windows = var.swarm_agent_vm_image_windows

  windows_build_agents = var.windows_build_agents
  linux_build_agents = var.linux_build_agents

  linux_build_agent_templates = var.linux_build_agent_templates
  windows_build_agent_templates = var.windows_build_agent_templates

  cloud_config_store_bucket_id = var.cloud_config_store_bucket_name
  longtail_store_bucket_id = var.longtail_store_bucket_name

  settings = {
    jenkins-url = "http://${var.internal_ip_address}"
    ssh-agent-image-url-linux = var.ssh_agent_docker_image_url_linux
    ssh-agent-image-url-windows = var.ssh_agent_docker_image_url_windows
    swarm-agent-image-url-linux = var.swarm_agent_docker_image_url_linux
    swarm-agent-image-url-windows = var.swarm_agent_docker_image_url_windows
    ssh-vm-public-key-windows = var.ssh_vm_public_key_windows
  }
}