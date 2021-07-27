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

variable "cloud_config_store_bucket_id" {
  type = string
}
