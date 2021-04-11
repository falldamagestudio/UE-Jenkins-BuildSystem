variable "module_depends_on" {
  description = "List of modules or resources this module depends on."
  type        = list
  default     = []
}

variable "region" {
  type    = string
}

variable "network_id" {
  type = string
}

variable "longtail_store_bucket_id" {
  type = string
}

variable "kubernetes_network_id" {
  type = string
}