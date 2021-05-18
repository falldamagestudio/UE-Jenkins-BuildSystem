locals {
  wait = length(google_storage_bucket.store.self_link
     ) + length(google_storage_bucket_iam_member.build_artifact_uploader_cloud_config_store_admin_access.id)
}

resource "google_storage_bucket" "store" {
  depends_on = [ var.module_depends_on ]

  name          = var.bucket_name
  location      = var.location
  force_destroy = true

  uniform_bucket_level_access = true
}

// Allow build artifact uploader account to manage content in cloud-config store
resource "google_storage_bucket_iam_member" "build_artifact_uploader_cloud_config_store_admin_access" {
  depends_on = [ var.module_depends_on ]

  bucket   = var.bucket_name
  role     = "roles/storage.admin"
  member = "serviceAccount:${var.build_artifact_uploader_email}"
}
