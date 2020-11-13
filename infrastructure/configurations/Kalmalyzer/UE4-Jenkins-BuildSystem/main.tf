
module "google_apis" {
  source = "../../../services/google_apis"
}

module "vm" {

  depends_on = [module.google_apis]

  source = "../../../services/vm"

  name           = var.instance_name
  image          = var.image
  machine_type   = var.machine_type
  boot_disk_type = var.boot_disk_type
  boot_disk_size = var.boot_disk_size

  ssh_username = var.ssh_username
  ssh_pub_key_path = var.ssh_pub_key_path
}
