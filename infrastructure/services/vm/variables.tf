variable "module_depends_on" {
  description = "List of modules or resources this module depends on."
  type        = list
  default     = []
}

variable "name" {
  type = string
}

variable "image" {
  type = string
}

variable "machine_type" {
  type    = string
  default = "n1-standard-1"
}

variable "zone" {
  type    = string
  default = null
}

variable "boot_disk_type" {
  type = string
}

variable "boot_disk_size" {
  type = number
}

variable "ssh_username" {
  type = string
}

variable "ssh_pub_key_path" {
  type = string
}

variable "build_artifacts_location" {
  type = string
}

variable "build_artifacts_name" {
  type = string
}
