resource "google_compute_network" "controller_vm" {
  depends_on = [ var.module_depends_on ]

  name = "controller-vm-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "controller_vm" {
  depends_on = [ var.module_depends_on ]

  name          = "controller-vm"
  ip_cidr_range = var.controller_vm_subnetwork_cidr_range
  region        = var.region
  network       = google_compute_network.controller_vm.name
}
