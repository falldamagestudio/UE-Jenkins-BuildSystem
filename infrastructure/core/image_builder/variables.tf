variable "module_depends_on" {
  description = "List of modules or resources this module depends on."
  type        = list
  default     = []
}

variable "region" {
  type = string
}

variable "build_artifact_uploader_service_account_name" {
  type = string
}

variable "image_builder_subnetwork_cidr_range" {
  type = string
}

variable "build_artifact_registry_repository_location" {
  type = string
}

variable "build_artifact_registry_repository_name" {
  type = string
}