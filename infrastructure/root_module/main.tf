
module "google_apis" {
  source = "../../../services/google_apis"
}

module "docker_build_artifacts" {
  module_depends_on = [module.google_apis.wait]

  source = "../../../services/docker_build_artifacts"

  project_id = var.project_id
  location = var.build_artifacts_location
}

module "kubernetes_cluster" {

  module_depends_on = [module.docker_build_artifacts.wait]

  source = "../../../services/kubernetes_cluster"

  project_id = var.project_id
  region = var.region
  zone = var.zone

  external_ip_address_name = var.external_ip_address_name
}

module "settings" {

  module_depends_on = [module.kubernetes_cluster.wait]

  source = "../../../services/settings"

  kubernetes_cluster_endpoint = module.kubernetes_cluster.endpoint
  kubernetes_cluster_ca_certificate = module.kubernetes_cluster.ca_certificate

  image_registry_prefix = "${module.docker_build_artifacts.docker_registry}"

  project_id = var.project_id
  region = var.region
  external_ip_address_name = var.external_ip_address_name
}
