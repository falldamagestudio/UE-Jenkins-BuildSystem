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
