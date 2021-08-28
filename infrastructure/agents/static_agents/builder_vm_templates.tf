resource "google_compute_instance_template" "linux_agent_template" {

    for_each = var.static_agent_templates.linux

    name = each.key

    machine_type = each.value.machine_type

    // Add boot disk

    disk {
        source_image = var.swarm_agent.linux.vm_image_name

        auto_delete = true
        boot = true

        disk_type = each.value.boot_disk_type
        disk_size_gb = each.value.boot_disk_size
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

resource "google_compute_instance_template" "windows_agent_template" {

    for_each = var.static_agent_templates.windows

    name = each.key

    machine_type = each.value.machine_type

    // Add boot disk

    disk {
        source_image = var.swarm_agent.windows.vm_image_name

        auto_delete = true
        boot = true

        disk_type = each.value.boot_disk_type
        disk_size_gb = each.value.boot_disk_size
    }

    network_interface {

        network = var.agent_vms_network
        subnetwork = var.agent_vms_subnetwork

        access_config {

            // Auto-generate external IP

        }
    }

    scheduling {
        automatic_restart = !each.value.preemptible
        preemptible = each.value.preemptible
    }

    service_account {
        email = var.agent_service_account_email
        scopes = [ "cloud-platform" ]
    }
}
