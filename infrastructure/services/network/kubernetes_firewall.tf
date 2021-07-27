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

  source_ranges = [ "10.132.0.0/20", "10.134.0.0/24", "10.24.0.0/14" ] // TODO: use parameterized values
}
