locals {
  wait = length(google_artifact_registry_repository_iam_member.build_artifact_uploader_access.etag)

  repository_id = "docker-build-artifacts"
}

resource "google_artifact_registry_repository" "build_artifacts" {
  provider = google-beta

  depends_on = [ var.module_depends_on ]

  location = var.location
  repository_id = local.repository_id
  description = "Docker build artifacts"
  format = "DOCKER"
}

resource "google_service_account" "build_artifact_uploader" {
  provider = google-beta

  depends_on = [ var.module_depends_on ]

  account_id   = "build-artifact-uploader"
  display_name = "Docker build artifact uploader"
}

resource "google_artifact_registry_repository_iam_member" "build_artifact_uploader_access" {
  provider = google-beta

  depends_on = [ var.module_depends_on ]

  location = google_artifact_registry_repository.build_artifacts.location
  repository = google_artifact_registry_repository.build_artifacts.name
  role   = "roles/artifactregistry.writer"
  member = "serviceAccount:${google_service_account.build_artifact_uploader.email}"
}
