# Configuration for Docker Static VMs

/*
docker_swarm_agent = {
    linux = {
        vm_image_name = "projects/cos-cloud/global/images/cos-89-16108-403-26"
        vm_cloud_config_url = "https://storage.googleapis.com/fd-ue-jenkins-buildsystem-cloud-config/docker-swarm-agent-vm/cloud-config-commit-c95061a.yaml"
        docker_image_url = "europe-west1-docker.pkg.dev/fd-ue-jenkins-buildsystem/docker-build-artifacts/swarm-agent:commit-c95061a-linux"
    }
    windows = {
        vm_image_name = "projects/fd-ue-jenkins-buildsystem/global/images/docker-swarm-agent-c95061a-windows"
        docker_image_url = "europe-west1-docker.pkg.dev/fd-ue-jenkins-buildsystem/docker-build-artifacts/swarm-agent:commit-c95061a-windows"
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
            preemptible = false
        }
    }

    windows = {
        "build-win64-docker-static" = {
            machine_type = "n1-standard-8"
            boot_disk_type = "pd-balanced"
            boot_disk_size = 600
            preemptible = false
        }
    }
}

docker_static_agents = {
    linux = {
        "build-linux-docker-static" = {
            template = "build-linux-docker-static"
            jenkins_labels = "build-engine-linux-git-docker-static build-game-linux-git-docker-static build-game-linux-plastic-docker-static"
        }
    }
    windows = {
        "build-win64-docker-static" = {
            template = "build-win64-docker-static"
            jenkins_labels = "build-engine-win64-git-docker-static build-game-win64-git-docker-static build-game-win64-plastic-docker-static"
        }
    }
}
*/
