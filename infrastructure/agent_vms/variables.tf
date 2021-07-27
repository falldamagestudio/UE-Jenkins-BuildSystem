variable "module_depends_on" {
  description = "List of modules or resources this module depends on."
  type        = list
  default     = []
}

variable "project_id" {
  description = "ID for the GCP project that will contain the license server."
  type        = string
}

variable "region" {
  type    = string
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

variable "ssh_vm_public_key_windows" {
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
