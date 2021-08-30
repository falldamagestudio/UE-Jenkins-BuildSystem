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
      boot_disk_type = string
      boot_disk_size = number
      preemptible = bool
    }))
    windows = map(object({
      machine_type = string
      boot_disk_type = string
      boot_disk_size = number
      preemptible = bool
    }))
  })
}

variable "static_agents" {
  type = object({
    linux = map(object({
      template = string
      jenkins_labels = string
    }))
    windows = map(object({
      template = string
      jenkins_labels = string
    }))
  })
}

variable "agent_service_account_email" {
  type = string
}
