variable "project_id" {
  description = "ID for the GCP project that will contain the license server."
  type        = string
}

variable "project_number" {
  description = "Number for the GCP project that will contain the license server."
  type        = string
}

variable "build_artifacts_location" {
  description = "Docker build artifact registry region/multi-region."
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

variable "allowed_login_domain" {
  type = string
}

variable "linux_swarm_agent_cloud_config_url" {
  type = string
}

variable "windows_swarm_agent_image" {
  type = string
}