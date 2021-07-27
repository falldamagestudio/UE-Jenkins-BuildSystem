output "ssh_vm_public_key_windows" {
  value = module.ssh_vm_windows_auth.ssh_vm_public_key_windows
}

output "ssh_vm_private_key_windows" {
  value = module.ssh_vm_windows_auth.ssh_vm_private_key_windows
}

output "kubernetes_network" {
  value = module.network.kubernetes_network
}

output "kubernetes_subnetwork" {
  value = module.network.kubernetes_subnetwork
}

output "kubernetes_subnetwork_id" {
  value = module.network.kubernetes_subnetwork_id
}

output "agent_vms_network" {
  value = module.network.agent_vms_network
}

output "agent_vms_subnetwork" {
  value = module.network.agent_vms_subnetwork
}