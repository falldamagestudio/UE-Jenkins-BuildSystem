variable "module_depends_on" {
  description = "List of modules or resources this module depends on."
  type        = list
  default     = []
}

variable "project_id" {
  type    = string
}

variable "location" {
  type    = string
}
