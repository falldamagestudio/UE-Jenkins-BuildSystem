output "build_artifact_uploader_email" {
    value = google_service_account.build_artifact_uploader.email
}

output "name" {
    value = google_artifact_registry_repository.build_artifacts.name
}
