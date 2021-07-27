resource "google_compute_network" "kubernetes" {
  depends_on = [ var.module_depends_on ]

  name = "kubernetes-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "kubernetes" {
  depends_on = [ var.module_depends_on ]

  name          = "kubernetes-subnetwork"
  ip_cidr_range = var.kubernetes_cluster_network_config.vms_cidr_range
  region        = var.region
  network       = google_compute_network.kubernetes.id

  secondary_ip_range = [
    {
      range_name    = "kubernetes-subnetwork-pods"
      ip_cidr_range = var.kubernetes_cluster_network_config.pods_cidr_range
    },
    {
      range_name    = "kubernetes-subnetwork-services"
      ip_cidr_range = var.kubernetes_cluster_network_config.services_cidr_range
    }
  ]
}

resource "google_compute_subnetwork" "internal_lb_subnetwork" {
  depends_on = [ var.module_depends_on ]

  provider = google-beta

  name          = "internal-lb-subnetwork"
  purpose       = "INTERNAL_HTTPS_LOAD_BALANCER"
  role          = "ACTIVE"
  ip_cidr_range = var.kubernetes_cluster_network_config.internal_lb_cidr_range
  region        = var.region
  network       = google_compute_network.kubernetes.id
}

