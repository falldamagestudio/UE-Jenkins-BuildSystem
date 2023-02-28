output "build_artifact_uploader_email" {
    value = google_service_account.build_artifact_uploader.email
}

output "build_artifact_uploader_service_account_name" {
    value = google_service_account.build_artifact_uploader.name
}

output "docker_registry" {
    value = "${var.location}-docker.pkg.dev/${var.project_id}/${local.repository_id}"
}

output "name" {
    value = google_artifact_registry_repository.build_artifacts.name
}
