locals {
  
  all_pools = merge({
    "jenkins-controller-node-pool" = {
      os = "linux"
      machine_type = var.node_pools.controller.machine_type
      disk_type = var.node_pools.controller.disk_type
      disk_size = var.node_pools.controller.disk_size
      min_nodes = 1
      max_nodes = 1
    }},
  var.node_pools.agent_pools)
}

module "kubernetes_cluster" {

  source                     = "terraform-google-modules/kubernetes-engine/google"
  version                    = "16.0.1"

  project_id                 = var.project_id
  name                       = "jenkins"
  regional                   = false // This will be a single-zone cluster, with a single master in the given zone
  region                     = var.region
  zones                      = [var.zone]
  network                    = var.kubernetes_network
  subnetwork                 = var.kubernetes_subnetwork
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

  node_pools = concat(
    [{
      name               = "jenkins-controller-node-pool"
      machine_type       = var.node_pools.controller.machine_type
      node_locations     = var.zone
      min_count          = 1
      max_count          = 1
      local_ssd_count    = 0
      disk_size_gb       = var.node_pools.controller.disk_size
      disk_type          = var.node_pools.controller.disk_type
      image_type         = "COS"
      auto_repair        = true
      auto_upgrade       = true
      service_account    = google_service_account.controller_service_account.email
      preemptible        = false
      initial_node_count = 1
    }],

    [ for key, value in var.node_pools.agent_pools : {
      name               = key
      machine_type       = value.machine_type
      node_locations     = var.zone
      min_count          = value.min_nodes
      max_count          = value.max_nodes
      local_ssd_count    = 0
      disk_size_gb       = value.disk_size
      disk_type          = value.disk_type
      image_type         = value.os == "windows" ? "WINDOWS_LTSC" : "COS"
      auto_repair        = true
      auto_upgrade       = true
      service_account    = google_service_account.agent_service_account.email
      preemptible        = false
      initial_node_count = value.min_nodes

      // Windows nodes do not support Shielded Instance features
      // For Linux, we could activate Secure Boot - but we aren't doing so yet
      enable_secure_boot = false 

      // Windows nodes do not support Shielded Instance features
      enable_integrity_monitoring = (value.os == "windows" ? false : true) 
    }]
  )

  # All pools receive full cloud-platform scopes
  node_pools_oauth_scopes = {
    for key, value in local.all_pools : 
      key => [
        "https://www.googleapis.com/auth/cloud-platform"
      ]
  }

  # All pools receive a key looking like this:
  #   jenkins-<mypoolname>-node-pool = true
  #
  node_pools_labels = {
    for key, value in local.all_pools : 
      key => {
        "${key}" = true
      }
  }

  # All pools receive a key looking like this:
  #   node-pool-metadata-custom-value = "my-node-pool"
  #
  node_pools_metadata = {
    for key, value in local.all_pools : 
      key => {
        node-pool-metadata-custom-value = "my-node-pool"
      }
  }

  # Controller pool receives no taints
  #
  # All agent pools receive this taint:
  #          key    = "jenkins-<mypoolname>-node-pool"
  #          value  = true
  #          effect = "NO_SCHEDULE"
  #
  # In addition, all Windows agent pools receive this taint:
  #          key    = "node.kubernetes.io/os"
  #          value  = "windows"
  #          effect = "NO_SCHEDULE"
  # (GKE will automatically set that taint for any Windows pools)
  #
  node_pools_taints = merge({
      jenkins-controller-node-pool = []
    },
    {
      for key, value in var.node_pools.agent_pools : 
        key => [
          {
            key    = "${key}"
            value  = true
            effect = "NO_SCHEDULE"
          },
        ] if value.os == "linux"
    },
        {
      for key, value in var.node_pools.agent_pools : 
        key => [
          {
            key    = "${key}"
            value  = true
            effect = "NO_SCHEDULE"
          },

          // GKE automatically adds this taint for Windows node pools
          {
            key    = "node.kubernetes.io/os"
            value  = "windows"
            effect = "NO_SCHEDULE"
          },
        ] if value.os == "windows"
    })

  # All pools receive a tag looking like this:
  #   jenkins-<mypoolname>-node-pool = jenkins-<mypoolname>-node-pool
  #
  node_pools_tags = {
    for key, value in local.all_pools : 
      key => [
        "${key}"
      ]
  }
}

resource "google_service_account" "agent_service_account" {

  account_id   = "ue4-jenkins-agent-node"
  display_name = "UE4 Jenkins Agent Node"
}

# Allow agent nodes to download artifacts from all repositories in project
resource "google_project_iam_member" "agent_build_artifact_downloader_access" {

  role   = "roles/artifactregistry.reader"
  member = "serviceAccount:${google_service_account.agent_service_account.email}"
}

# Allow agent nodes to manage content in Longtail store
resource "google_storage_bucket_iam_member" "agent_longtail_store_admin_access" {

  bucket   = var.longtail_store_bucket_id
  role     = "roles/storage.admin"
  member = "serviceAccount:${google_service_account.agent_service_account.email}"
}

resource "google_service_account" "controller_service_account" {

  account_id   = "ue4-jenkins-controller-node"
  display_name = "UE4 Jenkins Controller Node"
}

# Allow controller node to download artifacts from all repositories in project
resource "google_project_iam_member" "controller_build_artifact_downloader_access" {

  role   = "roles/artifactregistry.reader"
  member = "serviceAccount:${google_service_account.controller_service_account.email}"
}

resource "google_compute_global_address" "external_ip_address" {

  name = var.external_ip_address_name
}

resource "google_compute_address" "internal_ip_address" {

  name = var.internal_ip_address_name
  subnetwork = var.kubernetes_subnetwork_id
  address_type = "INTERNAL"
  address = var.internal_ip_address
  purpose = "GCE_ENDPOINT"
}

resource "google_iap_web_iam_member" "access_iap_policy" {

  role      = "roles/iap.httpsResourceAccessor"
  # Configure which users/groups/domains will be accepted by Identity-Aware Proxy
  # Reference: https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/iap_web_iam#argument-reference
  member    = "domain:${var.allowed_login_domain}"
}

///////////////////////////////////////////////////////////////////

resource "google_service_account" "build_job_service_account" {

  account_id   = "ue4-jenkins-build-job"
  display_name = "UE4 Jenkins build job"
}

# Allow build jobs to manage content in Longtail store
resource "google_storage_bucket_iam_member" "build_job_longtail_store_admin_access" {

  bucket   = var.longtail_store_bucket_id
  role     = "roles/storage.admin"
  member = "serviceAccount:${google_service_account.build_job_service_account.email}"
}

resource "google_service_account_key" "build_job_service_account_key" {

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
