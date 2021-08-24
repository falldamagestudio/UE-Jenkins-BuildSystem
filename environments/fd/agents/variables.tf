variable "docker_ssh_agent" {
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

  default = {
    linux = {
      vm_image_name = ""
      vm_cloud_config_url = ""
      docker_image_url = ""
    }
    windows = {
      vm_image_name = ""
      docker_image_url = ""
    }
  }
}

variable "docker_swarm_agent" {
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

  default = {
    linux = {
      vm_image_name = ""
      vm_cloud_config_url = ""
      docker_image_url = ""
    }
    windows = {
      vm_image_name = ""
      docker_image_url = ""
    }
  }
}

variable "docker_dynamic_agent_templates" {
  type = object({
    linux = map(object({
      machine_type = string
      boot_disk_type = string
      boot_disk_size = number
      persistent_disk_type = string
      persistent_disk_size = number
      preemptible = bool
    }))
    windows = map(object({
      machine_type = string
      boot_disk_type = string
      boot_disk_size = number
      preemptible = bool
    }))
  })

  default = {
    linux = {}
    windows = {}
  }
}

variable "docker_static_agent_templates" {
  type = object({
    linux = map(object({
      machine_type = string
      boot_disk_type = string
      boot_disk_size = number
      persistent_disk_type = string
      persistent_disk_size = number
      preemptible = bool
    }))
    windows = map(object({
      machine_type = string
      boot_disk_type = string
      boot_disk_size = number
      preemptible = bool
    }))
  })

  default = {
    linux = {}
    windows = {}
  }
}

variable "docker_static_agents" {
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

  default = {
    linux = {}
    windows = {}
  }
}

variable "ssh_agent" {
  type = object({
    windows = object({
      vm_image_name = string
    })
  })

  default = {
    windows = {
      vm_image_name = ""
    }
  }
}

variable "swarm_agent" {
  type = object({
    windows = object({
      vm_image_name = string
    })
  })

  default = {
    windows = {
      vm_image_name = ""
    }
  }
}

variable "dynamic_agent_templates" {
  type = object({
    windows = map(object({
      machine_type = string
      boot_disk_type = string
      boot_disk_size = number
      preemptible = bool
    }))
  })

  default = {
    windows = {}
  }
}

variable "static_agent_templates" {
  type = object({
    windows = map(object({
      machine_type = string
      boot_disk_type = string
      boot_disk_size = number
      preemptible = bool
    }))
  })

  default = {
    windows = {}
  }
}

variable "static_agents" {
  type = object({
    windows = map(object({
      template = string
      jenkins_labels = string
    }))
  })
 
  default = {
    windows = {}
  }
}