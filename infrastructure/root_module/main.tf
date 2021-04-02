
module "google_apis" {
  source = "../services/google_apis"
}

module "docker_build_artifacts" {
  module_depends_on = [module.google_apis.wait]

  source = "../services/docker_build_artifacts"

  project_id = var.project_id
  location = var.build_artifacts_location
}

module "image_builder" {
  module_depends_on = [module.google_apis.wait]

  source = "../services/image_builder"

  region = var.region
  build_artifact_uploader_service_account_name = module.docker_build_artifacts.build_artifact_uploader_service_account_name
}

module "longtail_store" {

  module_depends_on = [module.google_apis.wait]

  source = "../services/longtail_store"

  bucket_name = var.longtail_store_bucket_name
  location = var.longtail_store_location
}

module "kubernetes_cluster" {

  module_depends_on = [module.docker_build_artifacts.wait, module.image_builder.wait, module.longtail_store.wait]

  source = "../services/kubernetes_cluster"

  project_id = var.project_id
  project_number = var.project_number
  region = var.region
  zone = var.zone

  external_ip_address_name = var.external_ip_address_name

  longtail_store_bucket_id = var.longtail_store_bucket_name

  allowed_login_domain = var.allowed_login_domain
}

module "agent_vms" {

  module_depends_on = [module.kubernetes_cluster.wait, module.longtail_store.wait]

  source = "../services/agent_vms"

  region = var.region
  network_id = module.kubernetes_cluster.network_id
}

module "settings" {

  module_depends_on = [module.kubernetes_cluster.wait]

  source = "../services/settings"

  kubernetes_cluster_endpoint = module.kubernetes_cluster.endpoint
  kubernetes_cluster_ca_certificate = module.kubernetes_cluster.ca_certificate

  image_registry_prefix = "${module.docker_build_artifacts.docker_registry}"

  project_id = var.project_id
  region = var.region
  external_ip_address_name = var.external_ip_address_name

  longtail_store_bucket_name = var.longtail_store_bucket_name
}
