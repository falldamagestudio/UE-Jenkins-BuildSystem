variable "project_id" {
  description = "ID for the GCP project that will contain the license server."
  type        = string
}

variable "project_number" {
  description = "Number for the GCP project that will contain the license server."
  type        = string
}

variable "build_artifacts_location" {
  description = "Docker build artifact registry region/multi_region."
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

variable "cloud_config_store_bucket_name" {
  type = string
}

variable "cloud_config_store_location" {
  type = string
}

variable "image_builder_subnetwork_cidr_range" {
  type = string
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