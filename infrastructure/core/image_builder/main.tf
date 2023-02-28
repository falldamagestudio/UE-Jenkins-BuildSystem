resource "google_compute_network" "image_builder_network" {
  name = "image-builder-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "image_builder_subnetwork" {
  name          = "image-builder-subnetwork"
  ip_cidr_range = var.image_builder_subnetwork_cidr_range
  region        = var.region
  network       = google_compute_network.image_builder_network.id
}

// Cloud Builder and Packer both need to connect to instances via WinRM
resource "google_compute_firewall" "allow_winrm_ingress" {
  // This rule should have this specific name, since the Cloud Builder otherwise creates
  //  a new rule with this name
  name = "allow-winrm-ingress"
  
  network = google_compute_network.image_builder_network.name

  description = "Allow Windows image builder to connect to image builder VMs"

  allow {
    protocol = "tcp"
    ports = [ "5986" ]
  }
}

// Packer needs to connect to instances via ssh
resource "google_compute_firewall" "allow_ssh_ingress" {
  name = "image-builder-vms-allow-ssh-ingress"
  
  network = google_compute_network.image_builder_network.name

  description = "Allow Packer to connect to image builder VMs"

  allow {
    protocol = "tcp"
    ports = [ "22" ]
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

// Allow the instance controller account to read from GAR
// GitHub Actions needs this permission; it will peek into GAR to determine which images already exist
resource "google_artifact_registry_repository_iam_member" "image_builder_instance_controller_build_artifact_uploader_access" {
  provider = google-beta

  depends_on = [ var.module_depends_on ]

  location = var.build_artifact_registry_repository_location
  repository = var.build_artifact_registry_repository_name
  role   = "roles/artifactregistry.reader"
  member = "serviceAccount:${google_service_account.image_builder_instance_controller.email}"
}
