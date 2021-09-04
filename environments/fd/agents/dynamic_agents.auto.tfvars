# Configuration for Dynamic VMs

ssh_agent = {
    linux = {
        vm_image_name = "projects/fd-ue-jenkins-buildsystem/global/images/ssh-agent-c95061a-linux"
    }
    windows = {
        vm_image_name = "projects/fd-ue-jenkins-buildsystem/global/images/ssh-agent-c95061a-windows"
    }
}

dynamic_agent_templates = {
    linux = {
        "build-engine-linux-dynamic" = {
            machine_type = "n1-standard-32"
            boot_disk_type = "pd-balanced"
            boot_disk_size = 500
            preemptible = true
        }

        "build-game-linux-dynamic" = {
            machine_type = "n1-standard-8"
            boot_disk_type = "pd-balanced"
            boot_disk_size = 200
            preemptible = true
        }
    }
    windows = {
        "build-engine-win64-dynamic" = {
            machine_type = "n1-standard-32"
            boot_disk_type = "pd-balanced"
            boot_disk_size = 500
            preemptible = true
        }

        "build-game-win64-dynamic" = {
            machine_type = "n1-standard-8"
            boot_disk_type = "pd-balanced"
            boot_disk_size = 200
            preemptible = true
        }
    }
}
