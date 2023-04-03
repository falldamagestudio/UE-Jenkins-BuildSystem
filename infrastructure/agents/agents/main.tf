resource "google_service_account" "agent_service_account" {

  account_id   = "ue-jenkins-agent-vm"
  display_name = "UE Jenkins Agent VM"
}

resource "google_service_account_key" "agent_service_account_key" {

  service_account_id = google_service_account.agent_service_account.name
}

# Allow agent VMs to download artifacts from all repositories in project
resource "google_project_iam_member" "agent_build_artifact_downloader_access" {

  role   = "roles/artifactregistry.reader"
  member = "serviceAccount:${google_service_account.agent_service_account.email}"
}

# Allow agent VMs to manage content in Longtail store
resource "google_storage_bucket_iam_member" "agent_longtail_store_admin_access" {

  bucket   = var.longtail_store_bucket_id
  role     = "roles/storage.admin"
  member = "serviceAccount:${google_service_account.agent_service_account.email}"
}

# Allow agent VMs to send log messages to Cloud Logging
resource "google_project_iam_member" "agent_cloud_logging_write_access" {

  role   = "roles/logging.logWriter"
  member = "serviceAccount:${google_service_account.agent_service_account.email}"
}

# Allow agent VMs to access the payload of all secrets in project

resource "google_project_iam_member" "controller_secret_manager_secret_accessor" {

  role   = "roles/secretmanager.secretAccessor"
  member = "serviceAccount:${google_service_account.agent_service_account.email}"
}

# Allow agent VMs to view metadata of all secrets in project
resource "google_project_iam_member" "controller_secret_manager_viewer" {

  role   = "roles/secretmanager.viewer"
  member = "serviceAccount:${google_service_account.agent_service_account.email}"
}
