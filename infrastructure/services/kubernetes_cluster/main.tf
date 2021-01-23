locals {
  wait = length(module.kubernetes_cluster.endpoint
    ) + length(google_service_account.agent_service_account.id
    ) + length(google_project_iam_member.agent_build_artifact_downloader_access.id
    ) + length(google_storage_bucket_iam_member.agent_longtail_store_admin_access.id
    ) + length(google_service_account.controller_service_account.id
    ) + length(google_project_iam_member.controller_build_artifact_downloader_access.id
    ) + length(google_compute_global_address.external_ip_address.id)
}

module "kubernetes_cluster" {

  source                     = "./beta-public-cluster"

  module_depends_on          = [ var.module_depends_on ]

  project_id                 = var.project_id
  name                       = "jenkins"
  regional                   = false // This will be a single-zone cluster, with a single master in the given zone
  region                     = var.region
  zones                      = [var.zone]
  network                    = "default" // TODO: place cluster into separate network
  subnetwork                 = "default" // TODO: place cluster into separate sub network
  ip_range_pods              = "" // TODO: May need to specify name of IP range
  ip_range_services          = "" // TODO: May need to specify name of IP range
  http_load_balancing        = true
  horizontal_pod_autoscaling = true
  network_policy             = true

  // Workload Identity is not supported for Windows nodes on GKE.
  // Therefore we disable it for the entire cluster.
  // https://cloud.google.com/kubernetes-engine/docs/how-to/workload-identity#limitations
  identity_namespace         = "null"

  // Expose all VM metadata to pods. This is less secure than ideally.
  // We should either enable Metadata Concealment, or wait for
  // GKE to support Workload Identity for Windows nodes.
  // https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_cluster#node_metadata
  node_metadata              = "EXPOSE"

  node_pools = [
    {
      name               = "jenkins-controller-node-pool"
      machine_type       = "n1-standard-2"
      node_locations     = var.zone
      min_count          = 1
      max_count          = 1
      local_ssd_count    = 0
      disk_size_gb       = 10
      disk_type          = "pd-standard"
      image_type         = "COS"
      auto_repair        = true
      auto_upgrade       = true
      service_account    = google_service_account.controller_service_account.email
      preemptible        = false
      initial_node_count = 1
    },

    {
      name               = "jenkins-agent-linux-node-pool"
      machine_type       = "n1-standard-32"
      node_locations     = var.zone
      min_count          = 0
      max_count          = 10
      local_ssd_count    = 0
      disk_size_gb       = 100
      disk_type          = "pd-ssd"
      image_type         = "COS"
      auto_repair        = true
      auto_upgrade       = true
      service_account    = google_service_account.agent_service_account.email
      preemptible        = false
      initial_node_count = 0
    },

    {
      name               = "jenkins-agent-windows-node-pool"
      machine_type       = "n1-standard-32"
      node_locations     = var.zone
      min_count          = 0
      max_count          = 10
      local_ssd_count    = 0
      disk_size_gb       = 100
      disk_type          = "pd-ssd"
      image_type         = "WINDOWS_LTSC"
      auto_repair        = true
      auto_upgrade       = true
      service_account    = google_service_account.agent_service_account.email
      preemptible        = false
      initial_node_count = 0

      enable_secure_boot = false // Windows nodes do not support Shielded Instance features
      enable_integrity_monitoring = false // Windows nodes do not support Shielded Instance features
    },
  ]

  node_pools_oauth_scopes = {
    all = []

    jenkins-controller-node-pool = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]

    jenkins-agent-linux-node-pool = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]

    jenkins-agent-windows-node-pool = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }

  node_pools_labels = {
    all = {}

    jenkins-controller-node-pool = {
      jenkins-controller-node-pool = true
    }

    jenkins-agent-linux-node-pool = {
      jenkins-agent-linux-node-pool = true
    }

    jenkins-agent-windows-node-pool = {
      jenkins-agent-windows-node-pool = true
    }
  }

  node_pools_metadata = {
    all = {}

    jenkins-controller-node-pool = {
      node-pool-metadata-custom-value = "my-node-pool"
    }
    jenkins-agent-linux-node-pool = {
      node-pool-metadata-custom-value = "my-node-pool"
    }
    jenkins-agent-windows-node-pool = {
      node-pool-metadata-custom-value = "my-node-pool"
    }
  }

  node_pools_taints = {
    all = []

    jenkins-controller-node-pool = [
    ]

    jenkins-agent-linux-node-pool = [
      {
        key    = "jenkins-agent-linux-node-pool"
        value  = true
        effect = "NO_SCHEDULE"
      },
    ]

    jenkins-agent-windows-node-pool = [
      {
        key    = "jenkins-agent-windows-node-pool"
        value  = true
        effect = "NO_SCHEDULE"
      },

      // GKE automatically adds this taint for Windows node pools
      {
        key    = "node.kubernetes.io/os"
        value  = "windows"
        effect = "NO_SCHEDULE"
      },
    ]
  }

  node_pools_tags = {
    all = []

    jenkins-controller-node-pool = [
      "jenkins-controller-node-pool",
    ]

    jenkins-agent-linux-node-pool = [
      "jenkins-agent-linux-node-pool",
    ]

    jenkins-agent-windows-node-pool = [
      "jenkins-agent-windows-node-pool",
    ]
  }
}

resource "google_service_account" "agent_service_account" {
  depends_on = [ var.module_depends_on ]

  account_id   = "ue4-jenkins-agent-node"
  display_name = "UE4 Jenkins Agent Node"
}

# Allow agent nodes to download artifacts from all repositories in project
resource "google_project_iam_member" "agent_build_artifact_downloader_access" {
  depends_on = [ var.module_depends_on ]

  role   = "roles/artifactregistry.reader"
  member = "serviceAccount:${google_service_account.agent_service_account.email}"
}

# Allow agent nodes to manage content in Longtail store
resource "google_storage_bucket_iam_member" "agent_longtail_store_admin_access" {
  depends_on = [ var.module_depends_on ]

  bucket   = var.longtail_store_bucket_id
  role     = "roles/storage.admin"
  member = "serviceAccount:${google_service_account.agent_service_account.email}"
}

resource "google_service_account" "controller_service_account" {
  depends_on = [ var.module_depends_on ]

  account_id   = "ue4-jenkins-controller-node"
  display_name = "UE4 Jenkins Controller Node"
}

# Allow controller node to download artifacts from all repositories in project
resource "google_project_iam_member" "controller_build_artifact_downloader_access" {
  depends_on = [ var.module_depends_on ]

  role   = "roles/artifactregistry.reader"
  member = "serviceAccount:${google_service_account.controller_service_account.email}"
}

resource "google_compute_global_address" "external_ip_address" {
  depends_on = [ var.module_depends_on ]

  name = var.external_ip_address_name
}
