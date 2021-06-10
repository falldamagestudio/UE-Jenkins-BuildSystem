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

variable "allowed_login_domain" {
  type = string
}

variable "linux_swarm_agent_image" {
  type = string
}

variable "linux_swarm_agent_cloud_config_url" {
  type = string
}

variable "windows_swarm_agent_image" {
  type = string
}

variable "windows_build_agents" {
  type = map
}

variable "linux_build_agents" {
  type = map
}

variable "linux_build_agent_templates" {
  type = map
}

variable "ssh_agent_image_url_linux" {
  type = string
}

variable "swarm_agent_image_url_linux" {
  type = string
}

variable "swarm_agent_image_url_windows" {
  type = string
}