
module "google_apis" {
  source = "../services/google_apis"
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

module "kubernetes_cluster" {

  module_depends_on = [module.docker_build_artifacts.wait, module.image_builder.wait, module.longtail_store.wait]

  source = "../services/kubernetes_cluster"

  project_id = var.project_id
  project_number = var.project_number
  region = var.region
  zone = var.zone

  external_ip_address_name = var.external_ip_address_name
  internal_ip_address_name = var.internal_ip_address_name
  internal_ip_address = var.internal_ip_address

  longtail_store_bucket_id = var.longtail_store_bucket_name

  allowed_login_domain = var.allowed_login_domain
}

module "agent_vms" {

  module_depends_on = [module.kubernetes_cluster.wait, module.cloud_config_store.wait, module.longtail_store.wait]

  source = "../services/agent_vms"

  region = var.region
  linux_image = var.linux_swarm_agent_image
  linux_cloud_config_url = var.linux_swarm_agent_cloud_config_url
  windows_image = var.windows_swarm_agent_image
  windows_build_agents = var.windows_build_agents
  linux_build_agents = var.linux_build_agents
  linux_build_agent_templates = var.linux_build_agent_templates
  network_id = module.kubernetes_cluster.network_id
  cloud_config_store_bucket_id = var.cloud_config_store_bucket_name
  longtail_store_bucket_id = var.longtail_store_bucket_name
  kubernetes_network_id = module.kubernetes_cluster.network_id
  settings = {
    jenkins-url = "http://${var.internal_ip_address}"
    ssh-agent-image-url-linux = var.ssh_agent_image_url_linux
    swarm-agent-image-url-linux = var.swarm_agent_image_url_linux
    swarm-agent-image-url-windows = var.swarm_agent_image_url_windows
  }
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
  internal_ip_address_name = var.internal_ip_address_name

  longtail_store_bucket_name = var.longtail_store_bucket_name
}
