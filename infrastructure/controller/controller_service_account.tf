resource "google_service_account" "controller_service_account" {

  account_id   = "ue-jenkins-controller-vm"
  display_name = "UE Jenkins Controller VM"
}

resource "google_service_account_key" "controller_service_account_key" {

  service_account_id = google_service_account.controller_service_account.name
}

# Allow controller VM to download artifacts from all repositories in project
resource "google_project_iam_member" "controller_build_artifact_downloader_access" {

  role   = "roles/artifactregistry.reader"
  member = "serviceAccount:${google_service_account.controller_service_account.email}"
}

# Allow controller VM to manage content in Longtail store
resource "google_storage_bucket_iam_member" "controller_longtail_store_admin_access" {

  bucket   = var.longtail_store_bucket_name
  role     = "roles/storage.admin"
  member = "serviceAccount:${google_service_account.controller_service_account.email}"
}

# Allow controller VM to send log messages to Cloud Logging
resource "google_project_iam_member" "controller_cloud_logging_write_access" {

  role   = "roles/logging.logWriter"
  member = "serviceAccount:${google_service_account.controller_service_account.email}"
}

# Allow controller VM to send events to Cloud Monitoring
resource "google_project_iam_member" "controller_cloud_monitoring_write_access" {

  role   = "roles/monitoring.metricWriter"
  member = "serviceAccount:${google_service_account.controller_service_account.email}"
}

# Allow controller VM to access the payload of all secrets in project
resource "google_project_iam_member" "controller_secret_manager_secret_accessor" {

  role   = "roles/secretmanager.secretAccessor"
  member = "serviceAccount:${google_service_account.controller_service_account.email}"
}

# Allow controller VM to view metadata of all secrets in project
resource "google_project_iam_member" "controller_secret_manager_viewer" {

  role   = "roles/secretmanager.viewer"
  member = "serviceAccount:${google_service_account.controller_service_account.email}"
}
