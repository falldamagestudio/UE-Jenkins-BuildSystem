locals {
  wait = length(google_project_iam_member.image_builder_instance_controller_compute_admin.etag
    ) + length(google_compute_network.image_builder_network.id
    ) + length(google_compute_subnetwork.image_builder_subnetwork.id
  ) /*+ length(google_project_iam_member.image_builder_instance_controller_service_account_user.etag)*/
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
