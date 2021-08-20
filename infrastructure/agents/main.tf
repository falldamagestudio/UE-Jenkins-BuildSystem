module "agents" {

  source = "./agents"

  cloud_config_store_bucket_id = var.cloud_config_store_bucket_name
  longtail_store_bucket_id = var.longtail_store_bucket_name

  swarm_agent_settings = {
    jenkins-url = "http://${var.internal_ip_address}"
    swarm-agent-image-url-linux = var.docker_swarm_agent.linux.docker_image_url
    swarm-agent-image-url-windows = var.docker_swarm_agent.windows.docker_image_url
  }

  ssh_agent_settings = {
    ssh-agent-image-url-linux = var.docker_ssh_agent.linux.docker_image_url
    ssh-agent-image-url-windows = var.docker_ssh_agent.windows.docker_image_url
    ssh-vm-public-key-windows = var.windows_vm_ssh_public_key
  }
}

module "docker_dynamic_agents" {

  source = "./docker_dynamic_agents"

  depends_on = [ module.agents ]

  agent_vms_network = var.agent_vms_network
  agent_vms_subnetwork = var.agent_vms_subnetwork

  docker_ssh_agent = var.docker_ssh_agent

  docker_dynamic_agent_templates = var.docker_dynamic_agent_templates

  agent_service_account_email = module.agents.agent_service_account_email
}

module "docker_static_agents" {

  source = "./docker_static_agents"

  depends_on = [ module.agents ]

  agent_vms_network = var.agent_vms_network
  agent_vms_subnetwork = var.agent_vms_subnetwork

  docker_swarm_agent = var.docker_swarm_agent

  docker_static_agent_templates = var.docker_static_agent_templates
  docker_static_agents = var.docker_static_agents

  agent_service_account_email = module.agents.agent_service_account_email
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
