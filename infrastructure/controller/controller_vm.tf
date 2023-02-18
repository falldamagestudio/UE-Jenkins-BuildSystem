resource "google_compute_disk" "controller_vm_state" {
  name = "controller-vm-state"

  type = var.state_disk_type
  size = var.state_disk_size_gb
  zone = var.zone
}

resource "google_compute_instance" "controller_vm" {
    name = "controller-vm"

    machine_type = var.machine_type
    zone = var.zone

    // Add boot disk

    boot_disk {
      initialize_params {
        image = var.vm_image_name
        type = var.boot_disk_type
        size = var.boot_disk_size_gb
      }

      auto_delete = true
    }

    attached_disk {
      source = google_compute_disk.controller_vm_state.id
      device_name = "controller-state"
    }

    network_interface {
        network = var.controller_vm_network
        subnetwork = var.controller_vm_subnetwork

        access_config {

            // Auto-generate external IP

        }
    }

    service_account {
        email = google_service_account.controller_service_account.email
        scopes = [ "cloud-platform" ]
    }
}
