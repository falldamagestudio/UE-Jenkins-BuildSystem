output "project_id" {
    value = var.project_id
}

output "region" {
    value = var.region
}

output "zone" {
    value = var.zone
}

output "controller_vm_network" {
    value = module.core.controller_vm_network
}

output "controller_vm_subnetwork" {
    value = module.core.controller_vm_subnetwork
}

output "agent_vms_network" {
    value = module.core.agent_vms_network
}

output "agent_vms_subnetwork" {
    value = module.core.agent_vms_subnetwork
}

output "external_ip_address_name" {
    value = var.external_ip_address_name
}

output "internal_ip_address_name" {
    value = var.internal_ip_address_name
}

output "internal_ip_address" {
    value = var.internal_ip_address
}

output "longtail_store_bucket_name" {
    value = var.longtail_store_bucket_name
}

output "ssh_vm_public_key_windows" {
  value = module.core.ssh_vm_public_key_windows
}

output "ssh_vm_private_key_windows" {
  value = module.core.ssh_vm_private_key_windows
  sensitive = true
}