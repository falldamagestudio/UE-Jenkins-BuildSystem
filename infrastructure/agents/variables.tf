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

//variable "ssh_vm_public_key_windows" {
//  type = string
//}

//variable "ssh_agent_vm_image_linux" {
//  type = string
//}

//variable "ssh_agent_vm_cloud_config_url_linux" {
//  type = string
//}

//variable "ssh_agent_vm_image_windows" {
//  type = string
//}

//variable "swarm_agent_vm_image_linux" {
//  type = string
//}

//variable "swarm_agent_cloud_config_url_linux" {
//  type = string
//}

//variable "swarm_agent_vm_image_windows" {
//  type = string
//}

variable "windows_build_agents" {
  type = map
}

variable "linux_build_agents" {
  type = map
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

variable "dynamic_agent_templates" {
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

//variable "ssh_agent_docker_image_url_linux" {
//  type = string
//}

//variable "ssh_agent_docker_image_url_windows" {
//  type = string
//}

//variable "swarm_agent_docker_image_url_linux" {
//  type = string
//}

//variable "swarm_agent_docker_image_url_windows" {
//  type = string
//}
