resource "google_compute_instance_template" "agent_template" {

    for_each = var.agent_templates

    name = each.key

    machine_type = each.value.machine_type

    // Add boot disk

    disk {
        source_image = each.value.vm_image_name

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
