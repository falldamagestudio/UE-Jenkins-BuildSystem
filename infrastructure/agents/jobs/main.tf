resource "google_service_account" "build_job_service_account" {

  account_id   = "ue-jenkins-build-job"
  display_name = "UE Jenkins build job"
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
# This will be picked up by the GCP Secret Manager Credentials Provider plugin
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
# Reference: https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_service_account_key

locals {

    build_job_secrets = {
        build-job-gcp-service-account-key = {
          version = base64decode(google_service_account_key.build_job_service_account_key.private_key)
          labels = {
            jenkins-credentials-type = "file"
            jenkins-credentials-filename = "build-job-gcp-service-account-key"
            jenkins-credentials-file-extension = "json"
          }
        }
    }
}

resource "google_secret_manager_secret" "build_job_secret" {

  for_each = local.build_job_secrets

  secret_id = each.key

  labels = each.value.labels

  replication {
    automatic = true
  }
}

# TODO: reintroduce this to give controller access to secrets
# resource "google_secret_manager_secret_iam_member" "build_job_secret_agent_access" {

#   for_each = local.build_job_secrets

#   secret_id = google_secret_manager_secret.build_job_secret[each.key].secret_id
#   role = "roles/secretmanager.secretAccessor"
#   # TODO: this should be the Controller SA, not the build job SA
#   member = "serviceAccount:${google_service_account.agent_service_account.email}"
# }

resource "google_secret_manager_secret_version" "build_job_secret_version" {

  for_each = local.build_job_secrets

  secret = google_secret_manager_secret.build_job_secret[each.key].id

  secret_data = each.value.version
}
