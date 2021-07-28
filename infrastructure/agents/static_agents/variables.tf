variable "agent_vms_network" {
  type = string
}

variable "agent_vms_subnetwork" {
  type = string
}

variable "swarm_agent_vm_image_linux" {
  type = string
}

variable "swarm_agent_cloud_config_url_linux" {
  type = string
}

variable "swarm_agent_vm_image_windows" {
  type = string
}

variable "windows_build_agents" {
  type = map
}

variable "linux_build_agents" {
  type = map
}

variable "agent_service_account_email" {
  type = string
}

variable "settings" {
  type = object({
    jenkins-url = string
    swarm-agent-image-url-linux = string
    swarm-agent-image-url-windows = string
  })
}