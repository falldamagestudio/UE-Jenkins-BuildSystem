
// Fetch the contents of a cloud-config file from a GCS bucket
//data "local_file" "linux_swarm_agent_vm_cloud_config" {
//  filename = "../../../UE-Jenkins-Images/ue-jenkins-agent-vms/linux-gce-cos/ue-jenkins-swarm-agent-vm-cloud-config.yaml"
//}

// Access the Google provider's configuration (we will use this to get access tokens)
data "google_client_config" "default" {
}

// Fetch the contents of a cloud-config file from a GCS bucket
data "http" "linux_swarm_agent_vm_cloud_config" {
  url = var.swarm_agent.linux.vm_cloud_config_url

  request_headers = {
      Authorization = "Bearer ${data.google_client_config.default.access_token}"
  }
}

resource "google_compute_instance_template" "linux_agent_template" {

    for_each = var.static_agent_templates.linux

    name = each.key

    machine_type = each.value.machine_type

    // Add boot disk

    disk {
        source_image = var.swarm_agent.linux.vm_image_name

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

        network = var.agent_vms_network
        subnetwork = var.agent_vms_subnetwork

        access_config {

            // Auto-generate external IP

        }
    }

    service_account {
        email = var.agent_service_account_email
        scopes = [ "cloud-platform" ]
    }

    metadata = {
        google-logging-enabled = "true"
        //user-data = data.local_file.linux_swarm_agent_vm_cloud_config.content
        user-data = data.http.linux_swarm_agent_vm_cloud_config.body
    }
}

resource "google_compute_instance_template" "windows_agent_template" {

    for_each = var.static_agent_templates.windows

    name = each.key

    machine_type = each.value.machine_type

    // Add boot disk

    disk {
        source_image = var.swarm_agent.windows.vm_image_name

        auto_delete = true
        boot = true

        disk_size_gb = each.value.boot_disk_size
        disk_type = "pd-ssd"
    }

    network_interface {

        network = var.agent_vms_network
        subnetwork = var.agent_vms_subnetwork

        access_config {

            // Auto-generate external IP

        }
    }

    service_account {
        email = var.agent_service_account_email
        scopes = [ "cloud-platform" ]
    }
}
