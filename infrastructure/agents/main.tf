module "agents" {

  source = "./agents"

  cloud_config_store_bucket_id = var.cloud_config_store_bucket_name
  longtail_store_bucket_id = var.longtail_store_bucket_name

  swarm_agent_settings = {
    jenkins-url = "http://${var.internal_ip_address}"
    swarm-agent-image-url-linux = var.swarm_agent.linux.docker_image_url
    swarm-agent-image-url-windows = var.swarm_agent.windows.docker_image_url
  }

  ssh_agent_settings = {
    ssh-agent-image-url-linux = var.ssh_agent.linux.docker_image_url
    ssh-agent-image-url-windows = var.ssh_agent.windows.docker_image_url
    ssh-vm-public-key-windows = var.ssh_agent.windows.vm_ssh_public_key
  }
}

module "dynamic_agents" {

  source = "./dynamic_agents"

  depends_on = [ module.agents ]

  agent_vms_network = var.agent_vms_network
  agent_vms_subnetwork = var.agent_vms_subnetwork

  ssh_agent = var.ssh_agent

  dynamic_agent_templates = var.dynamic_agent_templates

  agent_service_account_email = module.agents.agent_service_account_email
}

module "static_agents" {

  source = "./static_agents"

  depends_on = [ module.agents ]

  agent_vms_network = var.agent_vms_network
  agent_vms_subnetwork = var.agent_vms_subnetwork

  swarm_agent = var.swarm_agent

  static_agent_templates = var.static_agent_templates
  static_agents = var.static_agents

  agent_service_account_email = module.agents.agent_service_account_email
}
