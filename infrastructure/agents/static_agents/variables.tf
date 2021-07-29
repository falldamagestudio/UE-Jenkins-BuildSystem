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

variable "static_agent_templates" {
  type = object({
    linux = map(object({
      machine_type = string
      boot_disk_size = number
      persistent_disk_size = number
    }))
    windows = map(object({
      machine_type = string
      boot_disk_size = number
    }))
  })
}

variable "static_agents" {
  type = object({
    linux = map(object({
      template = string
    }))
    windows = map(object({
      template = string
    }))
  })
}

variable "agent_service_account_email" {
  type = string
}
