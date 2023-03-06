variable "controller_web_endpoint_domain" {
  type = string
}

variable "oauth2_client_id" {
  type = string
}

variable "machine_type" {
  type = string
}

variable "boot_disk_type" {
  type = string
}

variable "boot_disk_size_gb" {
  type = number
}

variable "state_disk_type" {
  type = string
}

variable "state_disk_size_gb" {
  type = number
}

variable "vm_image_name" {
  type = string
}
