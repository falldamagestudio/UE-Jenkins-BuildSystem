variable "image_registry_prefix" {
  type    = string
  default = null
}

variable "project_id" {
  type    = string
  default = null
}

variable "region" {
  type    = string
  default = null
}

variable "zone" {
  type    = string
  default = null
}

variable "external_ip_address_name" {
  type    = string
  default = null
}

variable "internal_ip_address_name" {
  type    = string
  default = null
}

variable "longtail_store_bucket_name" {
  type = string
}

variable "ssh_vm_private_key_windows" {
  type = string
}