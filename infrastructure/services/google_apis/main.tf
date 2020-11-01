locals {
  google_apis = [
    "compute.googleapis.com",
    "iap.googleapis.com"
  ]
}

resource "google_project_service" "this" {

  for_each = toset(local.google_apis)

  service = each.key

  disable_on_destroy = false
}

# Wait 30 seconds between enabling Google APIs and attempting to use them
#
# While the google_project_service resource does wait for the API to become enabled,
#   the enabling is in practice eventually consistent - and some calls may fail even
#   after GCP claims that the API is free to use.
#
# See https://github.com/terraform-providers/terraform-provider-google/issues/2129 for some discussion

resource "time_sleep" "wait_30_seconds" {
  depends_on = [ google_project_service.this ]

  create_duration = "30s"
}
