variable "project_id" {
  description = "ID for the GCP project that will contain the license server."
  type        = string
}

variable "zone" {
  description = "License server VM zone."
  type        = string
}

variable "support_email" {
  description = "Support email for OAuth authentication"
  type        = string
}
