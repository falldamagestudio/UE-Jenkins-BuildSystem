variable "agent_template_groups" {
  type = list(object({
    vm_image_name = string
    agent_templates = map(object({
      machine_type = string
      boot_disk_type = string
      boot_disk_size = number
      preemptible = bool
    }))
  }))

  default = []
}

variable "static_agents" {
  type = map(object({
    template = string
    jenkins_labels = string
  }))

  default = {}
}
