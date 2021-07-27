variable "ssh_agent_vm_image_linux" {
  type = string
}

variable "ssh_agent_vm_cloud_config_url_linux" {
  type = string
}

variable "ssh_agent_vm_image_windows" {
  type = string
}

variable "swarm_agent_vm_image_linux" {
  type = string
}

variable "swarm_agent_cloud_config_url_linux" {
  type = string
}

variable "swarm_agent_vm_image_windows" {
  type = string
}

variable "windows_build_agents" {
  type = map
}

variable "linux_build_agents" {
  type = map
}

variable "linux_build_agent_templates" {
  type = map
}

variable "windows_build_agent_templates" {
  type = map
}

variable "ssh_agent_docker_image_url_linux" {
  type = string
}

variable "ssh_agent_docker_image_url_windows" {
  type = string
}

variable "swarm_agent_docker_image_url_linux" {
  type = string
}

variable "swarm_agent_docker_image_url_windows" {
  type = string
}