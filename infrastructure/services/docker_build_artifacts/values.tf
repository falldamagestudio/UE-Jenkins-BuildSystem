output "wait" {
  description = "An output to use when you want to depend on cmd finishing"
  value       = local.wait
}

output "build_artifact_uploader_email" {
    value = google_service_account.build_artifact_uploader.email
}

output "docker_registry" {
    value = "${var.location}-docker.pkg.dev/${var.project_id}/${local.repository_id}"
}

output "name" {
    value = google_artifact_registry_repository.build_artifacts.name
}
