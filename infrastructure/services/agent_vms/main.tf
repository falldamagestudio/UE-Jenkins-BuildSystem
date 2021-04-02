locals {
  wait = length(google_compute_subnetwork.agent_vms_subnetwork)
}

resource "google_compute_subnetwork" "agent_vms_subnetwork" {
  name          = "agent-vms"
  ip_cidr_range = "10.133.0.0/20"
  region        = var.region
  network       = var.network_id
}

