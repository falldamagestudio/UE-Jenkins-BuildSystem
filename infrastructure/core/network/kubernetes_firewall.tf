resource "google_compute_firewall" "kubernetes_allow_internal_traffic" {
  depends_on = [ var.module_depends_on ]

  name = "kubernetes-allow-internal-traffic"
  
  network = google_compute_network.kubernetes.name

  description = "Allow internal traffic on the Kubernetes network"

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "udp"
    ports = [ "0-65535" ]
  }

  allow {
    protocol = "tcp"
    ports = [ "0-65535" ]
  }

  source_ranges = [ 
    var.kubernetes_cluster_network_config.vms_cidr_range,
    var.kubernetes_cluster_network_config.pods_cidr_range,
    var.kubernetes_cluster_network_config.services_cidr_range,
    var.kubernetes_cluster_network_config.internal_lb_cidr_range,
  ]
}
