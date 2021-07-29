variable "cloud_config_store_bucket_id" {
  type = string
}

variable "longtail_store_bucket_id" {
  type = string
}

variable "ssh_agent_settings" {
  type = object({
    ssh-agent-image-url-linux = string
    ssh-agent-image-url-windows = string
    ssh-vm-public-key-windows = string
  })
}

variable "swarm_agent_settings" {
  type = object({
    jenkins-url = string
    swarm-agent-image-url-linux = string
    swarm-agent-image-url-windows = string
  })
}