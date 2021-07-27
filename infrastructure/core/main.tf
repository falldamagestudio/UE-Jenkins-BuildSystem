
module "google_apis" {
  source = "./google_apis"
}

module "network" {
  source = "./network"
}

module "docker_build_artifacts" {
  module_depends_on = [module.google_apis.wait]

  source = "./docker_build_artifacts"

  project_id = var.project_id
  location = var.build_artifacts_location
}

module "cloud_config_store" {

  module_depends_on = [module.google_apis.wait]

  source = "./cloud_config_store"

  bucket_name = var.cloud_config_store_bucket_name
  location = var.cloud_config_store_location
  build_artifact_uploader_email = module.docker_build_artifacts.build_artifact_uploader_email
}

module "image_builder" {

  module_depends_on = [module.google_apis.wait, module.cloud_config_store.wait]

  source = "./image_builder"

  region = var.region
  build_artifact_uploader_service_account_name = module.docker_build_artifacts.build_artifact_uploader_service_account_name
  cloud_config_store_bucket_id = var.cloud_config_store_bucket_name
}

module "longtail_store" {

  module_depends_on = [module.google_apis.wait]

  source = "./longtail_store"

  bucket_name = var.longtail_store_bucket_name
  location = var.longtail_store_location
}

module "ssh_vm_windows_auth" {

  module_depends_on = [module.google_apis.wait]

  source = "./ssh_vm_windows_auth"
}
