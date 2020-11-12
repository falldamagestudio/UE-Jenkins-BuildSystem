variable "project_id" {
  description = "ID for the GCP project that will contain the license server."
  type        = string
}

variable "zone" {
  description = "License server VM zone."
  type        = string
}

variable "terraform_state_bucket" {
  description = "Name of GCS bucket that contains all Terraform state files."
  type        = string
}

variable "image" {
  description = "Name of a VM disk image that will be used when creating the license manager VM. The image must already have been built with Packer, and exist within the GCP project."
  type        = string
}

variable "machine_type" {
  description = "GCE instance machine type to use when creating the license manager VM. See https://cloud.google.com/compute/docs/machine-types for available machine types."
  type        = string
  default     = "n1-standard-4"
}

variable "boot_disk_type" {
  description = "Type of boot disk to use when creating the license manager VM. See https://cloud.google.com/compute/docs/disks#disk-types for available disk types."
  type        = string
  default     = "pd-ssd"
}

variable "boot_disk_size" {
  description = "Size of boot disk, in GB, to use when creating the license manager VM."
  type        = number
  default     = 400
}

variable "instance_name" {
  description = "Name of the GCE instance (VM) to create. The VM name must be unique within the GCP project. See https://cloud.google.com/compute/docs/naming-resources#resource-name-format for rules."
  type        = string
}

variable "ssh_username" {
  type = string
}

variable "ssh_pub_key_path" {
  type = string
}
