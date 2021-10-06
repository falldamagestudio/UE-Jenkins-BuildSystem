module "agents" {

  source = "./agents"

  longtail_store_bucket_id = var.longtail_store_bucket_name

  swarm_agent_settings = {
    jenkins-url = "http://${var.internal_ip_address}"
  }

  ssh_agent_settings = {
    ssh-vm-public-key-windows = var.windows_vm_ssh_public_key
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
