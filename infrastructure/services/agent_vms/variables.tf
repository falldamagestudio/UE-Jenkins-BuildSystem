variable "module_depends_on" {
  description = "List of modules or resources this module depends on."
  type        = list
  default     = []
}

variable "region" {
  type    = string
}

variable "network_id" {
  type = string
}

variable "cloud_config_store_bucket_id" {
  type = string
}

variable "longtail_store_bucket_id" {
  type = string
}

variable "kubernetes_network_id" {
  type = string
}

variable "linux_ssh_agent_image" {
  type = string
}

variable "linux_ssh_agent_cloud_config_url" {
  type = string
}

variable "linux_swarm_agent_image" {
  type = string
}

variable "linux_swarm_agent_cloud_config_url" {
  type = string
}

variable "windows_image" {
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

variable "settings" {
  type = object({
    jenkins-url = string
    ssh-agent-image-url-linux = string
    swarm-agent-image-url-linux = string
    swarm-agent-image-url-windows = string
  })
}