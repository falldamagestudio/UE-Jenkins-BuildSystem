variable "agent_vms_network" {
  type = string
}

variable "agent_vms_subnetwork" {
  type = string
}

variable "ssh_agent_vm_image_linux" {
  type = string
}

variable "ssh_agent_vm_cloud_config_url_linux" {
  type = string
}

variable "ssh_agent_vm_image_windows" {
  type = string
}

variable "linux_build_agent_templates" {
  type = map
}

variable "windows_build_agent_templates" {
  type = map
}

variable "agent_service_account_email" {
  type = string
}

variable "settings" {
  type = object({
    ssh-agent-image-url-linux = string
    ssh-agent-image-url-windows = string
    ssh-vm-public-key-windows = string
  })
}