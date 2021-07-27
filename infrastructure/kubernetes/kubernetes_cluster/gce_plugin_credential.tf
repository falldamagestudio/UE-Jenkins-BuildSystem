# Create a service account, that the Google Compute Engine plugin subsequently can use
#  for controlling VMs
resource "google_service_account" "gce_plugin_service_account" {

  account_id   = "gce-plugin-for-jenkins"
  display_name = "GCE Plugin for Jenkins"
}

// GCE plugin for Jenkins requires the account to to have the Compute Instance Admin (beta) role
resource "google_project_iam_member" "gce_plugin_compute_instance_admin" {

  // Grant the Compute Instance Admin (beta) role
  // Reference: https://cloud.google.com/compute/docs/access/iam#compute.instanceAdmin
  role   = "roles/compute.instanceAdmin"
  member = "serviceAccount:${google_service_account.gce_plugin_service_account.email}"
}

// GCE plugin for Jenkins requires the account to to have the Compute Network Admin role
resource "google_project_iam_member" "gce_plugin_compute_network_admin" {

  // Grant the Compute Network Admin role
  // Reference: https://cloud.google.com/compute/docs/access/iam#compute.networkAdmin
  role   = "roles/compute.networkAdmin"
  member = "serviceAccount:${google_service_account.gce_plugin_service_account.email}"
}

// GCE plugin for Jenkins requires the account to to have the Service Account User role
resource "google_project_iam_member" "gce_plugin_iam_service_account_user" {

  // Grant the Service Account User role
  // Reference: https://cloud.google.com/compute/docs/access/iam#iam.serviceAccountUser
  role   = "roles/iam.serviceAccountUser"
  member = "serviceAccount:${google_service_account.gce_plugin_service_account.email}"
}

resource "google_service_account_key" "gce_plugin_service_account_key" {

  service_account_id = google_service_account.gce_plugin_service_account.name
}
