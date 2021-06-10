
// Fetch the contents of a cloud-config file from a GCS bucket
data "local_file" "linux_cloud_config" {
  filename = "../../../UE-Jenkins-Images/ue-jenkins-agent-vms/linux-gce-cos/ue-jenkins-ssh-agent-vm-cloud-config.yaml"
}


resource "google_compute_instance_template" "linux_build_agent_template" {

    depends_on = [ var.module_depends_on ]

    for_each = var.linux_build_agent_templates

    name = each.key

    machine_type = each.value.machine_type

    // Add boot disk

    disk {
        source_image = var.linux_image

        auto_delete = true
        boot = true

        disk_size_gb = each.value.boot_disk_size
        disk_type = "pd-ssd"
    }

    // Add persistent disk

    disk {
        auto_delete = true
        boot = false

        disk_size_gb = each.value.persistent_disk_size
        disk_type = "pd-ssd"
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
        // TODO: switch back to data.http.linux_cloud_config.body when done
        user-data = data.local_file.linux_cloud_config.content
    }
}
