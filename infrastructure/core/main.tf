
module "google_apis" {
  source = "../services/google_apis"
}

module "network" {
  source = "../services/network"
}

module "docker_build_artifacts" {
  module_depends_on = [module.google_apis.wait]

  source = "../services/docker_build_artifacts"

  project_id = var.project_id
  location = var.build_artifacts_location
}

module "cloud_config_store" {

  module_depends_on = [module.google_apis.wait]

  source = "../services/cloud_config_store"

  bucket_name = var.cloud_config_store_bucket_name
  location = var.cloud_config_store_location
  build_artifact_uploader_email = module.docker_build_artifacts.build_artifact_uploader_email
}

module "image_builder" {

  module_depends_on = [module.google_apis.wait, module.cloud_config_store.wait]

  source = "../services/image_builder"

  region = var.region
  build_artifact_uploader_service_account_name = module.docker_build_artifacts.build_artifact_uploader_service_account_name
  cloud_config_store_bucket_id = var.cloud_config_store_bucket_name
}

module "longtail_store" {

  module_depends_on = [module.google_apis.wait]

  source = "../services/longtail_store"

  bucket_name = var.longtail_store_bucket_name
  location = var.longtail_store_location
}

module "ssh_vm_windows_auth" {

  module_depends_on = [module.google_apis.wait]

  source = "../services/ssh_vm_windows_auth"
}
