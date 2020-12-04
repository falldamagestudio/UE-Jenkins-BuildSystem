
module "google_apis" {
  source = "../../../services/google_apis"
}

module "docker_build_artifacts" {
  module_depends_on = [module.google_apis.wait]

  source = "../../../services/docker_build_artifacts"

  location = var.build_artifacts_location
}

module "vm" {

  module_depends_on = [module.docker_build_artifacts.wait]

  source = "../../../services/vm"

  build_artifacts_location = var.build_artifacts_location
  build_artifacts_name = module.docker_build_artifacts.name

  name           = var.instance_name
  image          = var.image
  machine_type   = var.machine_type
  boot_disk_type = var.boot_disk_type
  boot_disk_size = var.boot_disk_size

  ssh_username = var.ssh_username
  ssh_pub_key_path = var.ssh_pub_key_path
}

module "slave_cluster" {

  module_depends_on = [module.vm.wait]

  source = "../../../services/slave_cluster"

  project_id = var.project_id
  cluster_name = "test-cluster"
  region = var.region
  zone = var.zone
}
