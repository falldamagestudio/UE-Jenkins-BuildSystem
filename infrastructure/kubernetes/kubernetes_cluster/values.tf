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
