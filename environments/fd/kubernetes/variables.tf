variable "allowed_login_domain" {
  type = string
}

variable "node_pools" {
  type = object({
    controller = object({
      machine_type = string
      disk_type = string
      disk_size = number
    })

    agent_pools = map(object({
      os = string
      machine_type = string
      disk_type = string
      disk_size = number
      min_nodes = number
      max_nodes = number
    }))
  })
}