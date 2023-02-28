# TODO: Re-enable network peering, once we have a controller VM deployed

# resource "google_compute_network_peering" "controller_vm_agent_vms_network_peering" {
#   name         = "controller-vm-agent-vms-network-peering"
#   network      = google_compute_network.controller_vm.id
#   peer_network = google_compute_network.agent_vms.id
# }

# resource "google_compute_network_peering" "agent_vms_controller_vm_network_peering" {
#   name         = "agent-vms-controller-vm-network-peering"
#   network      = google_compute_network.agent_vms.id
#   peer_network = google_compute_network.controller_vm.id
# }
