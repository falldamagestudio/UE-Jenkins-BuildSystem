agent_template_groups = [

/*
    # Dynamic VM templates (Linux)

    {
        vm_image_name = "projects/fd-ue-jenkins-buildsystem/global/images/ssh-agent-018e7be-linux"

        agent_templates = {
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
    },

    # Dynamic VM templates (Windows)

    {
        vm_image_name = "projects/fd-ue-jenkins-buildsystem/global/images/ssh-agent-018e7be-windows"

        agent_templates = {
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
    },
*/
/*
    # Static VM templates (Linux)

    {
        vm_image_name = "projects/fd-ue-jenkins-buildsystem/global/images/swarm-agent-018e7be-linux"

        agent_templates = {
            "build-linux-static" = {
                machine_type = "n1-standard-8"
                boot_disk_type = "pd-balanced"
                boot_disk_size = 600
                preemptible = false
            }
        }
    },

    # Static VM templates (Windows)

    {
        vm_image_name = "projects/fd-ue-jenkins-buildsystem/global/images/swarm-agent-018e7be-windows"

        agent_templates = {
            "build-win64-static" = {
                machine_type = "n1-standard-8"
                boot_disk_type = "pd-balanced"
                boot_disk_size = 600
                preemptible = false
            }
        }
    },
*/
]

static_agents = {

    # Static agents are normally disabled, to avoid unexpected costs when developing on the build system

/*
    # Static VMs (Linux)

    "build-linux-static" = {
        template = "build-linux-static"
        jenkins_labels = "build-engine-linux-git-static build-game-linux-git-static build-game-linux-plastic-static"
    },

    # Static VMs (Windows)

    "build-win64-static" = {
        template = "build-win64-static"
        jenkins_labels = "build-engine-win64-git-static build-game-win64-git-static build-game-win64-plastic-static"
    }
*/
}
