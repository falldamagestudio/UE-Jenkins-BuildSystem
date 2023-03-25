variable "project_id" {
  description = "ID for the GCP project that will contain the license server."
  type        = string
}

variable "zone" {
  type    = string
}

variable "agent_vms_network" {
  type = string
}

variable "agent_vms_subnetwork" {
  type = string
}

variable "internal_ip_address" {
  type = string
}

variable "longtail_store_bucket_name" {
  type = string
}

variable "agent_templates" {
  type = map(object({
    vm_image_name = string
    machine_type = string
    boot_disk_type = string
    boot_disk_size = number
    preemptible = bool
  }))
}

variable "windows_vm_ssh_public_key" {
  type = string
}

variable "swarm_agent_username" {
  type = string
}

variable "swarm_agent_api_token" {
  type = string
}
