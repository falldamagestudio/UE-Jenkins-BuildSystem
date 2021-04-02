output "wait" {
  description = "An output to use when you want to depend on cmd finishing"
  value       = local.wait
}

output "endpoint" {
  sensitive   = true
  description = "Cluster endpoint"
  value       = module.kubernetes_cluster.endpoint
}

output "ca_certificate" {
  sensitive   = true
  description = "Cluster ca certificate (base64 encoded)"
  value       = module.kubernetes_cluster.ca_certificate
}

output "network_id" {
  value       = google_compute_network.kubernetes_network.id
}
