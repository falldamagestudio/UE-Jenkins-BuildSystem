resource "google_compute_network" "agent_vms" {
  name          = "agent-vms"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "agent_vms" {
  name          = "agent-vms" // TODO: include region in name
  ip_cidr_range = var.agent_vms_subnetwork_cidr_range
  region        = var.region
  network       = google_compute_network.agent_vms.name
}
