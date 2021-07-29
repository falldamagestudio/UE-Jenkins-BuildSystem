variable "agent_vms_network" {
  type = string
}

variable "agent_vms_subnetwork" {
  type = string
}

variable "swarm_agent" {
  type = object({
    linux = object({
      vm_image_name = string
      vm_cloud_config_url = string
    })
    windows = object({
      vm_image_name = string
    })
  })
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
