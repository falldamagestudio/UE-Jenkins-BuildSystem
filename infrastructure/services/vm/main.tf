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

  service_account {
    email  = google_service_account.ue4_jenkins_master_service_account.email
    scopes = ["cloud-platform"]
  }

  allow_stopping_for_update = true
}

resource "google_service_account" "ue4_jenkins_master_service_account" {
  account_id   = "ue4-jenkins-master"
  display_name = "UE4 Jenkins Master VM"
}

resource "google_artifact_registry_repository_iam_member" "build_artifact_downloader_access" {
  provider = google-beta

  location = var.build_artifacts_location
  repository = var.build_artifacts_name
  role   = "roles/artifactregistry.reader"
  member = "serviceAccount:${google_service_account.ue4_jenkins_master_service_account.email}"
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
