ssh_agent = {
    linux = {
        vm_image_name = "projects/cos-cloud/global/images/cos-89-16108-403-26"
        vm_cloud_config_url = "https://storage.googleapis.com/kalms-ue-jenkins-buildsystem-cloud-config/ue-jenkins-ssh-agent-vm/cloud-config-commit-54bf5a0.yaml"
        docker_image_url = "europe-west1-docker.pkg.dev/kalms-ue-jenkins-buildsystem/docker-build-artifacts/ue-jenkins-ssh-agent:commit-54bf5a0-linux"
    }
    windows = {
        vm_image_name = "projects/kalms-ue-jenkins-buildsystem/global/images/ue-jenkins-ssh-agent-vm-54bf5a0-windows"
        docker_image_url = "europe-west1-docker.pkg.dev/kalms-ue-jenkins-buildsystem/docker-build-artifacts/ue-jenkins-ssh-agent:commit-54bf5a0-windows"
    }
}

swarm_agent = {
    linux = {
        vm_image_name = "projects/cos-cloud/global/images/cos-89-16108-403-26"
        vm_cloud_config_url = "https://storage.googleapis.com/kalms-ue-jenkins-buildsystem-cloud-config/ue-jenkins-swarm-agent-vm/cloud-config-commit-54bf5a0.yaml"
        docker_image_url = "europe-west1-docker.pkg.dev/kalms-ue-jenkins-buildsystem/docker-build-artifacts/ue-jenkins-swarm-agent:commit-54bf5a0-linux"
    }
    windows = {
        vm_image_name = "projects/kalms-ue-jenkins-buildsystem/global/images/ue-jenkins-swarm-agent-vm-54bf5a0-windows"
        docker_image_url = "europe-west1-docker.pkg.dev/kalms-ue-jenkins-buildsystem/docker-build-artifacts/ue-jenkins-swarm-agent:commit-54bf5a0-windows"
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
            boot_disk_size = 200
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
            "persistent_disk_size" = 200
        }
    }

    windows = {
        "build-win64-static" = {
            machine_type = "n1-standard-8"
            boot_disk_size = 500
        }
    }
}

static_agents = {
    linux = {

        "build-linux-static" = {
            template = "build-linux-static"
            jenkins_labels = "build-engine-linux-git-docker build-game-linux-plastic-docker"
        }
/*
        "build-engine-linux-git-docker" = {
            template = "build-linux-static"
        }
        "build-game-linux-git-docker" = {
            template = "build-linux-static"
        }
        "build-game-linux-plastic-docker" = {
            template = "build-linux-static"
        }
*/
    }
    windows = {

        "build-win64-static" = {
            template = "build-win64-static"
            jenkins_labels = "build-engine-win64-git-docker build-game-win64-plastic-docker"
        }
/*
        "build-engine-win64-git-docker" = {
            template = "build-win64-static"
            jenkins_labels = "build-engine-win64-git-docker"
        }

        "build-game-win64-git-docker" = {
            template = "build-win64-static"
            jenkins_labels = "build-game-win64-git-docker"
        }

        "build-game-win64-plastic-docker" = {
            template = "build-win64-static"
            jenkins_labels = "build-game-win64-plastic-docker"
        }
*/
    }
}
