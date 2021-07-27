module "kubernetes_cluster" {

  source = "./kubernetes_cluster"

  project_id = var.project_id
  project_number = var.project_number
  region = var.region
  zone = var.zone

  kubernetes_network = var.kubernetes_network
  kubernetes_subnetwork = var.kubernetes_subnetwork
  kubernetes_subnetwork_id = var.kubernetes_subnetwork_id

  external_ip_address_name = var.external_ip_address_name
  internal_ip_address_name = var.internal_ip_address_name
  internal_ip_address = var.internal_ip_address

  longtail_store_bucket_id = var.longtail_store_bucket_name

  allowed_login_domain = var.allowed_login_domain
}

module "kubernetes_secrets_from_terraform" {

  source = "./kubernetes_secrets_from_terraform"

  depends_on = [ module.kubernetes_cluster.endpoint ]

  project_id = var.project_id
  region = var.region
  zone = var.zone

  external_ip_address_name = var.external_ip_address_name
  internal_ip_address_name = var.internal_ip_address_name

  longtail_store_bucket_name = var.longtail_store_bucket_name

  ssh_vm_private_key_windows = var.ssh_vm_private_key_windows
}
