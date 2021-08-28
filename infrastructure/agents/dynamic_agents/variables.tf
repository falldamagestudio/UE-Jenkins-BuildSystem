variable "agent_vms_network" {
  type = string
}

variable "agent_vms_subnetwork" {
  type = string
}

variable "ssh_agent" {
  type = object({
    linux = object({
      vm_image_name = string
    })
    windows = object({
      vm_image_name = string
    })
  })
}

variable "dynamic_agent_templates" {
  type = object({
    linux = map(object({
      machine_type = string
      boot_disk_type = string
      boot_disk_size = number
    }))
    windows = map(object({
      machine_type = string
      boot_disk_type = string
      boot_disk_size = number
      preemptible = bool
    }))
  })
}

variable "agent_service_account_email" {
  type = string
}
