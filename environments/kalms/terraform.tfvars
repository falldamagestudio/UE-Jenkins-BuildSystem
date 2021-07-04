project_id = "kalms-ue4-jenkins-buildsystem"
project_number = "220788758027"
region     = "europe-west1"
zone       = "europe-west1-b"

build_artifacts_location = "europe-west1"

external_ip_address_name = "jenkins-controller-external-ip-address"
internal_ip_address_name = "jenkins-controller-internal-ip-address"
internal_ip_address = "10.132.15.250"

longtail_store_bucket_name = "kalms-ue4-jenkins-longtail"
longtail_store_location = "europe-west1"

cloud_config_store_bucket_name = "kalms-ue4-jenkins-cloud-config"
cloud_config_store_location = "europe-west1"

allowed_login_domain = "falldamagestudio.com"

linux_ssh_agent_image = "projects/cos-cloud/global/images/cos-89-16108-403-26"
linux_ssh_agent_cloud_config_url = "https://storage.googleapis.com/kalms-ue4-jenkins-cloud-config/ue-jenkins-ssh-agent-vm/cloud-config-commit-c7e17b6.yaml"

linux_swarm_agent_image = "projects/cos-cloud/global/images/cos-89-16108-403-26"
linux_swarm_agent_cloud_config_url = "https://storage.googleapis.com/kalms-ue4-jenkins-cloud-config/ue-jenkins-swarm-agent-vm/cloud-config-commit-c7e17b6.yaml"
windows_swarm_agent_image = "projects/kalms-ue4-jenkins-buildsystem/global/images/ue-jenkins-swarm-agent-vm-c7e17b6-windows"

ssh_agent_image_url_linux = "europe-west1-docker.pkg.dev/kalms-ue4-jenkins-buildsystem/docker-build-artifacts/ue-jenkins-ssh-agent:commit-c7e17b6-linux"

swarm_agent_image_url_linux = "europe-west1-docker.pkg.dev/kalms-ue4-jenkins-buildsystem/docker-build-artifacts/ue-jenkins-swarm-agent:commit-c7e17b6-linux"
swarm_agent_image_url_windows = "europe-west1-docker.pkg.dev/kalms-ue4-jenkins-buildsystem/docker-build-artifacts/ue-jenkins-swarm-agent:commit-c7e17b6-windows"

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

linux_build_agent_templates = {
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
