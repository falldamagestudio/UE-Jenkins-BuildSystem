resource "google_compute_instance" "engine_win64_agent" {
  depends_on = [ var.module_depends_on ]

  name = "engine-win64-agent"
  machine_type = "n1-standard-4" // TODO: parameterize
  zone = "europe-west1-b" // TODO: parameterize
  boot_disk {
    initialize_params {
      image = "windows-server-2019-dc-core-for-containers-v20210309" // TODO: parameterize
      size = 500 // TODO: parameterize
      type = "pd-balanced" // TODO: parameterize
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.agent_vms.name

    access_config {
      // Ephemeral external IP please
    }
  }

  service_account {
    email = google_service_account.agent_service_account.email
    scopes = ["cloud-platform"]
  }
}
