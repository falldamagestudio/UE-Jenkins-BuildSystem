variable "agent_vms_network" {
  type = string
}

variable "agent_vms_subnetwork" {
  type = string
}

variable "agent_service_account_email" {
  type = string
}

variable "agent_templates" {
  type = map(object({
    vm_image_name = string
    machine_type = string
    boot_disk_type = string
    boot_disk_size = number
    preemptible = bool
  }))
}

variable "static_agents" {
  type = map(object({
    template = string
    jenkins_labels = string
  }))
}
