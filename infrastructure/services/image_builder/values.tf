output "wait" {
  description = "An output to use when you want to depend on cmd finishing"
  value       = local.wait
}

output "image_builder_instance_controller_email" {
    value = google_service_account.image_builder_instance_controller.email
}
