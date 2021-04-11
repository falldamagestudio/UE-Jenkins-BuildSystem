resource "google_compute_network_peering" "kubernetes_network_agent_vms_peering" {
  depends_on = [ var.module_depends_on ]

  name         = "kubernetes-network-agent-vms-peering"
  network      = var.kubernetes_network_id
  peer_network = google_compute_network.agent_vms.id
}

resource "google_compute_network_peering" "agent_vms_kubernetes_network_peering" {
  depends_on = [ var.module_depends_on ]
  
  name         = "agent-vms-kubernetes-network-peering"
  network      = google_compute_network.agent_vms.id
  peer_network = var.kubernetes_network_id
}
