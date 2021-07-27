locals {
  wait = length(google_storage_bucket.store.self_link)
}

resource "google_storage_bucket" "store" {
  name          = var.bucket_name
  location      = var.location
  force_destroy = true

  uniform_bucket_level_access = true
}
