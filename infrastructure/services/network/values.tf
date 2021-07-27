output "kubernetes_network" {
    value = google_compute_network.kubernetes.name
}

output "kubernetes_subnetwork" {
    value = google_compute_subnetwork.kubernetes.name
}

output "kubernetes_subnetwork_id" {
    value = google_compute_subnetwork.kubernetes.id
}

output "agent_vms_network" {
    value = google_compute_network.agent_vms.name
}

output "agent_vms_subnetwork" {
    value = google_compute_subnetwork.agent_vms.name
}
