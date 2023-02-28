
module "google_apis" {
  source = "./google_apis"
}

module "network" {
  depends_on = [module.google_apis]

  source = "./network"

  agent_vms_subnetwork_cidr_range = var.agent_vms_subnetwork_cidr_range
  controller_vm_subnetwork_cidr_range = var.controller_vm_subnetwork_cidr_range
}

module "docker_build_artifacts" {
  depends_on = [module.google_apis]

  source = "./docker_build_artifacts"

  project_id = var.project_id
  location = var.build_artifacts_location
}

module "image_builder" {

  depends_on = [module.google_apis]

  source = "./image_builder"

  region = var.region
  build_artifact_uploader_service_account_name = module.docker_build_artifacts.build_artifact_uploader_service_account_name
  image_builder_subnetwork_cidr_range = var.image_builder_subnetwork_cidr_range
  build_artifact_registry_repository_location = var.build_artifacts_location
  build_artifact_registry_repository_name = module.docker_build_artifacts.name
}

module "longtail_store" {

  depends_on = [module.google_apis]

  source = "./longtail_store"

  bucket_name = var.longtail_store_bucket_name
  location = var.longtail_store_location
}

module "ssh_vm_windows_auth" {

  depends_on = [module.google_apis]

  source = "./ssh_vm_windows_auth"
}
