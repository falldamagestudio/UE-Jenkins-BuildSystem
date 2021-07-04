// Access the Google provider's configuration (we will use this to get access tokens)
data "google_client_config" "default" {
}

// Fetch the contents of a cloud-config file from a GCS bucket
data "http" "linux_swarm_agent_cloud_config" {
  url = var.swarm_agent_cloud_config_url_linux

  request_headers = {
      Authorization = "Bearer ${data.google_client_config.default.access_token}"
  }
}


resource "google_compute_instance" "linux_build_agent" {

    depends_on = [ var.module_depends_on ]

    for_each = var.linux_build_agents

    name = each.key

    machine_type = each.value.machine_type

    boot_disk {

        initialize_params {
            size = each.value.boot_disk_size
            type = "pd-ssd"
            image = var.swarm_agent_vm_image_linux
        }

    }

    attached_disk {
        source = google_compute_disk.linux_build_agent_pd[each.key].self_link
    }

    network_interface {

        network = google_compute_network.agent_vms.name
        subnetwork = google_compute_subnetwork.agent_vms.name

        access_config {

            // Auto-generate external IP

        }
    }

    service_account {
        email = google_service_account.agent_service_account.email
        scopes = [ "cloud-platform" ]
    }

    metadata = {
        google-logging-enabled = "true"
        user-data = data.http.linux_swarm_agent_cloud_config.body
    }
}

resource "google_compute_disk" "linux_build_agent_pd" {
 
    depends_on = [ var.module_depends_on ]

    for_each = var.linux_build_agents
    name  = "${each.key}-pd"
    size =  each.value.persistent_disk_size
    type  = "pd-ssd"
}

resource "google_compute_instance" "windows_build_agent" {

    depends_on = [ var.module_depends_on ]

    for_each = var.windows_build_agents

    name = each.key

    machine_type = each.value.machine_type

    boot_disk {

        initialize_params {
            size = each.value.boot_disk_size
            type = "pd-ssd"
            image = var.swarm_agent_vm_image_windows
        }

    }

    network_interface {

        network = google_compute_network.agent_vms.name
        subnetwork = google_compute_subnetwork.agent_vms.name

        access_config {

            // Auto-generate external IP

        }
    }

    service_account {
        email = google_service_account.agent_service_account.email
        scopes = [ "cloud-platform" ]
    }
}
