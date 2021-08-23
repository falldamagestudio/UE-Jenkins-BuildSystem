# Docker-based configurations
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

docker_swarm_agent = {
    linux = {
        vm_image_name = "projects/cos-cloud/global/images/cos-89-16108-403-26"
        vm_cloud_config_url = "https://storage.googleapis.com/fd-ue-jenkins-buildsystem-cloud-config/docker-swarm-agent-vm/cloud-config-commit-ff94206.yaml"
        docker_image_url = "europe-west1-docker.pkg.dev/fd-ue-jenkins-buildsystem/docker-build-artifacts/swarm-agent:commit-ff94206-linux"
    }
    windows = {
        vm_image_name = "projects/fd-ue-jenkins-buildsystem/global/images/docker-swarm-agent-ff94206-windows"
        docker_image_url = "europe-west1-docker.pkg.dev/fd-ue-jenkins-buildsystem/docker-build-artifacts/swarm-agent:commit-ff94206-windows"
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
        }

        "build-game-linux-docker-dynamic" = {
            machine_type = "n1-standard-8"
            boot_disk_type = "pd-balanced"
            boot_disk_size = 50
            persistent_disk_type = "pd-balanced"
            persistent_disk_size = 200
        }
    }

    windows = {
        "build-engine-win64-docker-dynamic" = {
            machine_type = "n1-standard-32"
            boot_disk_type = "pd-balanced"
            boot_disk_size = 500
        }

        "build-game-win64-docker-dynamic" = {
            machine_type = "n1-standard-8"
            boot_disk_type = "pd-balanced"
            boot_disk_size = 200
        }
    }
}

docker_static_agent_templates = {
    linux = {
        "build-linux-docker-static" = {
            "machine_type" = "n1-standard-8"
            boot_disk_type = "pd-balanced"
            boot_disk_size = 50
            persistent_disk_type = "pd-balanced"
            persistent_disk_size = 300
        }
    }

    windows = {
        "build-win64-docker-static" = {
            machine_type = "n1-standard-8"
            boot_disk_type = "pd-balanced"
            boot_disk_size = 600
        }
    }
}

docker_static_agents = {
    linux = {
/*
        "build-linux-docker-static" = {
            template = "build-linux-docker-static"
            jenkins_labels = "build-engine-linux-git-docker-static build-game-linux-git-docker-static build-game-linux-plastic-docker-static"
        }
*/
    }
    windows = {
/*
        "build-win64-docker-static" = {
            template = "build-win64-docker-static"
            jenkins_labels = "build-engine-win64-git-docker-static build-game-win64-git-docker-static build-game-win64-plastic-docker-static"
        }
*/
    }
}

# Non-Docker based configurations

ssh_agent = {
    windows = {
        vm_image_name = "projects/fd-ue-jenkins-buildsystem/global/images/ssh-agent-ff94206-windows"
    }
}

swarm_agent = {
    windows = {
        vm_image_name = "projects/fd-ue-jenkins-buildsystem/global/images/swarm-agent-ff94206-windows"
    }
}

dynamic_agent_templates = {
    windows = {
        "build-engine-win64-dynamic" = {
            machine_type = "n1-standard-32"
            boot_disk_type = "pd-balanced"
            boot_disk_size = 500
        }

        "build-game-win64-dynamic" = {
            machine_type = "n1-standard-8"
            boot_disk_type = "pd-balanced"
            boot_disk_size = 200
        }
    }
}

static_agent_templates = {
    windows = {
        "build-win64-static" = {
            machine_type = "n1-standard-8"
            boot_disk_type = "pd-balanced"
            boot_disk_size = 600
        }
    }
}

static_agents = {
    windows = {

        "build-win64-static" = {
            template = "build-win64-static"
            jenkins_labels = "build-engine-win64-git-static build-game-win64-git-static build-game-win64-plastic-static"
        }

    }
}
