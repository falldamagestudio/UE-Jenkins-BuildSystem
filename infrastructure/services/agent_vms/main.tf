locals {
  wait = length(google_compute_network.agent_vms.id
  ) + length(google_compute_subnetwork.agent_vms.id
  ) + length(google_compute_firewall.agent_vms_allow_winrm.id
  ) + length(google_compute_firewall.agent_vms_allow_ssh.id
  ) + length(google_service_account.agent_service_account.id
  ) + length(google_service_account_key.agent_service_account_key.id
  ) + length(google_storage_bucket_iam_member.agent_cloud_config_downloader_access.id
  ) + length(google_project_iam_member.agent_build_artifact_downloader_access.id
  ) + length(google_storage_bucket_iam_member.agent_longtail_store_admin_access.id
  ) + length(google_project_iam_member.agent_cloud_logging_write_access.id
  ) + length(google_compute_network_peering.kubernetes_network_agent_vms_peering.id
  ) + length(google_compute_network_peering.agent_vms_kubernetes_network_peering.id)
  // TODO: include secrets
  // TODO: include builder VMs
}

resource "google_compute_network" "agent_vms" {
  depends_on = [ var.module_depends_on ]

  name          = "agent-vms"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "agent_vms" {
  depends_on = [ var.module_depends_on ]

  name          = "agent-vms" // TODO: include region in name
  ip_cidr_range = "10.133.0.0/20" // TODO: Parameterize
  region        = var.region
  network       = google_compute_network.agent_vms.name
}

resource "google_compute_firewall" "agent_vms_allow_winrm" {
  depends_on = [ var.module_depends_on ]

  name = "agent-vms-allow-winrm"
  
  network = google_compute_network.agent_vms.name

  description = "Allow WinRM to agent VMs"

  allow {
    protocol = "tcp"
    ports = [ "5985","5986" ]
  }

  source_ranges = [ "0.0.0.0/0" ]
}

resource "google_compute_firewall" "agent_vms_allow_ssh" {
  depends_on = [ var.module_depends_on ]

  name = "agent-vms-allow-ssh"
  
  network = google_compute_network.agent_vms.name

  description = "Allow SSH to agent VMs"

  allow {
    protocol = "tcp"
    ports = [ "22" ]
  }

  source_ranges = [ "0.0.0.0/0" ]
}

resource "google_service_account" "agent_service_account" {
  depends_on = [ var.module_depends_on ]

  account_id   = "ue4-jenkins-agent-vm"
  display_name = "UE4 Jenkins Agent VM"
}

resource "google_service_account_key" "agent_service_account_key" {
  depends_on = [ var.module_depends_on ]

  service_account_id = google_service_account.agent_service_account.name
}

// Allow agent VMs to read config files from the cloud-config store
resource "google_storage_bucket_iam_member" "agent_cloud_config_downloader_access" {
  depends_on = [ var.module_depends_on ]

  bucket   = var.cloud_config_store_bucket_id
  role     = "roles/storage.admin"
  member = "serviceAccount:${google_service_account.agent_service_account.email}"
}

# Allow agent VMs to download artifacts from all repositories in project
resource "google_project_iam_member" "agent_build_artifact_downloader_access" {
  depends_on = [ var.module_depends_on ]

  role   = "roles/artifactregistry.reader"
  member = "serviceAccount:${google_service_account.agent_service_account.email}"
}

# Allow agent VMs to manage content in Longtail store
resource "google_storage_bucket_iam_member" "agent_longtail_store_admin_access" {
  depends_on = [ var.module_depends_on ]

  bucket   = var.longtail_store_bucket_id
  role     = "roles/storage.admin"
  member = "serviceAccount:${google_service_account.agent_service_account.email}"
}

# Allow agent VMs to send log messages to Cloud Logging
resource "google_project_iam_member" "agent_cloud_logging_write_access" {
  depends_on = [ var.module_depends_on ]

  role   = "roles/logging.logWriter"
  member = "serviceAccount:${google_service_account.agent_service_account.email}"
}

