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

module "agent_templates_and_vms" {

  source = "./agent_templates_and_vms"

  depends_on = [ module.agents ]

  agent_vms_network = var.agent_vms_network
  agent_vms_subnetwork = var.agent_vms_subnetwork

  agent_service_account_email = module.agents.agent_service_account_email

  agent_templates = var.agent_templates
  static_agents = var.static_agents
}
