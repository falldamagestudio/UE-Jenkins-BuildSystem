variable "module_depends_on" {
  description = "List of modules or resources this module depends on."
  type        = list
  default     = []
}

variable "region" {
  type    = string
  default = null
}

variable "agent_vms_subnetwork_cidr_range" {
  type = string
}

variable "kubernetes_cluster_network_config" {
  type = object({
    vms_cidr_range = string
    pods_cidr_range = string
    services_cidr_range = string
    internal_lb_cidr_range = string
  })
}