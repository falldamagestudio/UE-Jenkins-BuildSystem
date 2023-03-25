agent_template_groups = [

    # Dynamic VM templates (Linux)

    {
        vm_image_name = "projects/fd-ue-jenkins-buildsystem/global/images/ssh-agent-6086a18-linux"

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
        vm_image_name = "projects/fd-ue-jenkins-buildsystem/global/images/ssh-agent-23a0fbc-windows"

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
]
