variable "module_depends_on" {
  description = "List of modules or resources this module depends on."
  type        = list
  default     = []
}

variable "location" {
  type        = string
}

variable "bucket_name" {
  type = string
}
