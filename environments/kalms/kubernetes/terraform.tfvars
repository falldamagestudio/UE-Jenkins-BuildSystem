
allowed_login_domain = "falldamagestudio.com"

node_pools = {
    controller = {
        machine_type = "n1-standard-2"
        disk_type = "pd-standard"
        disk_size = 50
    }

    agent_pools = {
        "jenkins-agent-linux-node-pool" = {
            os = "linux"
            machine_type = "n1-standard-16"
            disk_type = "pd-standard"
            disk_size = 300         # Dimensioned to have enough storage to run a "build engine linux" job without a separate PVC
            min_nodes = 0
            max_nodes = 2
        }

        "jenkins-agent-windows-node-pool" = {
            os = "windows"
            machine_type = "n1-standard-16"
            disk_type = "pd-standard"
            disk_size = 500         # Dimensioned to have enough storage to run a "build engine win64" job without a separate PVC
            min_nodes = 0
            max_nodes = 2
        }
    }
}