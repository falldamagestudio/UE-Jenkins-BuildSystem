locals {
  wait = length(module.kubernetes_cluster.endpoint
    ) + length(google_compute_network.kubernetes_network.id
    ) + length(google_compute_subnetwork.kubernetes_subnetwork.id
    ) + length(google_compute_subnetwork.internal_lb_subnetwork.id
    ) + length(google_service_account.agent_service_account.id
    ) + length(google_project_iam_member.agent_build_artifact_downloader_access.id
    ) + length(google_storage_bucket_iam_member.agent_longtail_store_admin_access.id
    ) + length(google_service_account.controller_service_account.id
    ) + length(google_project_iam_member.controller_build_artifact_downloader_access.id
    ) + length(google_compute_global_address.external_ip_address.id
    ) + length(google_compute_address.internal_ip_address.id
    ) + length(google_service_account.build_job_service_account.id
    ) + length(google_storage_bucket_iam_member.build_job_longtail_store_admin_access.id
    ) + length(google_service_account_key.build_job_service_account_key.id
    ) + length(kubernetes_secret.build_job_gcp_service_account_key.id
    ) + length(google_iap_web_iam_member.access_iap_policy.id)
}

resource "google_compute_network" "kubernetes_network" {
  depends_on = [ var.module_depends_on ]

  name = "kubernetes-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "kubernetes_subnetwork" {
  depends_on = [ var.module_depends_on ]

  name          = "kubernetes-subnetwork"
  ip_cidr_range = "10.132.0.0/20" // TODO: parameterize
  region        = var.region
  network       = google_compute_network.kubernetes_network.id

  secondary_ip_range = [
    {
      range_name    = "kubernetes-subnetwork-pods"
      ip_cidr_range = "10.24.0.0/14" // TODO: parameterize
    },
    {
      range_name    = "kubernetes-subnetwork-services"
      ip_cidr_range = "10.28.0.0/20" // TODO: parameterize
    }
  ]
}

resource "google_compute_subnetwork" "internal_lb_subnetwork" {
  depends_on = [ var.module_depends_on ]

  provider = google-beta

  name          = "internal-lb-subnetwork"
  purpose       = "INTERNAL_HTTPS_LOAD_BALANCER"
  role          = "ACTIVE"
  ip_cidr_range = "10.134.0.0/24" // TODO: parameterize
  region        = var.region
  network       = google_compute_network.kubernetes_network.id
}

resource "google_compute_firewall" "kubernetes_allow_internal_traffic" {
  depends_on = [ var.module_depends_on ]

  name = "kubernetes-allow-internal-traffic"
  
  network = google_compute_network.kubernetes_network.name

  description = "Allow internal traffic on the Kubernetes network"

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "udp"
    ports = [ "0-65535" ]
  }

  allow {
    protocol = "tcp"
    ports = [ "0-65535" ]
  }

  source_ranges = [ "10.132.0.0/20", "10.134.0.0/24" ] // TODO: use parameterized values
}

module "kubernetes_cluster" {

  source                     = "./beta-public-cluster"

  module_depends_on          = [ var.module_depends_on ]

  project_id                 = var.project_id
  name                       = "jenkins"
  regional                   = false // This will be a single-zone cluster, with a single master in the given zone
  region                     = var.region
  zones                      = [var.zone]
  network                    = google_compute_network.kubernetes_network.name
  subnetwork                 = google_compute_subnetwork.kubernetes_subnetwork.name
  ip_range_pods              = "kubernetes-subnetwork-pods" // TODO: refer to this by object, not string
  ip_range_services          = "kubernetes-subnetwork-services" // TODO: refer to this by object, not string
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
      disk_size_gb       = 50
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
      machine_type       = "n1-standard-16"
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
      machine_type       = "n1-standard-16"
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

resource "google_compute_address" "internal_ip_address" {
  depends_on = [ var.module_depends_on ]

  name = var.internal_ip_address_name
  subnetwork = google_compute_subnetwork.kubernetes_subnetwork.id
  address_type = "INTERNAL"
  address = "10.132.15.250" // TODO: parameterize
  purpose = "GCE_ENDPOINT"
}

resource "google_iap_web_iam_member" "access_iap_policy" {
  depends_on = [ var.module_depends_on ]

  provider  = google-beta

  role      = "roles/iap.httpsResourceAccessor"
  # Configure which users/groups/domains will be accepted by Identity-Aware Proxy
  # Reference: https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/iap_web_iam#argument-reference
  member    = "domain:${var.allowed_login_domain}"
}

///////////////////////////////////////////////////////////////////

resource "google_service_account" "build_job_service_account" {
  depends_on = [ var.module_depends_on ]

  account_id   = "ue4-jenkins-build-job"
  display_name = "UE4 Jenkins build job"
}

# Allow build jobs to manage content in Longtail store
resource "google_storage_bucket_iam_member" "build_job_longtail_store_admin_access" {
  depends_on = [ var.module_depends_on ]

  bucket   = var.longtail_store_bucket_id
  role     = "roles/storage.admin"
  member = "serviceAccount:${google_service_account.build_job_service_account.email}"
}

resource "google_service_account_key" "build_job_service_account_key" {
  depends_on = [ var.module_depends_on ]

  service_account_id = google_service_account.build_job_service_account.name
}

# Make service account key available within Jenkins jobs
# This will be picked up by the Kubernetes Credentials Provider plugin
#  and be visible in the Credentials manager in Jenkins
#
# This allows build jobs to use the following construct:
#
#     withCredentials([[$class: 'FileBinding',
#                       credentialsId: 'build-job-gcp-service-account-key',
#                       variable: 'GOOGLE_APPLICATION_CREDENTIALS']]) { ... }
#
#   and any applications invoked within the scope that use the GCP Client Library
#   will use the service account as identity when interacting with GCP
#
# Reference: https://github.com/jenkinsci/google-oauth-plugin/issues/6#issuecomment-431424049
# Reference: https://cloud.google.com/docs/authentication/production#automatically
# Reference: https://jenkinsci.github.io/kubernetes-credentials-provider-plugin/examples/
# Reference: https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_service_account_key

resource "kubernetes_secret" "build_job_gcp_service_account_key" {
  depends_on = [ var.module_depends_on ]

  metadata {
    # Credential name is the identifier used in the withCredentials() call
    name = "build-job-gcp-service-account-key"
    labels = {
      "jenkins.io/credentials-type" = "secretFile"
    }
    annotations = {
      "jenkins.io/credentials-description" : "Service Account used by build jobs to access GCP resources"
    }
  }

  type = "Opaque"

  data = {
    # Private key file (JSON format) for a service account in GCP
    "data" = base64decode(google_service_account_key.build_job_service_account_key.private_key)

    # File name is not used in practice, but required by Jenkins nevertheless
    "filename" = "build-job-gcp-service-account-key.json"
  }
}
