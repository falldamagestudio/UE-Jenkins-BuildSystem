
module "google_apis" {
  source = "../../../services/google_apis"
}

module "docker_build_artifacts" {
  module_depends_on = [module.google_apis.wait]

  source = "../../../services/docker_build_artifacts"

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
