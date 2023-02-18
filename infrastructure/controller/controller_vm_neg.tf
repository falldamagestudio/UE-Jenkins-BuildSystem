resource "google_compute_network_endpoint_group" "neg" {
  name         = "controller-web-endpoint-neg"
  network      = var.controller_vm_network
  subnetwork   = var.controller_vm_subnetwork
  default_port = "8080"
  zone         = var.zone
}

resource "google_compute_network_endpoint" "controller_vm_web_endpoint" {
  network_endpoint_group = google_compute_network_endpoint_group.neg.name

  instance   = google_compute_instance.controller_vm.name
  port       = google_compute_network_endpoint_group.neg.default_port
  ip_address = google_compute_instance.controller_vm.network_interface[0].network_ip
}
