module "slave_cluster" {

  source                     = "./beta-public-cluster"

  project_id                 = var.project_id
  name                       = var.cluster_name
  region                     = var.region
  zones                      = [var.zone]
  network                    = "default" // TODO: place cluster into separate network
  subnetwork                 = "default" // TODO: place cluster into separate sub network
  ip_range_pods              = "" // TODO: May need to specify name of IP range
  ip_range_services          = "" // TODO: May need to specify name of IP range
  http_load_balancing        = false
  horizontal_pod_autoscaling = true
  network_policy             = true

  node_pools = [
    {
      name               = "default-node-pool"
      machine_type       = "e2-medium"
      node_locations     = var.zone
      min_count          = 1
      max_count          = 100
      local_ssd_count    = 0
      disk_size_gb       = 100
      disk_type          = "pd-standard"
      image_type         = "COS"
      auto_repair        = true
      auto_upgrade       = true
      service_account    = google_service_account.slave_service_account.email
      preemptible        = false
      initial_node_count = 80
    },
  ]

  node_pools_oauth_scopes = {
    all = []

    default-node-pool = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }

  node_pools_labels = {
    all = {}

    default-node-pool = {
      default-node-pool = true
    }
  }

  node_pools_metadata = {
    all = {}

    default-node-pool = {
      node-pool-metadata-custom-value = "my-node-pool"
    }
  }

  node_pools_taints = {
    all = []

    default-node-pool = [
      {
        key    = "default-node-pool"
        value  = true
        effect = "PREFER_NO_SCHEDULE"
      },
    ]
  }

  node_pools_tags = {
    all = []

    default-node-pool = [
      "default-node-pool",
    ]
  }
}

resource "google_service_account" "slave_service_account" {
  account_id   = "ue4-jenkins-slave-node"
  display_name = "UE4 Jenkins Slave Node"
}
