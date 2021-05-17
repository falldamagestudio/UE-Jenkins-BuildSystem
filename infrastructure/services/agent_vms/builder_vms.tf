
locals {

    linux_build_agents = {
/*
        "build-game-linux-git-docker2" = {
            "name" = "build-game-linux-git-docker"
            "machine_type" = "n1-standard-8"
            "boot_disk_size" = 50
            "persistent_disk_size" = 200
        }
*/
    }

    linux_build_agent_cloud_init = file("../../../UE-Jenkins-Images/ue-jenkins-agent-vms/linux-gce-cos/ue-jenkins-swarm-agent-vm-cloud-config.yaml")
}

resource "google_compute_instance" "linux_build_agent" {

    for_each = local.linux_build_agents

    name = each.value.name

    machine_type = each.value.machine_type

    boot_disk {

        initialize_params {
            size = each.value.boot_disk_size
            type = "pd-ssd"
            image = "projects/cos-cloud/global/images/cos-89-16108-403-26" // TODO: Move to config
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
        user-data = local.linux_build_agent_cloud_init
    }
}

resource "google_compute_disk" "linux_build_agent_pd" {
 
    for_each = local.linux_build_agents
    name  = "${each.value.name}-pd"
    size =  each.value.persistent_disk_size
    type  = "pd-ssd"
}
