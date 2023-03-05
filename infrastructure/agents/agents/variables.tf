variable "longtail_store_bucket_id" {
  type = string
}

variable "ssh_agent_settings" {
  type = object({
    ssh-vm-public-key-windows = string
  })
}

variable "swarm_agent_settings" {
  type = object({
    jenkins-url = string
    swarm-agent-username = string
    swarm-agent-api-token = string
  })
}