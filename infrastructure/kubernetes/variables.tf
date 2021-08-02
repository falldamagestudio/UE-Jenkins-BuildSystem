variable "project_id" {
  description = "ID for the GCP project that will contain the license server."
  type        = string
}

variable "project_number" {
  description = "Number for the GCP project that will contain the license server."
  type        = string
}

variable "region" {
  description = "License server VM region."
  type        = string
}

variable "zone" {
  description = "License server VM zone."
  type        = string
}

variable "kubernetes_network" {
  type    = string
  default = null
}

variable "kubernetes_subnetwork" {
  type    = string
  default = null
}

variable "kubernetes_subnetwork_id" {
  type    = string
  default = null
}

variable "external_ip_address_name" {
  type = string
}

variable "internal_ip_address_name" {
  type = string
}

variable "internal_ip_address" {
  type = string
}

variable "longtail_store_bucket_name" {
  type = string
}

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

variable "ssh_vm_private_key_windows" {
  type = string
}