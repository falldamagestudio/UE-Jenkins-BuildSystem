variable "project_id" {
  description = "ID for the GCP project that will contain the license server."
  type        = string
}

variable "zone" {
  type    = string
}

variable "agent_vms_network" {
  type = string
}

variable "agent_vms_subnetwork" {
  type = string
}

variable "internal_ip_address" {
  type = string
}

variable "cloud_config_store_bucket_name" {
  type = string
}

variable "longtail_store_bucket_name" {
  type = string
}

variable "ssh_agent" {
  type = object({
    linux = object({
      vm_image_name = string
      vm_cloud_config_url = string
      docker_image_url = string
    })
    windows = object({
      vm_image_name = string
      vm_ssh_public_key = string
      docker_image_url = string
    })
  })
}

variable "swarm_agent" {
  type = object({
    linux = object({
      vm_image_name = string
      vm_cloud_config_url = string
      docker_image_url = string
    })
    windows = object({
      vm_image_name = string
      docker_image_url = string
    })
  })
}

variable "dynamic_agent_templates" {
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

variable "static_agent_templates" {
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
