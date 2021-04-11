variable "module_depends_on" {
  description = "List of modules or resources this module depends on."
  type        = list
  default     = []
}

variable "kubernetes_cluster_ca_certificate" {
  description = "Cluster ca certificate (base64 encoded)"
  type        = string
}

variable "kubernetes_cluster_endpoint" {
  description = "Cluster endpoint"
  type        = string
}

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
