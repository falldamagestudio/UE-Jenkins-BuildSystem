variable "ssh_agent" {
  type = object({
    linux = object({
      vm_image_name = string
    })
    windows = object({
      vm_image_name = string
    })
  })

  default = {
    linux = {
      vm_image_name = ""
    }
    windows = {
      vm_image_name = ""
    }
  }
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

  default = {
    linux = {
      vm_image_name = ""
    }
    windows = {
      vm_image_name = ""
    }
  }
}

variable "dynamic_agent_templates" {
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

  default = {
    linux = {}
    windows = {}
  }
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

  default = {
    linux = {}
    windows = {}
  }
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
 
  default = {
    linux = {}
    windows = {}
  }
}