locals {
  wait = length(google_project_iam_member.image_builder_instance_controller_compute_admin.etag
  ) /*+ length(google_project_iam_member.image_builder_instance_controller_service_account_user.etag)*/
}

resource "google_service_account" "image_builder_instance_controller" {
  depends_on = [ var.module_depends_on ]

  account_id   = "image-builder-instance-ctl"
  display_name = "Management account for image builder VMs"
}

resource "google_project_iam_member" "image_builder_instance_controller_compute_admin" {
  depends_on = [ var.module_depends_on ]

  role   = "roles/compute.admin"
  member = "serviceAccount:${google_service_account.image_builder_instance_controller.email}"
}

resource "google_service_account_iam_member" "image_builder_instance_controller_service_account_user" {
  depends_on = [ var.module_depends_on ]

  service_account_id = var.build_artifact_uploader_service_account_name

  role   = "roles/iam.serviceAccountUser"
  member = "serviceAccount:${google_service_account.image_builder_instance_controller.email}"
}
