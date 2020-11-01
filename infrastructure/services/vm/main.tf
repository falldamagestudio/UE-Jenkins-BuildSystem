resource "google_compute_instance" "default" {
  name         = var.name
  machine_type = var.machine_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = var.image
      type  = var.boot_disk_type
      size  = var.boot_disk_size
    }
  }

  metadata = {
    ssh-keys = "${var.ssh_username}:${file(var.ssh_pub_key_path)}"
  }

  network_interface {
    network = "default"

    access_config {
      nat_ip = google_compute_address.external_ip_address.address
    }
  }

  allow_stopping_for_update = true
}

resource "google_compute_address" "external_ip_address" {
  name = "ipv4-address"
}

resource "google_compute_firewall" "allow_ssh" {
  name       = "allow-ssh"
  network    = "default"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}

resource "google_compute_firewall" "allow_admin_ui_http" {
  name       = "allow-admin-ui-http"
  network    = "default"

  allow {
    protocol = "tcp"
    ports    = ["8080"]
  }
}
