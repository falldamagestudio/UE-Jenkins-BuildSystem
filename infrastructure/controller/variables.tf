variable "project_id" {
  type        = string
}

variable "region" {
  type    = string
}

variable "zone" {
  type    = string
}

variable "controller_vm_network" {
  type = string
}

variable "controller_vm_subnetwork" {
  type = string
}

variable "longtail_store_bucket_name" {
  type = string
}

variable "ssh_vm_private_key_windows" {
  type = string
}

variable "controller_web_endpoint_domain" {
  type = string
}

variable "oauth2_client_id" {
  type = string
}

variable "machine_type" {
  type = string
}

variable "boot_disk_type" {
  type = string
}

variable "boot_disk_size_gb" {
  type = number
}

variable "state_disk_type" {
  type = string
}

variable "state_disk_size_gb" {
  type = number
}

variable "vm_image_name" {
  type = string
}
