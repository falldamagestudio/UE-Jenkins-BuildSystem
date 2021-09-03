# Configuration for Docker Dynamic VMs

docker_ssh_agent = {
    linux = {
        vm_image_name = "projects/cos-cloud/global/images/cos-89-16108-403-26"
        vm_cloud_config_url = "https://storage.googleapis.com/fd-ue-jenkins-buildsystem-cloud-config/docker-ssh-agent-vm/cloud-config-commit-ff94206.yaml"
        docker_image_url = "europe-west1-docker.pkg.dev/fd-ue-jenkins-buildsystem/docker-build-artifacts/ssh-agent:commit-ff94206-linux"
    }
    windows = {
        vm_image_name = "projects/fd-ue-jenkins-buildsystem/global/images/docker-ssh-agent-ff94206-windows"
        docker_image_url = "europe-west1-docker.pkg.dev/fd-ue-jenkins-buildsystem/docker-build-artifacts/ssh-agent:commit-ff94206-windows"
    }
}

docker_dynamic_agent_templates = {
    linux = {
        "build-engine-linux-docker-dynamic" = {
            machine_type = "n1-standard-32"
            boot_disk_type = "pd-balanced"
            boot_disk_size = 50
            persistent_disk_type = "pd-balanced"
            persistent_disk_size = 200
            preemptible = true
        }

        "build-game-linux-docker-dynamic" = {
            machine_type = "n1-standard-8"
            boot_disk_type = "pd-balanced"
            boot_disk_size = 50
            persistent_disk_type = "pd-balanced"
            persistent_disk_size = 200
            preemptible = true
        }
    }

    windows = {
        "build-engine-win64-docker-dynamic" = {
            machine_type = "n1-standard-32"
            boot_disk_type = "pd-balanced"
            boot_disk_size = 500
            preemptible = true
        }

        "build-game-win64-docker-dynamic" = {
            machine_type = "n1-standard-8"
            boot_disk_type = "pd-balanced"
            boot_disk_size = 200
            preemptible = true
        }
    }
}
