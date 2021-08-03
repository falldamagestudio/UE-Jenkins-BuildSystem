ssh_agent = {
    linux = {
        vm_image_name = "projects/cos-cloud/global/images/cos-89-16108-403-26"
        vm_cloud_config_url = "https://storage.googleapis.com/kalms-ue-jenkins-buildsystem-cloud-config/ue-jenkins-ssh-agent-vm/cloud-config-commit-53901af.yaml"
        docker_image_url = "europe-west1-docker.pkg.dev/kalms-ue-jenkins-buildsystem/docker-build-artifacts/ue-jenkins-ssh-agent:commit-53901af-linux"
    }
    windows = {
        vm_image_name = "projects/kalms-ue-jenkins-buildsystem/global/images/ue-jenkins-ssh-agent-vm-53901af-windows"
        docker_image_url = "europe-west1-docker.pkg.dev/kalms-ue-jenkins-buildsystem/docker-build-artifacts/ue-jenkins-ssh-agent:commit-53901af-windows"
    }
}

swarm_agent = {
    linux = {
        vm_image_name = "projects/cos-cloud/global/images/cos-89-16108-403-26"
        vm_cloud_config_url = "https://storage.googleapis.com/kalms-ue-jenkins-buildsystem-cloud-config/ue-jenkins-swarm-agent-vm/cloud-config-commit-53901af.yaml"
        docker_image_url = "europe-west1-docker.pkg.dev/kalms-ue-jenkins-buildsystem/docker-build-artifacts/ue-jenkins-swarm-agent:commit-53901af-linux"
    }
    windows = {
        vm_image_name = "projects/kalms-ue-jenkins-buildsystem/global/images/ue-jenkins-swarm-agent-vm-53901af-windows"
        docker_image_url = "europe-west1-docker.pkg.dev/kalms-ue-jenkins-buildsystem/docker-build-artifacts/ue-jenkins-swarm-agent:commit-53901af-windows"
    }
}

dynamic_agent_templates = {
    linux = {
        "build-engine-linux-dynamic" = {
            machine_type = "n1-standard-32"
            boot_disk_size = 50
            persistent_disk_size = 200
        }

        "build-game-linux-dynamic" = {
            machine_type = "n1-standard-8"
            boot_disk_size = 50
            persistent_disk_size = 200
        }
    }

    windows = {
        "build-engine-win64-dynamic" = {
            machine_type = "n1-standard-32"
            boot_disk_size = 500
        }

        "build-game-win64-dynamic" = {
            machine_type = "n1-standard-8"
            boot_disk_size = 200
        }
    }
}

static_agent_templates = {
    linux = {
        "build-linux-static" = {
            "machine_type" = "n1-standard-8"
            "boot_disk_size" = 50
            "persistent_disk_size" = 300
        }
    }

    windows = {
        "build-win64-static" = {
            machine_type = "n1-standard-8"
            boot_disk_size = 600
        }
    }
}

static_agents = {
    linux = {
        "build-linux-static" = {
            template = "build-linux-static"
            jenkins_labels = "build-engine-linux-git-static build-game-linux-git-static build-game-linux-plastic-static"
        }
    }
    windows = {
        "build-win64-static" = {
            template = "build-win64-static"
            jenkins_labels = "build-engine-win64-git-static build-game-win64-git-static build-game-win64-plastic-static"
        }
    }
}
