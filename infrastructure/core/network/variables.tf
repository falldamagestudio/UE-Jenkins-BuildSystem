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

variable "controller_vm_subnetwork_cidr_range" {
  type = string
}
