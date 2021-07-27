variable "module_depends_on" {
  description = "List of modules or resources this module depends on."
  type        = list
  default     = []
}

variable "project_id" {
  type    = string
  default = null
}

variable "project_number" {
  type    = string
  default = null
}

variable "region" {
  type    = string
  default = null
}

variable "zone" {
  type    = string
  default = null
}

variable "kubernetes_network" {
  type    = string
  default = null
}

variable "kubernetes_subnetwork" {
  type    = string
  default = null
}

variable "kubernetes_subnetwork_id" {
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

variable "internal_ip_address" {
  type = string
}

variable "longtail_store_bucket_id" {
  type = string
}

variable "allowed_login_domain" {
  type = string
}