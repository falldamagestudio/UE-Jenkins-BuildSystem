resource "google_compute_network" "kubernetes" {
  depends_on = [ var.module_depends_on ]

  name = "kubernetes-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "kubernetes" {
  depends_on = [ var.module_depends_on ]

  name          = "kubernetes-subnetwork"
  ip_cidr_range = "10.132.0.0/20" // TODO: parameterize
  region        = var.region
  network       = google_compute_network.kubernetes.id

  secondary_ip_range = [
    {
      range_name    = "kubernetes-subnetwork-pods"
      ip_cidr_range = "10.24.0.0/14" // TODO: parameterize
    },
    {
      range_name    = "kubernetes-subnetwork-services"
      ip_cidr_range = "10.28.0.0/20" // TODO: parameterize
    }
  ]
}

resource "google_compute_subnetwork" "internal_lb_subnetwork" {
  depends_on = [ var.module_depends_on ]

  provider = google-beta

  name          = "internal-lb-subnetwork"
  purpose       = "INTERNAL_HTTPS_LOAD_BALANCER"
  role          = "ACTIVE"
  ip_cidr_range = "10.134.0.0/24" // TODO: parameterize
  region        = var.region
  network       = google_compute_network.kubernetes.id
}

