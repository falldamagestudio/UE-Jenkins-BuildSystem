output "ssh_vm_public_key_windows" {
  value = module.ssh_vm_windows_auth.ssh_vm_public_key_windows
}

output "ssh_vm_private_key_windows" {
  value = module.ssh_vm_windows_auth.ssh_vm_private_key_windows
}

output "controller_vm_network" {
  value = module.network.controller_vm_network
}

output "controller_vm_subnetwork" {
  value = module.network.controller_vm_subnetwork
}

output "agent_vms_network" {
  value = module.network.agent_vms_network
}

output "agent_vms_subnetwork" {
  value = module.network.agent_vms_subnetwork
}