# Configuration for Dynamic VMs

ssh_agent = {
    linux = {
        vm_image_name = "projects/fd-ue-jenkins-buildsystem/global/images/ssh-agent-f486ec9-linux"
    }
    windows = {
        vm_image_name = "projects/fd-ue-jenkins-buildsystem/global/images/ssh-agent-f486ec9-windows"
    }
}

dynamic_agent_templates = {
    linux = {
        "build-engine-linux-dynamic" = {
            machine_type = "n1-standard-32"
            boot_disk_type = "pd-balanced"
            boot_disk_size = 500
            preemptible = false
        }

        "build-game-linux-dynamic" = {
            machine_type = "n1-standard-8"
            boot_disk_type = "pd-balanced"
            boot_disk_size = 200
            preemptible = false
        }
    }
    windows = {
        "build-engine-win64-dynamic" = {
            machine_type = "n1-standard-32"
            boot_disk_type = "pd-balanced"
            boot_disk_size = 500
            preemptible = false
        }

        "build-game-win64-dynamic" = {
            machine_type = "n1-standard-8"
            boot_disk_type = "pd-balanced"
            boot_disk_size = 200
            preemptible = false
        }
    }
}
