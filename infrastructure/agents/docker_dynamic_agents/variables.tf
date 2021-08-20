variable "agent_vms_network" {
  type = string
}

variable "agent_vms_subnetwork" {
  type = string
}

variable "docker_ssh_agent" {
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

variable "docker_dynamic_agent_templates" {
  type = object({
    linux = map(object({
      machine_type = string
      boot_disk_type = string
      boot_disk_size = number
      persistent_disk_type = string
      persistent_disk_size = number
    }))
    windows = map(object({
      machine_type = string
      boot_disk_type = string
      boot_disk_size = number
    }))
  })
}

variable "agent_service_account_email" {
  type = string
}
