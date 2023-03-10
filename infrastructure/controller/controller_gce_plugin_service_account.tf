# Create a service account, that the Google Compute Engine plugin subsequently can use
#  for controlling VMs
resource "google_service_account" "gce_plugin_service_account" {

  account_id   = "gce-plugin-for-jenkins"
  display_name = "GCE Plugin for Jenkins"
}

// GCE plugin for Jenkins requires the account to to have the Compute Instance Admin (beta) role
resource "google_project_iam_member" "gce_plugin_compute_instance_admin" {

  // Grant the Compute Instance Admin (beta) role
  // Reference: https://cloud.google.com/compute/docs/access/iam#compute.instanceAdmin
  role   = "roles/compute.instanceAdmin"
  member = "serviceAccount:${google_service_account.gce_plugin_service_account.email}"
}

// GCE plugin for Jenkins requires the account to to have the Compute Network Admin role
resource "google_project_iam_member" "gce_plugin_compute_network_admin" {

  // Grant the Compute Network Admin role
  // Reference: https://cloud.google.com/compute/docs/access/iam#compute.networkAdmin
  role   = "roles/compute.networkAdmin"
  member = "serviceAccount:${google_service_account.gce_plugin_service_account.email}"
}

// GCE plugin for Jenkins requires the account to to have the Service Account User role
resource "google_project_iam_member" "gce_plugin_iam_service_account_user" {

  // Grant the Service Account User role
  // Reference: https://cloud.google.com/compute/docs/access/iam#iam.serviceAccountUser
  role   = "roles/iam.serviceAccountUser"
  member = "serviceAccount:${google_service_account.gce_plugin_service_account.email}"
}

# // Allow all users in access group to fetch builds from the storage bucket
# resource "google_storage_bucket_iam_member" "store_upload_access" {

#   bucket   = var.build_store_limited_duration_bucket_id
#   role     = "roles/storage.admin"
#   member = "serviceAccount:${google_service_account.gce_plugin_service_account.email}"
# }

resource "google_service_account_key" "gce_plugin_service_account_key" {
  service_account_id = google_service_account.gce_plugin_service_account.name
}

locals {

    gce_plugin_credential = {

        gce_plugin_service_account = {
          version = base64decode(google_service_account_key.gce_plugin_service_account_key.private_key)
        }
    }
}

resource "google_secret_manager_secret" "gce_plugin_credential" {

  for_each = local.gce_plugin_credential

  secret_id = each.key

  labels = {
    # This is a Secret text type credential, accessible to Jenkins via the GCP Secrets Manager Credentials Provider plugin
    jenkins-credentials-type = "service-account-private-key"
    jenkins-credentials-project-id = "fd-ue-jenkins-buildsystem"
  }

  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "gce_plugin_credential_version" {

  for_each = local.gce_plugin_credential

  secret = google_secret_manager_secret.gce_plugin_credential[each.key].id

  secret_data = each.value.version
}
