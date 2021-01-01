variable "project_id" {
  description = "ID for the GCP project that will contain the license server."
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
