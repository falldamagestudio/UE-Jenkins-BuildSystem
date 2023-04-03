variable "project_id" {
  type        = string
}

variable "build_artifacts_location" {
  type        = string
}

variable "region" {
  type        = string
}

variable "zone" {
  type        = string
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

variable "longtail_store_location" {
  type = string
}

variable "image_builder_subnetwork_cidr_range" {
  type = string
}

variable "controller_vm_subnetwork_cidr_range" {
  type = string
}

variable "agent_vms_subnetwork_cidr_range" {
  type = string
}
