# Configuration for Static VMs
/*
swarm_agent = {
    linux = {
        vm_image_name = "projects/fd-ue-jenkins-buildsystem/global/images/swarm-agent-018e7be-linux"
    }
    windows = {
        vm_image_name = "projects/fd-ue-jenkins-buildsystem/global/images/swarm-agent-018e7be-windows"
    }
}

static_agent_templates = {
    linux = {
        "build-linux-static" = {
            machine_type = "n1-standard-8"
            boot_disk_type = "pd-balanced"
            boot_disk_size = 600
            preemptible = false
         }
    }
    windows = {
        "build-win64-static" = {
            machine_type = "n1-standard-8"
            boot_disk_type = "pd-balanced"
            boot_disk_size = 600
            preemptible = false
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
*/