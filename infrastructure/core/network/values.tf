output "controller_vm_network" {
    value = google_compute_network.controller_vm.name
}

output "controller_vm_subnetwork" {
    value = google_compute_subnetwork.controller_vm.name
}

output "agent_vms_network" {
    value = google_compute_network.agent_vms.name
}

output "agent_vms_subnetwork" {
    value = google_compute_subnetwork.agent_vms.name
}
