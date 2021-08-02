
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
            disk_type = "pd-ssd"
            disk_size = 100
            min_nodes = 0
            max_nodes = 10
        }

        "jenkins-agent-windows-node-pool" = {
            os = "windows"
            machine_type = "n1-standard-16"
            disk_type = "pd-ssd"
            disk_size = 100
            min_nodes = 0
            max_nodes = 10
        }
    }
}