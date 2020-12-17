data "google_client_config" "default" {
  provider = google-beta
}

provider "kubernetes" {
  version                = "~> 1.10, != 1.11.0"
  load_config_file       = false
  host                   = "https://${module.kubernetes_cluster.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.kubernetes_cluster.ca_certificate)
}
