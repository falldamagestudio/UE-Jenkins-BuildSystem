output "wait" {
  description = "An output to use when you want to depend on cmd finishing"
  value       = local.wait
}

output "build_artifact_uploader_email" {
    value = google_service_account.build_artifact_uploader.email
}

output "name" {
    value = google_artifact_registry_repository.build_artifacts.name
}
