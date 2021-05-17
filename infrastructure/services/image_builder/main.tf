locals {
  wait = length(google_compute_network.image_builder_network.id
    ) + length(google_compute_subnetwork.image_builder_subnetwork.id
    ) + length(google_compute_firewall.allow_winrm_ingress.id
    ) + length(google_service_account.image_builder_instance_controller.id
    ) + length(google_project_iam_member.image_builder_instance_controller_compute_admin.etag
    ) + length(google_project_iam_member.image_builder_instance_controller_compute_instance_admin_v1.etag
    ) + length(google_service_account_iam_member.image_builder_instance_controller_service_account_user.etag
    ) + length(google_storage_bucket_iam_member.image_builder_instance_controller_cloud_config_store_admin_access.id)
}

resource "google_compute_network" "image_builder_network" {
  name = "image-builder-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "image_builder_subnetwork" {
  name          = "image-builder-subnetwork"
  ip_cidr_range = "10.138.0.0/20"
  region        = var.region
  network       = google_compute_network.image_builder_network.id
}

// Cloud Builder and Packer both need to connect to instances via WinRM
resource "google_compute_firewall" "allow_winrm_ingress" {
  name = "allow-winrm-ingress"
  
  network = google_compute_network.image_builder_network.name

  description = "Allow Windows image builder to connect to image builder VMs"

  allow {
    protocol = "tcp"
    ports = [ "5986" ]
  }
}

resource "google_service_account" "image_builder_instance_controller" {
  depends_on = [ var.module_depends_on ]

  account_id   = "image-builder-instance-ctl"
  display_name = "Management account for image builder VMs"
}

// Cloud Builder requires the instance controller account to to have the Compute Admin role
resource "google_project_iam_member" "image_builder_instance_controller_compute_admin" {
  depends_on = [ var.module_depends_on ]

  // Grant the Compute Admin role
  // Reference: https://cloud.google.com/compute/docs/access/iam#compute.admin
  role   = "roles/compute.admin"
  member = "serviceAccount:${google_service_account.image_builder_instance_controller.email}"
}

// Packer requires the instance controller account to have the Compute Instance Admin (v1) role
resource "google_project_iam_member" "image_builder_instance_controller_compute_instance_admin_v1" {
  depends_on = [ var.module_depends_on ]

  // Grant the Compute Instance Admin (v1) role
  // Reference: https://cloud.google.com/compute/docs/access/iam#compute.instanceAdmin.v1
  role   = "roles/compute.instanceAdmin.v1"
  member = "serviceAccount:${google_service_account.image_builder_instance_controller.email}"
}

// Allow the instance controller account to use the artifact uploader account
// Cloud Builder needs this permission; it will use the artifact uploader account from within the running instance
resource "google_service_account_iam_member" "image_builder_instance_controller_service_account_user" {
  depends_on = [ var.module_depends_on ]

  service_account_id = var.build_artifact_uploader_service_account_name

  // Grant the Service Account User role
  // Reference: https://cloud.google.com/compute/docs/access/iam#iam.serviceAccountUser
  role   = "roles/iam.serviceAccountUser"
  member = "serviceAccount:${google_service_account.image_builder_instance_controller.email}"
}

// Allow the instance controller account to manage content in cloud-config store
resource "google_storage_bucket_iam_member" "image_builder_instance_controller_cloud_config_store_admin_access" {
  depends_on = [ var.module_depends_on ]

  bucket   = var.cloud_config_store_bucket_id
  role     = "roles/storage.admin"
  member = "serviceAccount:${google_service_account.image_builder_instance_controller.email}"
}
