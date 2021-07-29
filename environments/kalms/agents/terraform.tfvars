ssh_agent = {
    linux = {
        vm_image_name = "projects/cos-cloud/global/images/cos-89-16108-403-26"
        vm_cloud_config_url = "https://storage.googleapis.com/kalms-ue-jenkins-buildsystem-cloud-config/ue-jenkins-ssh-agent-vm/cloud-config-commit-ee70d9e.yaml"
        docker_image_url = "europe-west1-docker.pkg.dev/kalms-ue-jenkins-buildsystem/docker-build-artifacts/ue-jenkins-ssh-agent:commit-ee70d9e-linux"
    }
    windows = {
        vm_image_name = "projects/kalms-ue-jenkins-buildsystem/global/images/ue-jenkins-ssh-agent-vm-ee70d9e-windows"
        docker_image_url = "europe-west1-docker.pkg.dev/kalms-ue-jenkins-buildsystem/docker-build-artifacts/ue-jenkins-ssh-agent:commit-ee70d9e-windows"
    }
}

swarm_agent = {
    linux = {
        vm_image_name = "projects/cos-cloud/global/images/cos-89-16108-403-26"
        vm_cloud_config_url = "https://storage.googleapis.com/kalms-ue-jenkins-buildsystem-cloud-config/ue-jenkins-swarm-agent-vm/cloud-config-commit-ee70d9e.yaml"
        docker_image_url = "europe-west1-docker.pkg.dev/kalms-ue-jenkins-buildsystem/docker-build-artifacts/ue-jenkins-swarm-agent:commit-ee70d9e-linux"
    }
    windows = {
        vm_image_name = "projects/kalms-ue-jenkins-buildsystem/global/images/ue-jenkins-swarm-agent-vm-ee70d9e-windows"
        docker_image_url = "europe-west1-docker.pkg.dev/kalms-ue-jenkins-buildsystem/docker-build-artifacts/ue-jenkins-swarm-agent:commit-ee70d9e-windows"
    }
}

windows_build_agents = {
/*
    "build-engine-windows-git-docker" = {
        "machine_type" = "n1-standard-32"
        "boot_disk_size" = 50
        "persistent_disk_size" = 200
    }

    "build-game-windows-git-docker" = {
        "machine_type" = "n1-standard-4"
        "boot_disk_size" = 50
        "persistent_disk_size" = 200
    }

    "build-game-windows-plastic-docker" = {
        "machine_type" = "n1-standard-4"
        "boot_disk_size" = 50
        "persistent_disk_size" = 200
    }
*/
}

linux_build_agents = {
/*
    "build-engine-linux-git-docker" = {
        "machine_type" = "n1-standard-32"
        "boot_disk_size" = 50
        "persistent_disk_size" = 200
    }

    "build-game-linux-git-docker" = {
        "machine_type" = "n1-standard-8"
        "boot_disk_size" = 50
        "persistent_disk_size" = 200
    }

    "build-game-linux-plastic-docker" = {
        "machine_type" = "n1-standard-8"
        "boot_disk_size" = 50
        "persistent_disk_size" = 200
    }
*/
}

dynamic_agent_templates = {
    windows = {
/*
        "build-engine-windows" = {
            "machine_type" = "n1-standard-32"
            "boot_disk_size" = 200
        }
*/
        "build-game-windows" = {
            "machine_type" = "n1-standard-8"
            "boot_disk_size" = 200
        }
    }

    linux = {
/*
        "build-engine-linux" = {
            "machine_type" = "n1-standard-32"
            "boot_disk_size" = 50
            "persistent_disk_size" = 200
        }
*/
        "build-game-linux" = {
            "machine_type" = "n1-standard-8"
            "boot_disk_size" = 50
            "persistent_disk_size" = 200
        }
    }
}
