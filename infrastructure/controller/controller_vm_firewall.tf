resource "google_compute_firewall" "allow_ssh" {
  name       = "controller-vm-allow-ssh"
  network    = var.controller_vm_network

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}

# resource "google_compute_firewall" "allow_http" {
#   name       = "controller-vm-allow-http"
#   network    = google_compute_network.controller_vm.name

#   allow {
#     protocol = "tcp"
#     ports    = ["8080"]
#   }
# }
